//
//  EnumOptionsViewController.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionSelectionChangedDelegate
@required
- (void) selectionChangedToOptionIndex:(NSUInteger) index;
@end


@interface EnumOptionsViewController : UITableViewController {
    NSArray *options_;
    id<OptionSelectionChangedDelegate> delegate_;
    UIImage *checkedImage_;
    UIImage *uncheckedImage_;
    NSUInteger selectedIndex_;
}

@property (assign) id delegate;
@property (nonatomic, retain) NSArray *options;
@property (nonatomic) NSUInteger selectedIndex;
@end
