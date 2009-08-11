//
//  CVBorderStyle.m
//  CVLibrary
//
//  Created by Kerem Karatal on 8/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVBorderStyle.h"
#include "CGUtils.h"

@implementation CVBorderStyle
@synthesize color = color_;
@synthesize dimensions = dimensions_;
@synthesize roundedRadius = roundedRadius_;
@synthesize width = width_;
@synthesize cornerOvalWidth = cornerOvalWidth_;
@synthesize cornerOvalHeight = cornerOvalHeight_;

- (void) dealloc {
    [color_ release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        // Set the defaults
        color_ = [UIColor blackColor]; 
        roundedRadius_ = 0.0;       // Not rounded by default
        self.width = 0.0;           // width is a shortcut for specifying all dimensions same
    }
    return self;
}

- (void) setWidth:(CGFloat) width {
    // Set the dimensions as well
    dimensions_ = CVBorderDimensionsMake(width, width, width, width);
    width_ = width;
}

- (void) setRoundedRadius:(CGFloat) radius {
    cornerOvalWidth_ = radius * 2;
    cornerOvalHeight_ = cornerOvalWidth_;
    roundedRadius_ = radius;
}

#pragma mark CVRenderStyle

- (void) drawInContext:(CGContextRef) context forImageSize:(CGSize) imageSize {
    CGSize borderSize = [self sizeAfterRenderingGivenInitialSize:imageSize];
    
    CGRect borderRect;
    if (self.width > 0 ) {
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
    if (self.cornerOvalWidth > 0 && self.cornerOvalHeight > 0) {
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

@end
