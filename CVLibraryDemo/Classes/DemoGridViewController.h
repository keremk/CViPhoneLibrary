//
//  DemoGridViewController.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 6/24/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVLibrary.h"
#import "DataServices.h"

@interface DemoGridViewController : CVThumbnailGridViewController <DemoDataServiceDelegate, CVImageLoadingService, CVSettingsViewControllerDelegate> {
    NSMutableArray *demoItems_;
    UIImage *imageLoadingIcon_;
    UIImage *adornedImageLoadingIcon_;
    id<DemoDataService> dataService_;
}

@property (nonatomic, retain) id<DemoDataService> dataService;
@property (nonatomic, retain) UIImage *imageLoadingIcon;
@property (nonatomic, retain) UIImage *adornedImageLoadingIcon;
@end
