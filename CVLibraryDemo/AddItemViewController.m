//
//  AddItemViewController.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 8/15/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "AddItemViewController.h"


@implementation AddItemViewController
@synthesize itemName = itemName_;
@synthesize itemIndex = itemIndex_;

- (void)dealloc {
    [itemName_ release], itemName_ = nil;
    [itemIndex_ release], itemIndex_ = nil;
    [super dealloc];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    
    [itemName_ release], itemName_ = nil;
    [itemIndex_ release], itemIndex_ = nil;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

@end
