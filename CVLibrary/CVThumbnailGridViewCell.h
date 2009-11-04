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

@protocol CVThumbnailGridViewCellDelegate;

@interface CVThumbnailGridViewCell : UIView {
@private
	id<CVThumbnailGridViewCellDelegate> delegate_;
	NSIndexPath *indexPath_;
    CGPoint touchLocation_; // Location of touch in own coordinates (stays constant during dragging).
    BOOL dragging_, editing_, selected_;
    CGRect home_;
    UIImage *thumbnailImage_;
    CVImageAdorner *imageAdorner_;
    NSString *imageUrl_;
}

@property (nonatomic, assign) id<CVThumbnailGridViewCellDelegate> delegate;
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

@protocol CVThumbnailGridViewCellDelegate <NSObject>
@required
@property (nonatomic, retain) UIImage *deleteSignIcon;
@property (nonatomic) CGFloat selectionBorderWidth;
@property (nonatomic, copy) UIColor *selectionBorderColor;
@property (nonatomic) BOOL editModeEnabled;

@optional
- (void) deleteSignWasTapped:(CVThumbnailGridViewCell *) cell;
- (void) thumbnailGridViewCellWasTapped:(CVThumbnailGridViewCell *) cell;
- (void) thumbnailGridViewCellStartedTracking:(CVThumbnailGridViewCell *) cell;
- (void) thumbnailGridViewCellMoved:(CVThumbnailGridViewCell *) cell;
- (void) thumbnailGridViewCellStoppedTracking:(CVThumbnailGridViewCell *) cell;
@end

