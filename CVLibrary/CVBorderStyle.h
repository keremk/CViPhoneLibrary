//
//  CVBorderStyle.h
//  CVLibrary
//
//  Created by Kerem Karatal on 8/10/09.
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

@interface CVBorderStyle : NSObject<CVRenderStyle> {
@private
    CVBorderDimensions dimensions_;
    CGFloat width_;
    CGFloat roundedRadius_;
    CGFloat cornerOvalWidth_;
    CGFloat cornerOvalHeight_;
    UIColor *color_;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic) CVBorderDimensions dimensions;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat roundedRadius;
@property (nonatomic) CGFloat cornerOvalWidth;
@property (nonatomic) CGFloat cornerOvalHeight;

@end

