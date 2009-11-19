//
//  CVEllipseBorder.h
//  CVLibrary
//
//  Created by Kerem Karatal on 9/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyleProtocols.h"

/*!
    @abstract   The CVEllipseBorder class describes how to provide an elliptical border for a given image.

    @discussion The image is cropped to stay within the border. The ellipse is automatically created to fit within the rectangular area of the required final image size.
*/
@interface CVEllipseBorder : NSObject<CVBorderStyle> {
    CGFloat width_;
    UIColor *color_;
}

@end
