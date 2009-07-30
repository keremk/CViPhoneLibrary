//
//  UIImage+Adornments.h
//  CVLibrary
//
//  Created by Kerem Karatal on 6/4/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyle.h"

@interface UIImage (CVAdornments)
+ (CGSize) adornedImageSizeForImageSize:(CGSize) size usingStyle:(CVStyle *) style;
+ (UIImage *) adornedImageFromImage:(UIImage *) image usingStyle:(CVStyle *) style; 

- (NSUInteger) imageMemorySize;
@end
