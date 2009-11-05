//
//  CVSettingsViewController.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/2/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellHandler.h"
#import "CVLibrary.h"

@class CVSettingsViewController;

@protocol CVSettingsViewControllerDelegate <NSObject>
- (void) configurationUpdatedForGridConfigViewController:(CVSettingsViewController *) controller;
@end

@interface CVSettingsViewController : UITableViewController <CellHandlerDelegate> {
    NSArray *configSections_;
    id<CVSettingsViewControllerDelegate> delegate_;
    id settingsData_;
    NSMutableArray *cellHandlers_;
    NSMutableArray *sectionNames_;
}

@property (assign) id<CVSettingsViewControllerDelegate> delegate;
@property (nonatomic, retain) id settingsData;
@end


