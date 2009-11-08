//
//  ThumbnailViewController.h
//  ColoringBook
//
//  Created by Kerem Karatal on 1/22/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVThumbnailView.h"
#import "CVThumbnailViewCell.h"

@interface CVThumbnailViewController : UIViewController<CVThumbnailViewDataSource, CVThumbnailViewDelegate> {
	BOOL firstTimeDisplay_;
    CVThumbnailView *thumbnailView_;
}

@property (nonatomic, readonly) CVThumbnailView *thumbnailView;

@end
