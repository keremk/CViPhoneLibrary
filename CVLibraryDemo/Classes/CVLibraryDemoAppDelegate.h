//
//  CVLibraryDemoAppDelegate.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 6/17/09.
//  Copyright Coding Ventures 2009. All rights reserved.
//

@class RootViewController;

@interface CVLibraryDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window_;
    UINavigationController *navigationController_;
    RootViewController *rootViewController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

