//
//  CVStyle.m
//  CVLibrary
//
//  Created by Kerem Karatal on 5/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVStyle.h"


@implementation CVBorderStyle
@synthesize color = color_;
@synthesize dimensions = dimensions_;
@synthesize roundedRadius = roundedRadius_;
@synthesize width = width_;
@synthesize cornerOvalWidth = cornerOvalWidth_;
@synthesize cornerOvalHeight = cornerOvalHeight_;

- (void) dealloc {
    [color_ release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        // Set the defaults
        color_ = [UIColor blackColor]; 
        roundedRadius_ = 0.0;       // Not rounded by default
        self.width = 0.0;           // width is a shortcut for specifying all dimensions same
    }
    return self;
}

- (void) setWidth:(CGFloat) width {
    // Set the dimensions as well
    dimensions_ = CVBorderDimensionsMake(width, width, width, width);
    width_ = width;
}

- (void) setRoundedRadius:(CGFloat) radius {
    cornerOvalWidth_ = radius * 2;
    cornerOvalHeight_ = cornerOvalWidth_;
    roundedRadius_ = radius;
}

@end

@implementation CVShadowStyle       
@synthesize color = color_;
@synthesize offset = offset_;
@synthesize blur = blur_;

- (void) dealloc {
    [color_ release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        offset_ = CGSizeZero;
        blur_ = 0.0;
    }
    return self;
}

@end

@implementation CVStyle
@synthesize borderStyle = borderStyle_;
@synthesize shadowStyle = shadowStyle_;
@synthesize imageSize = imageSize_;

- (void) dealloc {
    [borderStyle_ release];
    [shadowStyle_ release];
    [super dealloc];
}


- (id) init {
    self = [super init];
    if (self != nil) {
        borderStyle_ = [[CVBorderStyle alloc] init];
        shadowStyle_ = [[CVShadowStyle alloc] init];
        imageSize_ = CGSizeZero;
    }
    return self;
}

@end
