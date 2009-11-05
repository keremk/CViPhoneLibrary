//
//  CVStyle.h
//  CVLibrary
//
//  Created by Kerem Karatal on 5/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVBorderStyle.h"
#import "CVShadowStyle.h"

@interface CVImageAdorner : NSObject {
    CVBorderStyle *borderStyle_;
    CVShadowStyle *shadowStyle_;
}

@property (nonatomic, retain) CVBorderStyle *borderStyle;
@property (nonatomic, retain) CVShadowStyle *shadowStyle;

- (UIImage *) adornedImageFromImage:(UIImage *) image usingTargetImageSize:(CGSize) targetImageSize;
- (CGSize) paddingRequiredForUpperLeftBadgeSize:(CGSize) badgeSize;
@end
