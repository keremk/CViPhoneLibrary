//
//  CVPolygonBorder.h
//  CVLibrary
//
//  Created by Kerem Karatal on 9/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyleProtocols.h"

/*!
    @abstract   The CVPolygonBorder class describes how to provide a polygon border for a given image.

    @discussion The image is cropped to stay within the border.
*/
@interface CVPolygonBorder : NSObject<CVBorderStyle> {
    CGFloat width_;
    CGFloat rotationAngle_;
    UIColor *color_;
    NSUInteger numOfSides_;
}

/*!
    @abstract   The number of sides for the polygon.

    @discussion Must be greater than or equal to 3.
*/
@property (nonatomic) NSUInteger numOfSides;
/*!
    @abstract   The rotation angle in radians when drawing the polygon.

    @discussion 
*/
@property (nonatomic) CGFloat rotationAngle;
@end
