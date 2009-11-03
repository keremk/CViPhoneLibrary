//
//  CVRoundedRectShape.h
//  CVLibrary
//
//  Created by Kerem Karatal on 9/8/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyleProtocols.h"
#import "CVBorderStyle.h"

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

@interface CVRoundedRectBorder : CVBorderStyle  {
@private
    CGFloat cornerOvalWidth_;
    CGFloat cornerOvalHeight_;
    CVBorderDimensions dimensions_;
    CGFloat radius_;
}

@property (nonatomic) CVBorderDimensions dimensions;
@property (nonatomic) CGFloat cornerOvalWidth;
@property (nonatomic) CGFloat cornerOvalHeight;
@property (nonatomic) CGFloat radius;

@end
