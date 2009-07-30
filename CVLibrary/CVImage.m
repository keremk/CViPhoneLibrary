//
//  CVImage.m
//  CVLibrary
//
//  Created by Kerem Karatal on 5/24/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVImage.h"
#import "CVImageCache.h"
#import "UIImage+Adornments.h"
#include "CGUtils.h"


@implementation CVImage
@synthesize imageUrl = imageUrl_;
@synthesize isLoaded = isLoaded_;
@synthesize isLoading = isLoading_;
@synthesize image = image_;
@synthesize delegate = delegate_;
@synthesize adornedImage = adornedImage_;
@synthesize indexPath = indexPath_;
@synthesize previousMemorySize = previousMemorySize_;

- (void) dealloc {
    [image_ release];
    [imageUrl_ release];
    [adornedImage_ release];
    [indexPath_ release];
    [super dealloc];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    BOOL automatic = NO;
 
    if ([theKey isEqualToString:@"image"]) {
        automatic=NO;
    } else {
        automatic=[super automaticallyNotifiesObserversForKey:theKey];
    }
    return automatic;
}

- (id) initWithUrl:(NSString *) url indexPath:(NSIndexPath *) indexPath {
    self = [super init];
    if (self != nil) {
        self.imageUrl = url;
        self.indexPath = indexPath;
        isLoaded_ = NO;
        isLoading_ = NO;
        image_ = nil;
        adornedImage_ = nil;
        previousMemorySize_ = 0;
    }
    return self;    
}


- (void) beginLoadingImage {
    if (!isLoading_) {
        isLoading_ = YES;
        if ([self.delegate respondsToSelector:@selector(beginLoadImageForUrl:)])
            [self.delegate performSelector:@selector(beginLoadImageForUrl:) withObject:imageUrl_];                
    }
}

- (void) setImage:(UIImage *) image usingStyle:(CVStyle *) style {
    if (image_ != image) {
        [self willChangeValueForKey:@"image"];
        previousMemorySize_ = [self memorySize];
        [image_ release];
        image_ = [image retain];
        if (nil != style) {
            adornedImage_ = [[UIImage adornedImageFromImage:image usingStyle:style] retain];
        }
        isLoaded_ = YES;
        isLoading_ = NO;
        [self didChangeValueForKey:@"image"];
    }
}

- (NSUInteger) memorySize {
    NSUInteger imageSize = (nil != image_) ? [image_ imageMemorySize] : 0;
    NSUInteger adornedImageSize = (nil != adornedImage_) ? [adornedImage_ imageMemorySize] : 0;
        
    return imageSize + adornedImageSize;
}
//
//- (NSUInteger) calculateMemSizeForImage:(UIImage *) image {
//    if (nil == image) {
//        return 0;
//    }
//    NSUInteger imageMemSize = 0;
//    CGImageRef cgImage = [image CGImage];
//    size_t width = CGImageGetWidth(cgImage);
//    size_t height = CGImageGetHeight(cgImage);
//    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
//    
//    imageMemSize = width * height * bitsPerPixel / 8;
//    return imageMemSize;
//}



@end
