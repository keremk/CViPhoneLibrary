//
//  FakeDataService.m
//  ActivityApp
//
//  Created by Kerem Karatal on 4/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "FakeDataService.h"
#import "CVLibrary.h"
#import "DemoItem.h"

@interface FakeDataService()
- (void) createDummyData;
- (void) createFakeImageForUrl:(NSDictionary *) args;
@end


@implementation FakeDataService
@synthesize delegate = delegate_;

- (void) dealloc {
    [operationQueue_ release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        operationQueue_ = [[NSOperationQueue alloc] init];
        [operationQueue_ setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void) beginLoadDemoData {
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(createDummyData) object:nil];
    [operationQueue_ addOperation:operation];
    [operation release];
}

- (void) beginLoadImageForUrl:(NSString *) url usingStyle:(CVStyle *)style {
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:url, @"url", style, @"style", nil];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(createFakeImageForUrl:) object:args];
    [operationQueue_ addOperation:operation];
    [operation release];
}

- (void) createDummyData {
    NSMutableArray *demoItems = [[[NSMutableArray alloc] init] autorelease];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (int i = 0; i < 99; i++) {
        NSNumber *demoItemId = [NSNumber numberWithInt:i];
        NSString *title = [NSString stringWithFormat:@"Title_%d", i];
        NSString *url = [NSString stringWithFormat:@"%d", i];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:demoItemId, @"demo_item_id", title, @"title", url, @"image_url", nil];
        DemoItem *demoItem = [[DemoItem alloc] initWithDictionary:dict];
        [demoItems addObject:demoItem];
        [demoItem release];
    }
    [pool release];
    [self.delegate performSelectorOnMainThread:@selector(updatedWithItems:) withObject:demoItems waitUntilDone:YES];
}

#define BITS_PER_COMPONENT 8
#define NUM_OF_COMPONENTS 4

- (void) createFakeImageForUrl:(NSDictionary *) args {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *url = [args objectForKey:@"url"];
    CVImage *cvImage = [[CVImageCache sharedCVImageCache] imageForKey:url];
    
    CVStyle *style = [args objectForKey:@"style"];
    CGSize size = {80, 87};

    // IMPORTANT NOTE:
    // DONOT use UIGraphicsBeginImageContext here
    // This is done in the background thread and the UI* calls are not threadsafe with the 
    // main UI thread. So use the pure CoreGraphics APIs instead.

    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height,
                                                 BITS_PER_COMPONENT,
                                                 NUM_OF_COMPONENTS * size.width,
                                                 colorSpaceRef,
                                                 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpaceRef);
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    CGContextClearRect(context, rect);
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    CGContextFillRect(context, rect);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1.0);
    NSString *text = [NSString stringWithFormat:@"%@", url];
    NSUInteger textLen = [text length] + 1;  // +1 for the \0 string end
    char *textChar = malloc(textLen);
    [text getCString:textChar maxLength:textLen encoding:NSUTF8StringEncoding];
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextSelectFont(context, "Arial", 64.0, kCGEncodingMacRoman);
    CGContextShowTextAtPoint(context, 5.0, 20.0, textChar, textLen - 1);
    free(textChar);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(context);
    
    if (nil != image && nil != cvImage) {        
        [cvImage setImage:image usingStyle:style];
    } else {
        [cvImage setIsLoading:NO];
        [cvImage setIsLoaded:NO];
        NSLog(@"Text = %@", text);
    }
    [self.delegate performSelectorOnMainThread:@selector(updatedWithImage:) withObject:cvImage waitUntilDone:YES];
    [pool release];
}


@end
