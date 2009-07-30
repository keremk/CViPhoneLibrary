//
//  CVLibraryDemoAppDelegate.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 6/17/09.
//  Copyright Coding Ventures 2009. All rights reserved.
//

#import "CVLibraryDemoAppDelegate.h"
#import "RootViewController.h"

@implementation CVLibraryDemoAppDelegate

@synthesize window = window_;
@synthesize navigationController = navigationController_;
@synthesize rootViewController = rootViewController_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController_ release];
	[window_ release];
	[super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Override point for customization after app launch    
    
	[self.window addSubview:[self.navigationController view]];
    [self.window makeKeyAndVisible];                        
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


@end

