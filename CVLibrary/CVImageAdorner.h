//
//  CVStyle.h
//  CVLibrary
//
//  Created by Kerem Karatal on 5/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVShadowStyle.h"

/*!
    @abstract   The CVImageAdorner class is used for rendering border and shadow adornments on images.

    @discussion 
*/
@interface CVImageAdorner : NSObject {
    id<CVBorderStyle> borderStyle_;
    CVShadowStyle *shadowStyle_;
}

/*!
    @abstract   The border adornment to be used in rendering the image.

    @discussion 
*/
@property (nonatomic, retain) id<CVBorderStyle> borderStyle;
/*!
    @abstract   The shadow adornment to be used in rendering the image.

    @discussion 
*/
@property (nonatomic, retain) CVShadowStyle *shadowStyle;

/*!
    @abstract   Creates a new adorned image from a given image.

    @discussion 
    @param      image The instance of UIImage class to be adorned.
    @param      targetImageSize The final bounding image size to be created. The inner image size (inside the border and shadow adornments) is calculated.
    @result     The instance of UIImage class that represents the adorned image.
*/
- (UIImage *) adornedImageFromImage:(UIImage *) image usingTargetImageSize:(CGSize) targetImageSize;
/*!
    @abstract   The size of the padding required for an upper left badge. 

    @discussion Usually the upper left badge can be things like a delete icon in editing mode of a thumbnail view.
    @param      badgeSize The size of the badge that will be used.
    @result     The size is calculated taking into account things like shadow direction and the shape of the border.
*/
- (CGSize) paddingRequiredForUpperLeftBadgeSize:(CGSize) badgeSize;
@end
