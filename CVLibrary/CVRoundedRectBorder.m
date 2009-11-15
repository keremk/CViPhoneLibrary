//
//  CVRoundedRectShape.m
//  CVLibrary
//
//  Created by Kerem Karatal on 9/8/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVRoundedRectBorder.h"
#include "CGUtils.h"

@interface CVRoundedRectBorder()
- (CGSize) sizeAfterRenderingGivenInitialSize:(CGSize) size;
@end


@implementation CVRoundedRectBorder 
@synthesize cornerOvalWidth = cornerOvalWidth_;
@synthesize cornerOvalHeight = cornerOvalHeight_;
@synthesize dimensions = dimensions_;
@synthesize radius = radius_;
@synthesize color = color_;
@synthesize width = width_;

- (void) dealloc {
    [color_ release], color_ = nil;
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        // Set the defaults
        radius_ = 0.0;       // Not rounded by default
        cornerOvalWidth_ = 0.0;
        cornerOvalHeight_ = 0.0;
    }
    return self;
}

- (void) setWidth:(CGFloat) width {
    // Set the dimensions as well
    dimensions_ = CVBorderDimensionsMake(width, width, width, width);
    width_ = width;
}

- (void) setRadius:(CGFloat) radius {
    cornerOvalWidth_ = radius * 2;
    cornerOvalHeight_ = cornerOvalWidth_;
    radius_ = radius;
}

- (void) setDimensions:(CVBorderDimensions) dimensions {
    dimensions_.top = abs(dimensions.top);
    dimensions_.bottom = abs(dimensions.bottom);
    dimensions_.left = abs(dimensions.left);
    dimensions_.right = abs(dimensions.right);    
}

#pragma mark CVRenderPath

- (void) drawInContext:(CGContextRef) context forImageSize:(CGSize) imageSize {
    CGSize borderSize = [self sizeAfterRenderingGivenInitialSize:imageSize];
    
    CGRect borderRect;
    if (self.dimensions.left > 0.0 || self.dimensions.right > 0.0 || self.dimensions.top > 0.0 || self.dimensions.bottom > 0.0) {
        // Prepare the rounded rect path (or simple rect if radius = 0)
        borderRect = CGRectMake(0.0, 0.0, borderSize.width, borderSize.height);
        CGContextBeginPath(context);
        CVAddRoundedRectToPath(context, borderRect, self.cornerOvalWidth, self.cornerOvalHeight); 
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, [self.color CGColor]);
        CGContextDrawPath(context, kCGPathFill);
    }

    // Calculate the offset based on the border:
    CGPoint offset = CGPointMake(self.dimensions.left, self.dimensions.top);
    CGContextTranslateCTM(context, offset.x, offset.y);

    // Clip the image with rounded rect
    CGRect imageRect;
    if (self.cornerOvalWidth > 0.0 && self.cornerOvalHeight > 0.0) {
        imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        CGContextBeginPath(context);
        CVAddRoundedRectToPath(context, imageRect, self.cornerOvalWidth, self.cornerOvalHeight); 
        CGContextClosePath(context);
        CGContextClip(context);
    }
}

- (CGSize) sizeAfterRenderingGivenInitialSize:(CGSize) size {
    CGSize adornedImageSize = size;
    
    adornedImageSize.width += self.dimensions.left + self.dimensions.right;
    adornedImageSize.height += self.dimensions.top + self.dimensions.bottom;
    return adornedImageSize;
}

- (CGSize) sizeRequiredForRendering {
    
    return CGSizeMake(self.dimensions.left + self.dimensions.right, self.dimensions.top + self.dimensions.bottom);
}

@end
