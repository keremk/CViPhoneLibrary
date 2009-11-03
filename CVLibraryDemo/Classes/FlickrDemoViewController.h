//
//  FlickrDemoViewController.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 8/25/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVLibrary.h"
#import "DataServices.h"

@interface FlickrDemoViewController : CVThumbnailGridViewController <DemoDataServiceDelegate> {
    NSMutableArray *flickrItems_;
    id<DemoDataService> dataService_;
    NSUInteger currentPage_;
    NSMutableDictionary *activeDownloads_;
}

@property (nonatomic, retain) id<DemoDataService> dataService;
@end
