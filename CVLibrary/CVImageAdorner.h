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
//    CGSize imageSize_;
//    CGSize targetImageSize_;
//    BOOL upperLeftBadgeExists_, upperRightBadgeExists_, lowerLeftBadgeExists_, lowerRightBadgeExists_;
//    CGSize upperLeftBadgeSize_, upperRightBadgeSize_, lowerLeftBadgeSize_, lowerRightBadgeSize_;
}

@property (nonatomic, retain) CVBorderStyle *borderStyle;
@property (nonatomic, retain) CVShadowStyle *shadowStyle;
//@property (nonatomic) CGSize targetImageSize;               // Bounding size for the adorned image, actual image size will be smaller

//@property (nonatomic) BOOL upperLeftBadgeExists;
//@property (nonatomic) BOOL upperRightBadgeExists;
//@property (nonatomic) BOOL lowerLeftBadgeExists;
//@property (nonatomic) BOOL lowerRightBadgeExists;
//
//@property (nonatomic) CGSize upperLeftBadgeSize;
//@property (nonatomic) CGSize upperRightBadgeSize;
//@property (nonatomic) CGSize lowerLeftBadgeSize;
//@property (nonatomic) CGSize lowerRightBadgeSize;


- (UIImage *) adornedImageFromImage:(UIImage *) image usingTargetImageSize:(CGSize) targetImageSize;
- (CGSize) paddingRequiredForUpperLeftBadgeSize:(CGSize) badgeSize;
//- (CGSize) sizeAfterStylingImage;
//- (CGSize) imageSize;
@end
