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
#import "AddItemViewController.h"

@interface DemoGridViewController : CVThumbnailGridViewController <DemoDataServiceDelegate, CVSettingsViewControllerDelegate> {
    NSMutableArray *demoItems_;
    id<DemoDataService> dataService_;
    BOOL configEnabled_;
    AddItemViewController *addItemViewController_;
    NSMutableDictionary *activeDownloads_;
}

@property (nonatomic, retain) id<DemoDataService> dataService;
@property (nonatomic) BOOL configEnabled;
@end
