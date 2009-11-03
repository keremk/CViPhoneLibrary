//
//  CVBorderStyle.m
//  CVLibrary
//
//  Created by Kerem Karatal on 8/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVBorderStyle.h"

@implementation CVBorderStyle
@synthesize color = color_;
@synthesize width = width_;

- (void) dealloc {
    [color_ release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        // Set the defaults
        color_ = [UIColor blackColor]; 
        self.width = 0.0;           
    }
    return self;
}

#pragma mark CVRenderStyle

// Blank implementation for the abstract base class, subclasses must implement
- (void) drawInContext:(CGContextRef) context forImageSize:(CGSize) imageSize {

}

//- (CGSize) sizeAfterRenderingGivenInitialSize:(CGSize) size {
//    return size;
//}

- (CGSize) sizeRequiredForRendering {
    
    return CGSizeZero;
}

- (CGPoint) upperLeftCorner {
    return CGPointZero;
}
@end
