/*
 *  CGUtils.c
 *  CVLibrary
 *
 *  Created by Kerem Karatal on 5/16/09.
 *  Copyright 2009 Coding Ventures. All rights reserved.
 *
 */

#include "CGUtils.h"

void CVAddRoundedRectToPath(CGContextRef context, CGRect rect, CGFloat ovalWidth, CGFloat ovalHeight) {
    CGFloat fw, fh;
    
    if (ovalWidth == 0.0 || ovalHeight == 0.0) {
        // Not rounded so just add the rectangle
        CGContextAddRect(context, rect);
    } else {
        CGContextSaveGState(context);
        
        // Translate the below to lower-left corner of the rectangle, so that origin is at 0,0 and we can work
        // with the width and height of the rectangle only.
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        
        // Do the below scaling so that if ovalWidth != ovalHeight, we create a normalized
        // system where they are equal and can use the CGContextAddArcToPoint which expects a circle not oval.
        // At this point ovalWidth and ovalHeight are normalized to 1.0 and hence the radius is 0.5
        CGContextScaleCTM(context, ovalWidth, ovalHeight);
        
        // Now unscale the width and height of the rectangle
        fw = CGRectGetWidth(rect) / ovalWidth;
        fh = CGRectGetHeight(rect) / ovalHeight;
        
        // Start at the right side of rectangle half point of the height and go counterclockwise
        CGContextMoveToPoint(context, fw, fh/2);
        
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 0.5);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 0.5);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 0.5);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 0.5);

        CGContextClosePath(context);
        
        CGContextRestoreGState(context);
    }
}

void CVAddPolygonToPath(CGContextRef context, CGRect rect, CGFloat radius, unsigned int numOfSides, CGFloat angle) {
    if (numOfSides < 3 || radius < 0.0) 
        return;
    
    CGContextSaveGState(context);

    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextRotateCTM(context, angle);
	CGContextMoveToPoint(context, 0.0, - radius);
	for(unsigned int i = 1; i < numOfSides; ++i) {
		CGFloat x = - radius * sinf(i * 2.0 * M_PI / numOfSides);
		CGFloat y = - radius * cosf(i * 2.0 * M_PI / numOfSides);
		CGContextAddLineToPoint(context, x, y);
	}
    
    CGContextRestoreGState(context);
}

void CVAddCircleToPath(CGContextRef context, CGRect rect, CGFloat radius) {
    if (radius < 0.0) 
        return;
    
    CGContextSaveGState(context);

    CGContextAddEllipseInRect(context, rect);
    
    CGContextRestoreGState(context);
    
}

void CVAddStarToPath(CGContextRef context, CGRect rect, CGFloat radius) {
    if (radius < 0.0)
        return;

    CGContextSaveGState(context);
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)); 
	for(unsigned int i = 1; i < 5; ++i)
	{
		CGFloat x =  radius * sinf(i * 4.0 * M_PI / 5.0);
		CGFloat y =  radius * cosf(i * 4.0 * M_PI / 5.0);
		CGContextAddLineToPoint(context, center.x + x, center.y + y);
	}
 
    CGContextRestoreGState(context);    
}

void CVPathAddRoundedRect(CGMutablePathRef path, CGRect rect, CGFloat ovalWidth, CGFloat ovalHeight) {
    CGFloat fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) {
        // Not rounded so just add the rectangle
        CGPathAddRect(path, NULL, rect);
    } else {
        CGAffineTransform theTransform = CGAffineTransformMakeTranslation(CGRectGetMinX(rect), CGRectGetMinY(rect));
        theTransform = CGAffineTransformScale(theTransform, ovalWidth, ovalHeight);
        
        // Now unscale the width and height of the rectangle
        fw = CGRectGetWidth(rect) / ovalWidth;
        fh = CGRectGetHeight(rect) / ovalHeight;

        CGPathMoveToPoint(path, &theTransform, fw, fh/2);
        
        CGPathAddArcToPoint(path, &theTransform, fw, fh, fw/2, fh, 0.5);
        CGPathAddArcToPoint(path, &theTransform, 0, fh, 0, fh/2, 0.5);
        CGPathAddArcToPoint(path, &theTransform, 0, 0, fw/2, 0, 0.5);
        CGPathAddArcToPoint(path, &theTransform, fw, 0, fw, fh/2, 0.5);
        
        CGPathCloseSubpath(path);
    }
}

void CVPathAddPolygon(CGMutablePathRef path, CGRect rect, CGFloat radius, unsigned int numOfSides) {
    if (numOfSides < 3 || radius < 0.0) 
        return;
         
	CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGPathMoveToPoint(path, NULL, center.x, center.y - radius);
	for(unsigned int i = 1; i < numOfSides; ++i) {
		CGFloat x = - radius * sinf(i * 2.0 * M_PI / numOfSides);
		CGFloat y = - radius * cosf(i * 2.0 * M_PI / numOfSides);
		CGPathAddLineToPoint(path, NULL, center.x + x, center.y + y);
	}
    CGPathCloseSubpath(path);
}

void CVPathAddStar(CGMutablePathRef path, CGRect rect, CGFloat radius) {
    if (radius < 0.0)
        return;
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)); 
	for(unsigned int i = 1; i < 5; ++i)
	{
		CGFloat x =  radius * sinf(i * 4.0 * M_PI / 5.0);
		CGFloat y =  radius * cosf(i * 4.0 * M_PI / 5.0);
		CGPathAddLineToPoint(path, NULL, center.x + x, center.y + y);
	}
    CGPathCloseSubpath(path);
}
