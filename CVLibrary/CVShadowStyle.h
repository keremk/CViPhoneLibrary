//
//  CVShadowStyle.h
//  CVLibrary
//
//  Created by Kerem Karatal on 8/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyleProtocols.h"

/*!
    @abstract   The CVShadowStyle class is used for describing how the shadow adornments can be rendered on a given image.

    @discussion 
*/
@interface CVShadowStyle : NSObject<CVRenderStyle> {
@private
    CGSize offset_;
    CGFloat blur_;
    UIColor *color_;
}

/*!
    @abstract   The color of the shadow to be rendered.

    @discussion 
*/
@property (nonatomic, retain) UIColor *color;
/*!
    @abstract   Specifies a translation of the context’s coordinate system, to establish an offset for the shadow.
 
    @discussion For example, {0,0} specifies a light source immediately above the screen. Note that the coordinate system origin is the lower-left corner in this case (in line with Quartz coordinate system.) Default is {0, 0} - no shadow.
*/
@property (nonatomic) CGSize offset;
/*!
    @abstract   A non-negative number specifying the amount of blur.

    @discussion Default is 0.0.
*/
@property (nonatomic) CGFloat blur;

/*!
    @abstract   The offset that takes into account the gradient caused by non-zero blur.

    @discussion This is useful in calculating the bounding rectangle of the image. For example, as the shadow gradients from black to white due to blur, if we cut it off at the offset number of pixels, the image looks cut-off.  
    @result     Offset + a set number of pixels.
*/
- (CGSize) offsetWithBlurPixels;
@end
