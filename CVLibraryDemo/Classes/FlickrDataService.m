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
@end

@implementation FlickrDataService
@synthesize delegate = delegate_;

- (void) dealloc {
    [context_ release];
    [operationQueue_ release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        operationQueue_ = [[NSOperationQueue alloc] init];
        [operationQueue_ setMaxConcurrentOperationCount:4];
        context_ = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY 
                                                sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
    }
    return self;
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

- (void) loadImageForUrl:(NSDictionary *) args {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *url = [args objectForKey:@"url"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:data];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", url, @"url", nil];
    [self.delegate performSelectorOnMainThread:@selector(updatedImage:) withObject:dict waitUntilDone:YES];    
    [pool release];
}

@end
