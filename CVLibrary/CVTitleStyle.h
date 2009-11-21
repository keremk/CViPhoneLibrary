//
//  CVTextAdorner.h
//  CVLibrary
//
//  Created by Kerem Karatal on 11/13/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
    @abstract   The CVTitleStyle class describes how to render the titles in the thumbnails. 

    @discussion 
*/
@interface CVTitleStyle : NSObject {
    UIFont *font_;
    UILineBreakMode lineBreakMode_;
    UIColor *backgroundColor_;
    UIColor *foregroundColor_;
}

/*!
    @abstract   Instance of UIFont class that describes the font to be used. 

    @discussion Default is Verdana, 10pt
*/
@property (nonatomic, retain) UIFont *font;
/*!
    @abstract   Describes what happens when the text can not fit on one line. Assumes one-line always.

    @discussion Same as the UILineBreakMode in UIKit. Default is UILineBreakModeMiddleTruncation
*/
@property (nonatomic) UILineBreakMode lineBreakMode;
/*!
    @abstract   Text background color to be used.

    @discussion Stretches the full line regardless of the text length. Default is white.
*/
@property (nonatomic, retain) UIColor *backgroundColor;
/*!
    @abstract   Text foreground color to be used.

    @discussion Default is black.
*/
@property (nonatomic, retain) UIColor *foregroundColor;

@end
