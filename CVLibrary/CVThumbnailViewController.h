//
//  CVThumbnailViewController.h
//  CVLibrary
//
//  Created by Kerem Karatal on 1/22/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVThumbnailView.h"
#import "CVThumbnailViewCell.h"

/*!
    @abstract   The CVThumbnailViewController class creates a controller object that manages a table view. 

    @discussion 
*/
@interface CVThumbnailViewController : UIViewController<CVThumbnailViewDataSource, CVThumbnailViewDelegate> {
	BOOL firstTimeDisplay_;
    CVThumbnailView *thumbnailView_;
}

/*!
    @abstract   The instance of thumbnail view that is being controlled by CVThumbnailViewController.

    @discussion 
*/
@property (nonatomic, readonly) CVThumbnailView *thumbnailView;

@end
