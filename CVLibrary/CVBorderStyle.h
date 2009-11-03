//
//  CVBorderStyle.h
//  CVLibrary
//
//  Created by Kerem Karatal on 8/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyleProtocols.h"

enum CVBorderShape {
    Rectangle,
    RoundedRectangle,
    Polygon,
    Star
};

@interface CVBorderStyle : NSObject<CVRenderStyle> {
@protected
    CGFloat width_;
    UIColor *color_;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat radius;

@end

