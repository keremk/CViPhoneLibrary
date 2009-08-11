//
//  CVStyle.m
//  CVLibrary
//
//  Created by Kerem Karatal on 5/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVStyle.h"

@implementation CVStyle
@synthesize borderStyle = borderStyle_;
@synthesize shadowStyle = shadowStyle_;
@synthesize imageSize = imageSize_;

- (void) dealloc {
    [borderStyle_ release];
    [shadowStyle_ release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        borderStyle_ = [[CVBorderStyle alloc] init];
        shadowStyle_ = [[CVShadowStyle alloc] init];
        imageSize_ = CGSizeZero;
    }
    return self;
}

#define SHADOW_BLUR_PIXELS 3
#define BITS_PER_COMPONENT 8
#define NUM_OF_COMPONENTS 4

- (UIImage *) imageByApplyingStyleToImage:(UIImage *) image {
    // IMPORTANT NOTE:
    // DONOT use UIGraphicsBeginImageContext here
    // This is done in the background thread and the UI* calls are not threadsafe with the 
    // main UI thread. So use the pure CoreGraphics APIs instead.
    
    CGSize size = [self sizeAfterStylingImage];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height,
                                                 BITS_PER_COMPONENT,
                                                 NUM_OF_COMPONENTS * size.width, // We need to have RGBA with alpha for shadow effects 
                                                 colorSpaceRef,
                                                 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpaceRef);
    CGContextClearRect(context, CGRectMake(0.0, 0.0, size.width, size.height));

    CGContextBeginTransparencyLayer(context, NULL);

    [shadowStyle_ drawInContext:context forImageSize:CGSizeZero];
    [borderStyle_ drawInContext:context forImageSize:self.imageSize];
    
    // Draw the new image in
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, self.imageSize.width, self.imageSize.height), [image CGImage]);
    
    CGContextEndTransparencyLayer(context);

    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *processedImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(context);
        
    return processedImage;
}

- (CGSize) sizeAfterStylingImage {
    CGSize size = [shadowStyle_ sizeAfterRenderingGivenInitialSize:[borderStyle_ sizeAfterRenderingGivenInitialSize:[self imageSize]]];
    
    return size;
}

@end
