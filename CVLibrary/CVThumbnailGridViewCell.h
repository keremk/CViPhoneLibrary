//
//  ThumbnailViewCell.h
//  ColoringBook
//
//  Created by Kerem Karatal on 1/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVImage.h"

@interface CVThumbnailGridViewCell : UIView {
@private
	id delegate_;
	NSIndexPath *indexPath_;
	UIImageView *thumbnailImageView_;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *) identifier;
- (void) setImage:(UIImage *) image;

@end
