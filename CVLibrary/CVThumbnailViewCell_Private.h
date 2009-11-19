/*
 *  CVThumbnailViewCell_Private.h
 *  CVLibrary
 *
 *  Created by Kerem Karatal on 11/17/09.
 *  Copyright 2009 Coding Ventures. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>

@interface CVThumbnailViewCell() 
/*!
    @abstract   The rectangle that defines the position of the cell.

    @discussion Mainly intended for use by the thumbnail view to control movements, deletions, insertions.
*/
@property (nonatomic, assign) CGRect home;
/*!
    @abstract   The location of the touch as tracked by touch movements.

    @discussion Mainly intended for use by the thumbnail view to control movements, deletions, insertions.
*/
@property (nonatomic, assign) CGPoint touchLocation;
/*!
    @abstract   Indicates whether the cell is in edit mode.
 
    @discussion By default a delete sign is displayed when in edit mode.
*/
@property (nonatomic) BOOL editing; 
@property (nonatomic, retain) UIImage *thumbnailImage;
@property (nonatomic, readonly) CVImageAdorner *imageAdorner;

- (UIImage *) deleteSignIcon;
- (CGFloat) deleteSignSideLength;
- (CGRect) deleteSignRect;

- (void) goHome;
- (void) moveByOffset:(CGPoint)offset;
@end
