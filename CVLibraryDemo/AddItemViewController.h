//
//  AddItemViewController.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 8/15/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddItemViewController : UIViewController {
    UITextField *itemName_;
    UITextField *itemIndex_;
}

@property (nonatomic, retain) IBOutlet UITextField *itemName;
@property (nonatomic, retain) IBOutlet UITextField *itemIndex;

@end
