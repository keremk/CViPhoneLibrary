//
//  ThumbnailViewCell.m
//  ColoringBook
//
//  Created by Kerem Karatal on 1/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVThumbnailGridViewCell.h"

@interface CVThumbnailGridViewCell()
@property (nonatomic, retain) UIImageView *thumbnailImageView;
@end

@implementation CVThumbnailGridViewCell
@synthesize delegate = delegate_;
@synthesize thumbnailImageView = thumbnailImageView_;
@synthesize indexPath = indexPath_;

- (void)dealloc {
	[indexPath_ release];
	[thumbnailImageView_ release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *) identifier {
    if (self = [super initWithFrame:frame]) {
		thumbnailImageView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
		if (nil == thumbnailImageView_.superview) {
			[self addSubview:thumbnailImageView_];
		}
    }
    return self;
}

- (void) setImage:(UIImage *)image {
	[thumbnailImageView_ setImage:image];
}


- (void) setFrame:(CGRect) frame {
	[super setFrame:frame];
	
    [thumbnailImageView_ setFrame:self.bounds];
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {	
	if ([delegate_ respondsToSelector:@selector(thumbnailSelected:)]) {
		[delegate_ performSelector:@selector(thumbnailSelected:) withObject:self];
	}	
}

@end
