/*
 *  CVStyleProtocols.h
 *  CVLibrary
 *
 *  Created by Kerem Karatal on 8/10/09.
 *  Copyright 2009 Coding Ventures. All rights reserved.
 *
 */

/*!
    @abstract   Protocol required by all image adorner implementations.

    @discussion 
*/
@protocol CVRenderStyle<NSObject>
@required
/*!
    @abstract   Draw the image in the given context

    @discussion 
    @param      context Context to be drawn into.
    @param      imageSize The original input image size. The final size is calculated based on the additional requirements of the adornment drawn. For example for a simple rectangular border the image size will grow by the width of the border.
*/
- (void) drawInContext:(CGContextRef) context forImageSize:(CGSize) imageSize; 
/*!
    @abstract   The additional size required for rendering this adornment.

    @discussion For example for a rectangular border it is: width = 2 * width of border; height = 2 * width of border.
    @result     The size required.
*/
- (CGSize) sizeRequiredForRendering;
@end

/*!
    @abstract   Protocol required by the border style image adorner implementations.

    @discussion 
*/
@protocol CVBorderStyle<CVRenderStyle> 
@required
/*!
    @abstract   The color of the border to be rendered.

    @discussion 
*/
@property (nonatomic, retain) UIColor *color;
/*!
    @abstract   The width of the border to be rendered.

    @discussion 
*/
@property (nonatomic) CGFloat width;
@end