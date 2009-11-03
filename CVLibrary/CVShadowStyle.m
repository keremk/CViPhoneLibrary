//
//  CVShadowStyle.m
//  CVLibrary
//
//  Created by Kerem Karatal on 8/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVShadowStyle.h"

@interface CVShadowStyle()
- (CGPoint) zeroClippedOffsetAsPoint;
@end


@implementation CVShadowStyle       
@synthesize color = color_;
@synthesize offset = offset_;
@synthesize blur = blur_;

- (void) dealloc {
    [color_ release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        offset_ = CGSizeZero;
        blur_ = 0.0;
    }
    return self;
}

#define SHADOW_BLUR_PIXELS 3 // Fudge factor used to take into account the fading of blur effect

- (CGPoint) zeroClippedOffsetAsPoint {
    // Take into account the shadow based on its direction

    CGPoint offset = CGPointZero;
    if (self.offset.width < 0) {
        offset.x = abs(self.offset.width) + SHADOW_BLUR_PIXELS;
    }
    if (self.offset.height < 0) {
        offset.y = abs(self.offset.height) + SHADOW_BLUR_PIXELS;
    }
    return offset;
}

- (CGSize) offsetWithBlurPixels {
    
    CGSize offset = CGSizeZero;
    if (self.offset.width < 0) {
        offset.width = self.offset.width - SHADOW_BLUR_PIXELS;
    } else if (self.offset.width > 0) {
        offset.width = self.offset.width + SHADOW_BLUR_PIXELS;
    } 

    if (self.offset.height < 0) {
        offset.height = self.offset.height - SHADOW_BLUR_PIXELS;
    } else if (self.offset.height > 0) {
        offset.height = self.offset.height + SHADOW_BLUR_PIXELS;
    } 
    return offset;
}

//- (CGPoint) effectiveOffsetInUIKitCoordinateSystem {
//    CGPoint offset = CGPointZero;
//    if (self.offset.width < 0) {
//        offset.x = abs(self.offset.width) + SHADOW_BLUR_PIXELS;
//    }
//    if (self.offset.height > 0) {
//        offset.y = abs(self.offset.height) + SHADOW_BLUR_PIXELS;
//    }
//    return offset;
//}

#pragma mark CVRenderStyle


- (void) drawInContext:(CGContextRef) context forImageSize:(CGSize) imageSize {
    CGContextSetShadow(context, self.offset, self.blur);

    CGPoint effectiveOffset = [self zeroClippedOffsetAsPoint];
    CGContextTranslateCTM(context, effectiveOffset.x, effectiveOffset.y);
}

- (CGSize) sizeAfterRenderingGivenInitialSize:(CGSize) size {
    CGSize adornedImageSize = size;
    
    adornedImageSize.width += abs(self.offset.width) + SHADOW_BLUR_PIXELS;
    adornedImageSize.height += abs(self.offset.height) + SHADOW_BLUR_PIXELS;
    return adornedImageSize;
}

- (CGSize) sizeRequiredForRendering {
    CGFloat width = abs(self.offset.width) + SHADOW_BLUR_PIXELS;
    CGFloat height = abs(self.offset.height) + SHADOW_BLUR_PIXELS;
    
    CGSize size = CGSizeMake(width, height);
    
    return size;
}

@end

