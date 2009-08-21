//
//  CVShadowStyle.h
//  CVLibrary
//
//  Created by Kerem Karatal on 8/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyleProtocols.h"

@interface CVShadowStyle : NSObject<CVRenderStyle> {
@private
    CGSize offset_;
    CGFloat blur_;
    UIColor *color_;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic) CGSize offset;
@property (nonatomic) CGFloat blur;
- (CGPoint) effectiveOffset;
- (CGPoint) effectiveOffsetInUIKitCoordinateSystem;
@end
