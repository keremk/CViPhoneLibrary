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
#define BITS_PER_COMPONENT 8
#define NUM_OF_COMPONENTS 4

@implementation UIImage (CVAdornments)

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
