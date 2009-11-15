//
//  CVPolygonBorder.h
//  CVLibrary
//
//  Created by Kerem Karatal on 9/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyleProtocols.h"

@interface CVPolygonBorder : NSObject<CVBorderStyle> {
    CGFloat width_;
    CGFloat rotationAngle_;
    UIColor *color_;
    NSUInteger numOfSides_;
}

@property (nonatomic) NSUInteger numOfSides;
@property (nonatomic) CGFloat rotationAngle;
@end
