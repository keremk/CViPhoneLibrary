//
//  ThumbnailViewCell.h
//  ColoringBook
//
//  Created by Kerem Karatal on 1/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVImage.h"
#import "CVImageAdorner.h"

@protocol CVThumbnailViewCellDelegate;

@interface CVThumbnailViewCell : UIView {
@private
	id<CVThumbnailViewCellDelegate> delegate_;
	NSIndexPath *indexPath_;
    CGPoint touchLocation_; // Location of touch in own coordinates (stays constant during dragging).
    BOOL dragging_; 
    BOOL editing_;
    BOOL selected_;
    CGRect home_;
    UIImage *thumbnailImage_;
    CVImageAdorner *imageAdorner_;
    NSString *imageUrl_;
}

@property (nonatomic, assign) id<CVThumbnailViewCellDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) CGRect home;
@property (nonatomic, assign) CGPoint touchLocation;
@property (nonatomic, retain) CVImageAdorner *imageAdorner;
@property (nonatomic) BOOL editing; 
@property (nonatomic) BOOL selected;
@property (nonatomic, copy) NSString *imageUrl;

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *) identifier;
- (void) setImage:(UIImage *) image;
- (void) goHome;
- (void) moveByOffset:(CGPoint)offset;
@end

@protocol CVThumbnailViewCellDelegate <NSObject>
@required
@property (nonatomic, retain) UIImage *deleteSignIcon;
@property (nonatomic) CGFloat selectionBorderWidth;
@property (nonatomic, copy) UIColor *selectionBorderColor;
@property (nonatomic) BOOL editModeEnabled;

@optional
- (void) deleteSignWasTapped:(CVThumbnailViewCell *) cell;
- (void) thumbnailGridViewCellWasTapped:(CVThumbnailViewCell *) cell;
- (void) thumbnailGridViewCellStartedTracking:(CVThumbnailViewCell *) cell;
- (void) thumbnailGridViewCellMoved:(CVThumbnailViewCell *) cell;
- (void) thumbnailGridViewCellStoppedTracking:(CVThumbnailViewCell *) cell;
@end

