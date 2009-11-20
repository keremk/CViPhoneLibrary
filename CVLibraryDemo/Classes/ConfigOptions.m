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
@synthesize thumbnailWidth = thumbnailWidth_;
@synthesize thumbnailHeight = thumbnailHeight_;
@synthesize borderWidth = borderWidth_;
@synthesize shadowBlur = shadowBlur_;
@synthesize shadowOffsetWidth = shadowOffsetWidth_;
@synthesize shadowOffsetHeight = shadowOffsetHeight_;
@synthesize numOfSides = numOfSides_;
@synthesize shape = shape_;
@synthesize leftMargin = leftMargin_;
@synthesize rightMargin = rightMargin_;
@synthesize columnSpacing = columnSpacing_;
@synthesize rotationAngle = rotationAngle_;
@synthesize showTitles = showTitles_;
@synthesize editMode = editMode_;
@synthesize deleteSignSideLength = deleteSignSideLength_;
@synthesize deleteSignBackgroundColor = deleteSignBackgroundColor_;
@synthesize deleteSignForegroundColor = deleteSignForegroundColor_;

- (void) dealloc {
    [deleteSignBackgroundColor_ release], deleteSignBackgroundColor_ = nil;
    [deleteSignForegroundColor_ release], deleteSignForegroundColor_ = nil;
    [borderColor_ release], borderColor_ = nil;
    [shape_ release], shape_ = nil;
    [super dealloc];
}


@end

