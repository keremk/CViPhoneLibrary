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
#import "FlickrDemoViewController.h"
#import "TestView.h"

@interface RootViewController()
- (UIView *) testViewWithText:(NSString *) text;
@end


@implementation RootViewController
@synthesize listOfDemos = listOfDemos_;

- (void)dealloc {
    [listOfDemos_ release], listOfDemos_ = nil;
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *) coder {
    if (self = [super initWithCoder:coder]) {
        listOfDemos_ = [[NSArray alloc] initWithObjects:@"Generated Image List", @"Flickr Image List", @"Edit Image List", @"Many Images Demo", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

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
#define EDIT_IMAGE_LIST_DEMO 2
#define MANY_IMAGES_DEMO 3
#define THUMBNAIL_WIDTH 70
#define THUMBNAIL_HEIGHT 70 

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    CVRoundedRectBorder *borderStyle = [[CVRoundedRectBorder alloc] init];
//    borderStyle.width = 3.0;
//    borderStyle.radius = 20.0;
//    borderStyle.color = [UIColor orangeColor];

    CVPolygonBorder *borderStyle = [[CVPolygonBorder alloc] init];
    borderStyle.width = 5.0;
//    borderStyle.radius = THUMBNAIL_WIDTH / 2;
    borderStyle.color = [UIColor orangeColor];
    borderStyle.numOfSides = 5;
//
//    CVEllipseBorder *borderStyle = [[CVEllipseBorder alloc] init];
//    borderStyle.width = 5.0;
//    borderStyle.color = [UIColor orangeColor];
    
    CVShadowStyle *shadowStyle = [[CVShadowStyle alloc] init];
    shadowStyle.offset = CGSizeMake(-10.0, 10.0);
//    shadowStyle.offset = CGSizeZero;
    shadowStyle.blur = 5.0;
    
    CVImageAdorner *imageAdorner = [[CVImageAdorner alloc] init];
    imageAdorner.borderStyle = borderStyle;
    imageAdorner.shadowStyle = shadowStyle;
//    imageAdorner.targetImageSize = CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
    
    id<DemoDataService> dataService = nil;
    switch (indexPath.row) {
        case GENERATED_IMAGE_LIST_DEMO : {
            DemoGridViewController *demoGridViewController = [[DemoGridViewController alloc] initWithNibName:nil bundle:nil];
            dataService = [[FakeDataService alloc] init];
            [demoGridViewController setDataService:dataService];
            [self.navigationController pushViewController:demoGridViewController animated:YES];
            
            CVThumbnailGridView *gridView = [demoGridViewController thumbnailView];
            [gridView setImageAdorner:imageAdorner];
            [gridView setNumOfColumns:0];
            [gridView setRightMargin:20.0];
            [gridView setLeftMargin:20.0];
            [gridView setEditing:YES];
            [gridView setEditModeEnabled:YES];
            [gridView setFitNumberOfColumnsToFullWidth:YES];
            [gridView setThumbnailCellSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
            [demoGridViewController release];
            
            break;
        }
        case FLICKR_IMAGE_LIST_DEMO : {
            DemoGridViewController *demoGridViewController = [[DemoGridViewController alloc] initWithNibName:nil bundle:nil];
            dataService = [[FlickrDataService alloc] init];
            [demoGridViewController setDataService:dataService];
            [self.navigationController pushViewController:demoGridViewController animated:YES];
            
            CVThumbnailGridView *gridView = [demoGridViewController thumbnailView];
            [gridView setImageAdorner:imageAdorner];
            [gridView setNumOfColumns:0];
            [gridView setEditModeEnabled:NO];
            [gridView setFitNumberOfColumnsToFullWidth:YES];
            [gridView setThumbnailCellSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
            [demoGridViewController release];
            
            break;
        }
        case EDIT_IMAGE_LIST_DEMO : {
            DemoGridViewController *demoGridViewController = [[DemoGridViewController alloc] initWithNibName:nil bundle:nil];
            dataService = [[FakeDataService alloc] init];
            [demoGridViewController setConfigEnabled:NO];
            demoGridViewController.navigationItem.rightBarButtonItem = [demoGridViewController editButtonItem];
            [demoGridViewController setDataService:dataService];    
            [self.navigationController pushViewController:demoGridViewController animated:YES];
            
            CVThumbnailGridView *gridView = [demoGridViewController thumbnailView];
            [gridView setImageAdorner:imageAdorner];
            [gridView setNumOfColumns:0];
            [gridView setEditModeEnabled:YES];
            [demoGridViewController setConfigEnabled:NO];
            demoGridViewController.navigationItem.rightBarButtonItem = [demoGridViewController editButtonItem];
            [gridView setHeaderView:[self testViewWithText:@"Header View"]];
            [gridView setFooterView:[self testViewWithText:@"Footer View"]];            
            [gridView setFitNumberOfColumnsToFullWidth:YES];
            [gridView setThumbnailCellSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
            [demoGridViewController release];
            
            break;
        }
        case MANY_IMAGES_DEMO : {
            FlickrDemoViewController *flickrDemoViewController = [[FlickrDemoViewController alloc] initWithNibName:nil bundle:nil];
            dataService = [[FlickrDataService alloc] init];
            [flickrDemoViewController setDataService:dataService];
            [self.navigationController pushViewController:flickrDemoViewController animated:YES];
            
            CVThumbnailGridView *gridView = [flickrDemoViewController thumbnailView];
            [gridView setImageAdorner:imageAdorner];
            [gridView setNumOfColumns:0];
            [gridView setEditModeEnabled:NO];
            [gridView setFitNumberOfColumnsToFullWidth:YES];
            [gridView setThumbnailCellSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
            [flickrDemoViewController release];
            break;
        }
        default:
            break;
    }    
        
    [borderStyle release];
    [shadowStyle release];
    [imageAdorner release];
    [dataService release];    
}

- (UIView *) testViewWithText:(NSString *) text {
    TestView *testView = [[[TestView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)] autorelease];
    
    [testView setBackgroundColor:[UIColor blueColor]];
    [testView setText:text];
    return testView;
}

@end

