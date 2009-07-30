//
//  ThumbnailViewController.h
//  ColoringBook
//
//  Created by Kerem Karatal on 1/22/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVThumbnailGridView.h"
#import "CVThumbnailGridViewCell.h"

@interface CVThumbnailGridViewController : UIViewController<CVThumbnailGridViewDataSource, CVThumbnailGridViewDelegate> {
	BOOL firstTimeDisplay_;
}

@property (nonatomic, readonly) CVThumbnailGridView *thumbnailView;
@property (nonatomic) NSUInteger numOfColumns;

@end
