//
//  CVTextAdorner.m
//  CVLibrary
//
//  Created by Kerem Karatal on 11/13/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVTitleStyle.h"


@implementation CVTitleStyle
@synthesize font = font_;
@synthesize lineBreakMode = lineBreakMode_;
@synthesize backgroundColor = backgroundColor_;
@synthesize foregroundColor = foregroundColor_;

- (void) dealloc {
    [font_ release], font_ = nil;
    [backgroundColor_ release], backgroundColor_ = nil;
    [foregroundColor_ release], foregroundColor_ = nil;
    [super dealloc];
}

#define DEFAULT_FONT_FAMILY_NAME @"Verdana"
#define DEFAULT_FONT_SIZE 10

- (id) init {
    self = [super init];
    if (self != nil) {
        self.backgroundColor = [UIColor yellowColor];
        self.foregroundColor = [UIColor blackColor];
        lineBreakMode_ = UILineBreakModeMiddleTruncation;
        self.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY_NAME size:DEFAULT_FONT_SIZE];
    }
    return self;
} 

@end
