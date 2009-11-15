//
//  FlickrDataService.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/28/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "FlickrDataService.h"
#import "CVLibrary.h"
#import "DemoItem.h"
#import "SampleAPIKey.h"

@interface FlickrDataService()
- (void) loadImageForUrl:(NSDictionary *) args;
- (NSString *) filePathFromUrl:(NSString *) url;
- (NSData *) cachedImageDataForUrl:(NSString *) url;
- (BOOL) saveImageData:(NSData *) imageData forUrl:(NSString *) url;
@end

@implementation FlickrDataService
@synthesize delegate = delegate_;

- (void) dealloc {
    [context_ release], context_ = nil;
    [operationQueue_ release], operationQueue_ = nil;
    [super dealloc];
}

#define CONCURRENT_DOWNLOADS 4

- (id) init {
    self = [super init];
    if (self != nil) {
        operationQueue_ = [[NSOperationQueue alloc] init];
        [operationQueue_ setMaxConcurrentOperationCount:CONCURRENT_DOWNLOADS];
        context_ = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY 
                                                sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
    }
    return self;
}

#define CACHE_DIR_NAME @"flickrCache"

- (void) cleanupDiskCache {
	// We don't want left over saves from previous sessions...
    NSString *cacheDirPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), CACHE_DIR_NAME];
    
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:cacheDirPath error:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (void) beginLoadDemoData {    
    OFFlickrAPIRequest *request = [[OFFlickrAPIRequest alloc] initWithAPIContext:context_];
    [request setDelegate:self];
    
    [request callAPIMethodWithGET:@"flickr.interestingness.getList" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"50", @"per_page", nil]];
}

- (void) beginLoadDemoDataForPage:(NSUInteger) pageNo {
    if (pageNo == 0) 
        return;
    OFFlickrAPIRequest *request = [[OFFlickrAPIRequest alloc] initWithAPIContext:context_];
    [request setDelegate:self];
    
    NSString *page = [NSString stringWithFormat:@"%d", pageNo];
    [request callAPIMethodWithGET:@"flickr.interestingness.getList" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"50", @"per_page", page, @"page", nil]];
        
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary {
    NSMutableArray *demoItems = [[[NSMutableArray alloc] init] autorelease];
    NSInteger count = [[inResponseDictionary valueForKeyPath:@"photos.photo"] count];
    for (int i = 0; i < count; i++) {
        NSDictionary *photoDict = [[inResponseDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:i];
        NSNumber *demoItemId = [NSNumber numberWithInt:i];
        NSString *title = [photoDict valueForKey:@"title"];
        NSURL *url = [context_ photoSourceURLFromDictionary:photoDict size:OFFlickrThumbnailSize];
        NSString *urlString = [url absoluteString];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:demoItemId, @"demo_item_id", title, @"title", urlString, @"image_url", nil];
        DemoItem *demoItem = [[DemoItem alloc] initWithDictionary:dict];
        [demoItems addObject:demoItem];
        [demoItem release];
    }
    [self.delegate performSelectorOnMainThread:@selector(updatedWithItems:) withObject:demoItems waitUntilDone:YES];

}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError {
    
}

- (void) beginLoadImageForUrl:(NSString *) url {
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:url, @"url", nil];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImageForUrl:) object:args];
    [operationQueue_ addOperation:operation];
    [operation release];
}

- (NSString *) filePathFromUrl:(NSString *) url {
    NSString *filePath = [NSString stringWithFormat:@"%@%@/%@", NSTemporaryDirectory(), CACHE_DIR_NAME, [url lastPathComponent] ];
    return filePath;
}

- (NSData *) cachedImageDataForUrl:(NSString *) url {
    NSData *imageData = nil;
    NSString *filePath = [self filePathFromUrl:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        imageData = [NSData dataWithContentsOfFile:filePath];
    }

    return imageData;
}

- (BOOL) saveImageData:(NSData *) imageData forUrl:(NSString *) url {
    // Check if the temp dir exists
    NSString *dirPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), CACHE_DIR_NAME];
    BOOL isDirectory;
    BOOL pathExists = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirectory];
    
    NSError *error;
    if (!(pathExists && isDirectory)){
        // Create the directory
        if (![[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    // Now save the image data
    NSString *filePath = [self filePathFromUrl:url];
    
    return [imageData writeToFile:filePath atomically:NO];
}

- (void) loadImageForUrl:(NSDictionary *) args {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *url = [args objectForKey:@"url"];
    NSData *data = [self cachedImageDataForUrl:url];
    if (nil == data) {
        // Image not cached yet, load it from the url location        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        // Save to cache
        [self saveImageData:data forUrl:url];        
    }
    
    UIImage *image = [UIImage imageWithData:data];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", url, @"url", nil];
    [self.delegate performSelectorOnMainThread:@selector(updatedImage:) withObject:dict waitUntilDone:YES];    
    [pool release];
}

- (UIImage *) selectedImageForUrl:(NSString *) url {
    UIImage *image = nil;
    NSData *data = [self cachedImageDataForUrl:url];
    if (nil != data) {
        image = [UIImage imageWithData:data];
    }
    return image;
}

@end
