//
//  CVRoundedRectShape.h
//  CVLibrary
//
//  Created by Kerem Karatal on 9/8/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyleProtocols.h"

struct CVBorderDimensions  {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
};
typedef struct CVBorderDimensions CVBorderDimensions;

static inline CVBorderDimensions
CVBorderDimensionsMake(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left) {
    CVBorderDimensions dimensions;
    dimensions.top = top;
    dimensions.right = right;
    dimensions.bottom = bottom;
    dimensions.left = left;
    
    return dimensions;
}

/*!
    @abstract   The CVRoundedRectBorder class describes how to provide a rounded rectangle border for a given image.

    @discussion The image is cropped to stay within the border.
*/
@interface CVRoundedRectBorder : NSObject<CVBorderStyle>  {
@private
    CGFloat width_;
    UIColor *color_;

    CGFloat cornerOvalWidth_;
    CGFloat cornerOvalHeight_;
    CVBorderDimensions dimensions_;
    CGFloat radius_;
}

/*!
    @abstract   The width of the border for the top,right, bottom and left.

    @discussion Specify this only if the border width differs on top,right, bottom or left. Otherwise if same, just use the width property, and all these values will be set to the same width property.
*/
@property (nonatomic) CVBorderDimensions dimensions;
/*!
    @abstract   Specify the oval width of the rounded corners of the rounded rectangle.

    @discussion Specify this if cornerOvalWidth != cornerOvalHeight. Otherwise use the radius property.
*/
@property (nonatomic) CGFloat cornerOvalWidth;
/*!
    @abstract   Specify the oval height of the rounded corners of the rounded rectangle.

    @discussion Specify this if cornerOvalWidth != cornerOvalHeight. Otherwise use the radius property.
*/
@property (nonatomic) CGFloat cornerOvalHeight;
/*!
    @abstract   Specify the radius for the rounded corners of the rounded rectangle.

    @discussion 
*/
@property (nonatomic) CGFloat radius;

@end
