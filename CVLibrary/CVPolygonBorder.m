//
//  CVPolygonBorder.m
//  CVLibrary
//
//  Created by Kerem Karatal on 9/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVPolygonBorder.h"
#include "CGUtils.h"

@interface CVPolygonBorder()
- (CGSize) sizeAfterRenderingGivenInitialSize:(CGSize) size;
@end

@implementation CVPolygonBorder
@synthesize numOfSides = numOfSides_;
@synthesize color = color_;
@synthesize width = width_;
@synthesize rotationAngle = rotationAngle_;

- (void) dealloc {
    [color_ release], color_ = nil;
    [super dealloc];
}

#define DEFAULT_ANGLE   M_PI
#define DEFAULT_NUM_OF_SIDES    5   // Pentagon by default
- (id) init {
    self = [super init];
    if (self != nil) {
        // Set the defaults
        numOfSides_ = DEFAULT_NUM_OF_SIDES; 
        rotationAngle_ = M_PI;
    }
    return self;
}

#pragma mark CVRenderPath

- (void) drawInContext:(CGContextRef) context forImageSize:(CGSize) imageSize {
    CGSize borderSize = [self sizeAfterRenderingGivenInitialSize:imageSize];
    CGFloat radius = MIN(borderSize.width, borderSize.height) / 2.0;

    CGRect borderRect = CGRectMake(0.0, 0.0, borderSize.width, borderSize.height);
    if (self.width > 0.0) {
        // Prepare the rounded rect path (or simple rect if radius = 0)
        
        CGContextBeginPath(context);
        CVAddPolygonToPath(context, borderRect, radius, numOfSides_, rotationAngle_);
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, [self.color CGColor]);
        CGContextDrawPath(context, kCGPathFill);
    }

    // Clip the image with rounded rect
    CGContextBeginPath(context);
    CVAddPolygonToPath(context, borderRect, (radius - self.width), numOfSides_, rotationAngle_);
    CGContextClosePath(context);
    CGContextClip(context);
}

- (CGSize) sizeRequiredForRendering {
    
    return CGSizeMake(self.width, self.width);
}

- (CGSize) sizeAfterRenderingGivenInitialSize:(CGSize) size {
    CGSize adornedImageSize = size;
    
    adornedImageSize.width += self.width;
    adornedImageSize.height += self.width;
    return adornedImageSize;
}

@end
