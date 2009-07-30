//
//  EnumOptionsViewController.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "EnumOptionsViewController.h"

@interface EnumOptionsViewController()
- (UITableViewCell *) tableView:(UITableView *) tableView cellWithReuseIdentifier:(NSString *) identifier;
@end


@implementation EnumOptionsViewController
@synthesize options = options_;
@synthesize delegate = delegate_;
@synthesize selectedIndex = selectedIndex_;

- (void)dealloc {
    [options_ release];
    [checkedImage_ release];
    [uncheckedImage_ release];
    [super dealloc];
}



- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
        checkedImage_ = [[UIImage imageNamed:@"Checkmark_On.png"] retain];
        uncheckedImage_ = [[UIImage imageNamed:@"Checkmark_Off.png"] retain];
        selectedIndex_ = 0;
    }
    return self;
}


/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    [delegate_ selectionChangedToOptionIndex:selectedIndex_];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [options_ count];
}

#define CHECKBOX_TAG 0
#define LABEL_TAG 1

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CheckboxCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self tableView:tableView cellWithReuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    UILabel *label = (UILabel *) [cell viewWithTag:LABEL_TAG];
	label.text = [options_ objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:CHECKBOX_TAG];
    if (indexPath.row == selectedIndex_) {
        imageView.image = checkedImage_;
    } else {
        imageView.image = uncheckedImage_;
    }

    
    return cell;
}

#define LEFT_COLUMN_OFFSET 10.0
#define LEFT_COLUMN_WIDTH 160.0

#define RIGHT_COLUMN_OFFSET 40.0
#define RIGHT_COLUMN_WIDTH 100.0

#define MAIN_FONT_SIZE 16.0
#define LABEL_HEIGHT 26.0

- (UITableViewCell *) tableView:(UITableView *) tableView cellWithReuseIdentifier:(NSString *) identifier {    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:checkedImage_];
    imageView.frame = CGRectMake(LEFT_COLUMN_OFFSET, ((tableView.rowHeight - imageView.frame.size.height) / 2.0), imageView.frame.size.width, imageView.frame.size.height);
    imageView.tag = CHECKBOX_TAG;
    [cell.contentView addSubview:imageView];
    [imageView release];
    
    CGRect frame = CGRectMake(RIGHT_COLUMN_OFFSET, (tableView.rowHeight - LABEL_HEIGHT) / 2.0, RIGHT_COLUMN_WIDTH, LABEL_HEIGHT);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.tag = LABEL_TAG;
    label.font = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
    label.textAlignment = UITextAlignmentLeft;
    [cell.contentView addSubview:label];
    [label release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imageView = nil;
        
    NSUInteger indexes[2] = { 0, selectedIndex_ };
    NSIndexPath *selectedIndexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
    imageView = (UIImageView *) [[tableView cellForRowAtIndexPath:selectedIndexPath] viewWithTag:CHECKBOX_TAG];
    imageView.image = uncheckedImage_;
    
    imageView = (UIImageView *) [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:CHECKBOX_TAG];
    imageView.image = checkedImage_;
    
    selectedIndex_ = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

