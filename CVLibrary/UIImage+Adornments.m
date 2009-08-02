//
//  UIImage+Adornments.m
//  CVLibrary
//
//  Created by Kerem Karatal on 6/4/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "UIImage+Adornments.h"
#include "CGUtils.h"

#define SHADOW_BLUR_PIXELS 3

@implementation UIImage (CVAdornments)

+ (CGSize) adornedImageSizeForImageSize:(CGSize) size usingStyle:(CVStyle *) style {
    // Calculate the cell size by taking into account the frame and shadow
    
    CGSize adornedImageSize = CGSizeZero;
    adornedImageSize = size;
    
    // Add border 
    adornedImageSize.width += style.borderStyle.dimensions.left + style.borderStyle.dimensions.right;
    adornedImageSize.height += style.borderStyle.dimensions.top + style.borderStyle.dimensions.bottom;
    
    // Add Shadow
    adornedImageSize.width += abs(style.shadowStyle.offset.width) + SHADOW_BLUR_PIXELS;
    adornedImageSize.height += abs(style.shadowStyle.offset.height) + SHADOW_BLUR_PIXELS;
    
    return adornedImageSize;
}

+ (UIImage *) adornedImageFromImage:(UIImage *) image usingStyle:(CVStyle *) style  { 
    CGSize size = [UIImage adornedImageSizeForImageSize:style.imageSize usingStyle:style];
    
//    UIGraphicsBeginImageContext(size);    
//    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height,
                                                 CGImageGetBitsPerComponent([image CGImage]),
                                                 4 * size.width,
                                                 CGImageGetColorSpace([image CGImage]),
                                                 kCGImageAlphaPremultipliedFirst);
    CGContextClearRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    
    CGSize borderSize = style.imageSize;
    borderSize.width += style.borderStyle.dimensions.left + style.borderStyle.dimensions.right;
    borderSize.height += style.borderStyle.dimensions.top + style.borderStyle.dimensions.bottom;
    
    CGRect rect;
    
    CGContextSetShadow(context, style.shadowStyle.offset, style.shadowStyle.blur);
    
    CGContextBeginTransparencyLayer(context, NULL);
    CGPoint offset = CGPointZero;
    
    // Take into account the shadow based on its direction
    if (style.shadowStyle.offset.width < 0) {
        offset.x += abs(style.shadowStyle.offset.width) + SHADOW_BLUR_PIXELS;
    }
    if (style.shadowStyle.offset.height < 0) {
        offset.y += abs(style.shadowStyle.offset.height) + SHADOW_BLUR_PIXELS;
    }
    CGContextTranslateCTM(context, offset.x, offset.y);
    
    // Stroke the border
    if (style.borderStyle.width > 0 ) {
        
        // Prepare the rounded rect path (or simple rect if radius = 0)
        rect = CGRectMake(0.0, 0.0, borderSize.width, borderSize.height);
        CGContextBeginPath(context);
        CVAddRoundedRectToPath(context, rect, style.borderStyle.cornerOvalWidth, style.borderStyle.cornerOvalHeight); 
        CGContextClosePath(context);
        CGColorRef color = [style.borderStyle.color CGColor];
        CGContextSetFillColorWithColor(context, color);
        CGContextDrawPath(context, kCGPathFill);
    }

    // Calculate the offset based on the border:
    offset.x = style.borderStyle.dimensions.left;
    offset.y = style.borderStyle.dimensions.top;
    
    //CGPoint offset = CGPointMake(style.borderStyle.dimensions.left, style.borderStyle.dimensions.top);

    CGContextTranslateCTM(context, offset.x, offset.y);
    
//    CGContextTranslateCTM(context, offset.x, style.imageSize.height + offset.y);
//    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Clip the image with rounded rect
    if (style.borderStyle.cornerOvalWidth > 0 && style.borderStyle.cornerOvalHeight > 0) {
        rect = CGRectMake(0.0, 0.0, style.imageSize.width, style.imageSize.height);
        CGContextBeginPath(context);
        CVAddRoundedRectToPath(context, rect, style.borderStyle.cornerOvalWidth, style.borderStyle.cornerOvalHeight); 
        CGContextClosePath(context);
        CGContextClip(context);
    }
        
    // Draw the new image in
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, style.imageSize.width, style.imageSize.height), [image CGImage]);
    
    CGContextEndTransparencyLayer(context);

    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *processedImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
//    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    return processedImage;
}

- (NSUInteger) imageMemorySize {
    if (nil == self) {
        return 0;
    }
    NSUInteger imageMemSize = 0;
    CGImageRef cgImage = [self CGImage];
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
    
    imageMemSize = width * height * bitsPerPixel / 8;
    return imageMemSize;
}


@end
