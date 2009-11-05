//
//  ConfigOptions.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/26/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "ConfigOptions.h"


@implementation ConfigOptions

@synthesize borderColor = borderColor_;
@synthesize borderRoundedRadius = borderRoundedRadius_;
@synthesize numOfColumns = numOfColumns_;
@synthesize fitNumberOfColumnsToFullWidth = fitNumberOfColumnsToFullWidth_;
@synthesize thumbnailWidth = thumbnailWidth_;
@synthesize thumbnailHeight = thumbnailHeight_;
@synthesize borderWidth = borderWidth_;
@synthesize shadowBlur = shadowBlur_;
@synthesize shadowOffsetWidth = shadowOffsetWidth_;
@synthesize shadowOffsetHeight = shadowOffsetHeight_;
@synthesize numOfSides = numOfSides_;
@synthesize shape = shape_;

- (void) dealloc {
    [borderColor_ release], borderColor_ = nil;
    [shape_ release], shape_ = nil;
    [super dealloc];
}


@end
