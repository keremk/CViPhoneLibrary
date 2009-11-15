//
//  ConfigOptions.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/26/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConfigOptions : NSObject {
    CGFloat thumbnailWidth_;
    CGFloat thumbnailHeight_;
    CGFloat borderWidth_;
    CGFloat borderRoundedRadius_;
    CGFloat shadowOffsetWidth_;
    CGFloat shadowOffsetHeight_;
    CGFloat shadowBlur_;
    UIColor *borderColor_;
    NSInteger numOfSides_;
    NSString *shape_;
    CGFloat leftMargin_;
    CGFloat rightMargin_;
    CGFloat columnSpacing_;
    CGFloat rotationAngle_;
}

@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic) CGFloat thumbnailWidth;
@property (nonatomic) CGFloat thumbnailHeight;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat shadowBlur;
@property (nonatomic) CGFloat shadowOffsetWidth;
@property (nonatomic) CGFloat shadowOffsetHeight;
@property (nonatomic) CGFloat borderRoundedRadius;
@property (nonatomic, copy) NSString *shape;
@property (nonatomic) NSInteger numOfSides;
@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGFloat rightMargin;
@property (nonatomic) CGFloat columnSpacing;
@property (nonatomic) CGFloat rotationAngle;

@end
