//
//  CVStyle.h
//  CVLibrary
//
//  Created by Kerem Karatal on 5/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

struct CVBorderDimensions  {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
};
typedef struct CVBorderDimensions CVBorderDimensions;

@interface CVBorderStyle : NSObject {
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

@interface CVShadowStyle : NSObject {
@private
    CGSize offset_;
    CGFloat blur_;
    UIColor *color_;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic) CGSize offset;
@property (nonatomic) CGFloat blur;

@end

static inline CVBorderDimensions
CVBorderDimensionsMake(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left) {
    CVBorderDimensions dimensions;
    dimensions.top = top;
    dimensions.right = right;
    dimensions.bottom = bottom;
    dimensions.left = left;
    
    return dimensions;
}

@interface CVStyle : NSObject {
    CVBorderStyle *borderStyle_;
    CVShadowStyle *shadowStyle_;
    CGSize imageSize_;
}

@property (nonatomic, retain) CVBorderStyle *borderStyle;
@property (nonatomic, retain) CVShadowStyle *shadowStyle;
@property (nonatomic) CGSize imageSize;

@end
