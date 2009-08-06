//
//  ThumbnailViewCell.h
//  ColoringBook
//
//  Created by Kerem Karatal on 1/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVImage.h"

@protocol CVThumbnailGridViewCellDelegate;

@interface CVThumbnailGridViewCell : UIView {
@private
	id delegate_;
	NSIndexPath *indexPath_;
	UIImageView *thumbnailImageView_;
    CGPoint touchLocation_; // Location of touch in own coordinates (stays constant during dragging).
    BOOL dragging_;
    CGRect home_;
}

@property (nonatomic, assign) id<CVThumbnailGridViewCellDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) CGRect home;
@property (nonatomic, assign) CGPoint touchLocation;

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *) identifier;
- (void) setImage:(UIImage *) image;

@end

@protocol CVThumbnailGridViewCellDelegate <NSObject>

@optional
- (void)thumbnailGridViewCellWasTapped:(CVThumbnailGridViewCell *) cell;
- (void)thumbnailGridViewCellStartedTracking:(CVThumbnailGridViewCell *) cell;
- (void)thumbnailGridViewCellMoved:(CVThumbnailGridViewCell *) cell;
- (void)thumbnailGridViewCellStoppedTracking:(CVThumbnailGridViewCell *) cell;

@end
