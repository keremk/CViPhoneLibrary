//
//  ConfigOptions.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/26/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConfigOptions : NSObject {
    NSInteger numOfColumns_;
    BOOL fitNumberOfColumnsToFullWidth_;
    CGFloat thumbnailWidth_;
    CGFloat thumbnailHeight_;
    CGFloat borderWidth_;
    CGFloat borderRoundedRadius_;
    CGFloat shadowOffsetWidth_;
    CGFloat shadowOffsetHeight_;
    CGFloat shadowBlur_;
    UIColor *borderColor_;
}

@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic) NSInteger numOfColumns;
@property (nonatomic) BOOL fitNumberOfColumnsToFullWidth;
@property (nonatomic) CGFloat thumbnailWidth;
@property (nonatomic) CGFloat thumbnailHeight;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat shadowBlur;
@property (nonatomic) CGFloat shadowOffsetWidth;
@property (nonatomic) CGFloat shadowOffsetHeight;
@property (nonatomic) CGFloat borderRoundedRadius;

@end
