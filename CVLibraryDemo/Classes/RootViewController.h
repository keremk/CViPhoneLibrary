//
//  RootViewController.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 6/17/09.
//  Copyright Coding Ventures 2009. All rights reserved.
//
#import "FakeDataService.h"
#import "FlickrDataService.h"

@interface RootViewController : UITableViewController {
    NSArray *listOfDemos_;
    FlickrDataService *flickrDataService_;
    FakeDataService *fakeDataService_;
}

@property (nonatomic, retain) NSArray *listOfDemos;

@end
