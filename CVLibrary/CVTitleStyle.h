//
//  CVTextAdorner.h
//  CVLibrary
//
//  Created by Kerem Karatal on 11/13/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CVTitleStyle : NSObject {
    UIFont *font_;
    UILineBreakMode lineBreakMode_;
    UIColor *backgroundColor_;
    UIColor *foregroundColor_;
}

@property (nonatomic, retain) UIFont *font;
@property (nonatomic) UILineBreakMode lineBreakMode;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIColor *foregroundColor;

@end
