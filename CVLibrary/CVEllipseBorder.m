//
//  CVEllipseBorder.m
//  CVLibrary
//
//  Created by Kerem Karatal on 9/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVEllipseBorder.h"

@interface CVEllipseBorder()
- (CGSize) sizeAfterRenderingGivenInitialSize:(CGSize) size;
@end


@implementation CVEllipseBorder
@synthesize radius = radius_;
@synthesize color = color_;
@synthesize width = width_;

- (void) dealloc {
    [color_ release], color_ = nil;
    [super dealloc];
}

#pragma mark CVRenderPath

- (void) drawInContext:(CGContextRef) context forImageSize:(CGSize) imageSize {
    CGSize borderSize = [self sizeAfterRenderingGivenInitialSize:imageSize];
    
    CGRect borderRect = CGRectMake(0.0, 0.0, borderSize.width, borderSize.height);
    if (self.width > 0.0) {
        // Prepare the rounded rect path (or simple rect if radius = 0)
        
        CGContextBeginPath(context);
        CGContextAddEllipseInRect(context, borderRect);
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, [self.color CGColor]);
        CGContextDrawPath(context, kCGPathFill);
    }
    
    // Calculate the offset based on the border:
    CGContextTranslateCTM(context, self.width, self.width);

    // Clip the image with inner circle
    CGRect innerRect = CGRectMake(0, 0, imageSize.width, imageSize.width);
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, innerRect);
    CGContextClosePath(context);
    CGContextClip(context);
}

- (CGSize) sizeRequiredForRendering {
    
    return CGSizeMake(2 * self.width, 2 * self.width);
}

- (CGSize) sizeAfterRenderingGivenInitialSize:(CGSize) size {
    CGSize adornedImageSize = size;
    
    adornedImageSize.width += 2 * self.width;
    adornedImageSize.height += 2 * self.width;
    return adornedImageSize;
}

@end
