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

- (void) dealloc {
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        // Set the defaults
        numOfSides_ = 5; // Pentagon by default
    }
    return self;
}

#pragma mark CVRenderPath

- (void) drawInContext:(CGContextRef) context forImageSize:(CGSize) imageSize {
    CGSize borderSize = [self sizeAfterRenderingGivenInitialSize:imageSize];
    CGFloat radius = MAX(borderSize.width, borderSize.height) / 2.0;

    CGRect borderRect = CGRectMake(0.0, 0.0, borderSize.width, borderSize.height);
    if (self.width > 0.0) {
        // Prepare the rounded rect path (or simple rect if radius = 0)
        
        CGContextBeginPath(context);
        CVAddPolygonToPath(context, borderRect, radius, numOfSides_, M_PI / 3.0);
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, [self.color CGColor]);
        CGContextDrawPath(context, kCGPathFill);
    }

    // Clip the image with rounded rect
    CGContextBeginPath(context);
    CVAddPolygonToPath(context, borderRect, (radius - self.width), numOfSides_, M_PI / 3.0);
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

- (CGPoint) upperLeftCorner {
    
    return CGPointZero;
}

@end
