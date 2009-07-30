//
//  RootViewController.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 6/17/09.
//  Copyright Coding Ventures 2009. All rights reserved.
//

#import "RootViewController.h"
#import "DataServices.h"
#import "FakeDataService.h"
#import "FlickrDataService.h"
#import "CVLibrary.h"
#import "DemoGridViewController.h"

@implementation RootViewController
@synthesize listOfDemos = listOfDemos_;

- (void)dealloc {
    [listOfDemos_ release];
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *) coder {
    if (self = [super initWithCoder:coder]) {
        listOfDemos_ = [[NSArray alloc] initWithObjects:@"Generated Image List", @"Flickr Image List", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


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
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listOfDemos_ count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    
    cell.textLabel.text = [listOfDemos_ objectAtIndex:indexPath.row];
    return cell;
}

#define GENERATED_IMAGE_LIST_DEMO 0
#define FLICKR_IMAGE_LIST_DEMO 1
#define THUMBNAIL_WIDTH 80
#define THUMBNAIL_HEIGHT 87

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CVBorderStyle *borderStyle = [[CVBorderStyle alloc] init];
    borderStyle.width = 3.0;
    borderStyle.roundedRadius = 20.0;
    borderStyle.color = [UIColor orangeColor];
    
    CVShadowStyle *shadowStyle = [[CVShadowStyle alloc] init];
    shadowStyle.offset = CGSizeMake(-10.0, 10.0);
    shadowStyle.blur = 5.0;
    
    CVStyle *cellStyle = [[CVStyle alloc] init];
    cellStyle.borderStyle = borderStyle;
    cellStyle.shadowStyle = shadowStyle;
    cellStyle.imageSize = CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);

    DemoGridViewController *demoGridViewController = [[DemoGridViewController alloc] initWithNibName:nil bundle:nil];
    id<DemoDataService> dataService;
    switch (indexPath.row) {
        case GENERATED_IMAGE_LIST_DEMO : {
            dataService = [[FakeDataService alloc] init];
            break;
        }
        case FLICKR_IMAGE_LIST_DEMO : {
            dataService = [[FlickrDataService alloc] init];
            break;
        }
        default:
            break;
    }    
    [demoGridViewController setDataService:dataService];

    CVThumbnailGridView *gridView = [demoGridViewController thumbnailView];
//    [gridView setThumbnailImageSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
    [gridView setCellStyle:cellStyle];
    [gridView setNumOfColumns:0];
    [gridView setFitNumberOfColumnsToFullWidth:YES];
    
    [self.navigationController pushViewController:demoGridViewController animated:YES];
    
    [borderStyle release];
    [shadowStyle release];
    [cellStyle release];
    [demoGridViewController release];
    [dataService release];    
}

@end

