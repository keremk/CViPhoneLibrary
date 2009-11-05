//
//  CVStyle.m
//  CVLibrary
//
//  Created by Kerem Karatal on 5/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVImageAdorner.h"
#include "CGUtils.h"

@interface CVImageAdorner()
- (CGSize) innerImageSizeForTargetImageSize:(CGSize) targetImageSize;
@end


@implementation CVImageAdorner
@synthesize borderStyle = borderStyle_;
@synthesize shadowStyle = shadowStyle_;

- (void) dealloc {
    [borderStyle_ release], borderStyle_ = nil;
    [shadowStyle_ release], shadowStyle_ = nil;
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        borderStyle_ = [[CVBorderStyle alloc] init];
        shadowStyle_ = [[CVShadowStyle alloc] init];
    }
    return self;
}

#define SHADOW_BLUR_PIXELS 3
#define BITS_PER_COMPONENT 8
#define NUM_OF_COMPONENTS 4

- (UIImage *) adornedImageFromImage:(UIImage *) image usingTargetImageSize:(CGSize) targetImageSize {
    // IMPORTANT NOTE:
    // DONOT use UIGraphicsBeginImageContext here
    // This is done in the background thread and the UI* calls are not threadsafe with the 
    // main UI thread. So use the pure CoreGraphics APIs instead.
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, targetImageSize.width, targetImageSize.height,
                                                 BITS_PER_COMPONENT,
                                                 NUM_OF_COMPONENTS * targetImageSize.width, // We need to have RGBA with alpha for shadow effects 
                                                 colorSpaceRef,
                                                 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpaceRef);
    CGContextClearRect(context, CGRectMake(0.0, 0.0, targetImageSize.width, targetImageSize.height));

    CGContextBeginTransparencyLayer(context, NULL);

    CGSize innerImageSize = [self innerImageSizeForTargetImageSize:targetImageSize];
    [shadowStyle_ drawInContext:context forImageSize:CGSizeZero];
    [borderStyle_ drawInContext:context forImageSize:innerImageSize];
    
    // Draw the new image in
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, innerImageSize.width, innerImageSize.height), [image CGImage]);
    
    CGContextEndTransparencyLayer(context);

    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *processedImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(context);
        
    return processedImage;
}

- (CGSize) innerImageSizeForTargetImageSize:(CGSize) targetImageSize {
    CGSize sizeRequiredForShadow = shadowStyle_ ? [shadowStyle_ sizeRequiredForRendering] : CGSizeZero;
    CGSize sizeRequiredForBorder = borderStyle_ ? [borderStyle_ sizeRequiredForRendering] : CGSizeZero;
    
    CGFloat newWidth = targetImageSize.width - (sizeRequiredForBorder.width + sizeRequiredForShadow.width);
    CGFloat newHeight = targetImageSize.height - (sizeRequiredForBorder.height + sizeRequiredForShadow.height);
    
    return CGSizeMake(newWidth, newHeight);
}

- (CGSize) paddingRequiredForUpperLeftBadgeSize:(CGSize) badgeSize {
    //  paddingRequiredForUpperLeftBadgeSize: depends on the shadow direction and the shape of the border
    //  upperLeftCorner: Each border shape defines a point as its designated upperLeftCorner
    //                   e.g. For rectangle, it is (0,0), 
    //                        For circle, it is the point on the circle where angle = -45


    CGSize shadowOffset = self.shadowStyle.offsetWithBlurPixels;
    
    CGFloat widthAdjustment = (shadowOffset.width < 0) ? abs(shadowOffset.width) : 0.0;
    CGFloat heightAdjustment = (shadowOffset.height > 0) ? shadowOffset.height : 0.0;
    
    CGFloat xPadding = self.borderStyle.upperLeftCorner.x - (badgeSize.width / 2) + widthAdjustment;
    xPadding = (xPadding > 0) ? 0.0 : abs(xPadding);
    
    CGFloat yPadding = self.borderStyle.upperLeftCorner.y - (badgeSize.width / 2) + heightAdjustment;
    yPadding = (yPadding > 0) ? 0.0 : abs(yPadding);

    return CGSizeMake(xPadding, yPadding);
}

@end
