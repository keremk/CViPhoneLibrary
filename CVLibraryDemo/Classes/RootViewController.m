//
//  RootViewController.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 6/17/09.
//  Copyright Coding Ventures 2009. All rights reserved.
//

#import "RootViewController.h"
#import "DataServices.h"
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
    [flickrDataService_ release], flickrDataService_ = nil;
    [fakeDataService_ release], fakeDataService_ = nil;
    [super dealloc];
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

- (id) initWithCoder:(NSCoder *) coder {
    if (self = [super initWithCoder:coder]) {
        listOfDemos_ = [[NSArray alloc] initWithObjects:@"Generated Image List", @"Flickr Image List", @"Edit Image List", @"Many Images Demo", nil];
        flickrDataService_ = [[FlickrDataService alloc] init];
        [flickrDataService_ cleanupDiskCache];
        fakeDataService_ = [[FakeDataService alloc] init];
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
    CVPolygonBorder *borderStyle = [[CVPolygonBorder alloc] init];
    borderStyle.width = 5.0;
    borderStyle.color = [UIColor orangeColor];
    borderStyle.numOfSides = 5;

    CVPolygonBorder *selectedBorderStyle = [[CVPolygonBorder alloc] init];
    selectedBorderStyle.width = 5.0;
    selectedBorderStyle.color = [UIColor redColor];
    selectedBorderStyle.numOfSides = 5;
        
    CVShadowStyle *shadowStyle = [[CVShadowStyle alloc] init];
    shadowStyle.offset = CGSizeMake(-10.0, 10.0);
    shadowStyle.blur = 5.0;
    
    CVImageAdorner *imageAdorner = [[CVImageAdorner alloc] init];
    imageAdorner.borderStyle = borderStyle;
    imageAdorner.shadowStyle = shadowStyle;
    
    CVImageAdorner *selectedImageAdorner = [[CVImageAdorner alloc] init];
    selectedImageAdorner.borderStyle = selectedBorderStyle;
    selectedImageAdorner.shadowStyle = shadowStyle;
    
    CVTitleStyle *titleStyle = [[CVTitleStyle alloc] init];
    titleStyle.font = [UIFont fontWithName:@"Verdana" size:10.0];
    titleStyle.lineBreakMode = UILineBreakModeMiddleTruncation;
    titleStyle.backgroundColor = [UIColor whiteColor];
    titleStyle.foregroundColor = [UIColor blackColor];
    
    switch (indexPath.row) {
        case GENERATED_IMAGE_LIST_DEMO : {
            DemoGridViewController *demoGridViewController = [[DemoGridViewController alloc] initWithNibName:nil bundle:nil];
            [demoGridViewController setDataService:fakeDataService_];
            [self.navigationController pushViewController:demoGridViewController animated:YES];
            
            CVThumbnailView *gridView = [demoGridViewController thumbnailView];
            [gridView setImageAdorner:imageAdorner];
            [gridView setSelectedImageAdorner:selectedImageAdorner];
            [gridView setRightMargin:20.0];
            [gridView setLeftMargin:20.0];
            [gridView setEditing:YES];
            [gridView setEditModeEnabled:YES];
            [gridView setThumbnailCellSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
            
            [gridView setShowDefaultSelectionEffect:YES];
            [gridView setSelectionBorderColor:[UIColor orangeColor]];
            [gridView setSelectionBorderWidth:6.0];
            [demoGridViewController release];
            
            break;
        }
        case FLICKR_IMAGE_LIST_DEMO : {
            DemoGridViewController *demoGridViewController = [[DemoGridViewController alloc] initWithNibName:nil bundle:nil];
            [demoGridViewController setDataService:flickrDataService_];
            [self.navigationController pushViewController:demoGridViewController animated:YES];
            
            CVThumbnailView *gridView = [demoGridViewController thumbnailView];
            [gridView setImageAdorner:imageAdorner];
            [gridView setSelectedImageAdorner:selectedImageAdorner];   
            [gridView setTitleStyle:titleStyle];
            [gridView setShowDefaultSelectionEffect:NO];
            [gridView setEditModeEnabled:NO];
            [gridView setThumbnailCellSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
            [gridView setShowTitles:YES];
            [demoGridViewController release];
            
            break;
        }
        case EDIT_IMAGE_LIST_DEMO : {
            DemoGridViewController *demoGridViewController = [[DemoGridViewController alloc] initWithNibName:nil bundle:nil];
            [demoGridViewController setConfigEnabled:NO];
            demoGridViewController.navigationItem.rightBarButtonItem = [demoGridViewController editButtonItem];
            [demoGridViewController setDataService:fakeDataService_];    
            [self.navigationController pushViewController:demoGridViewController animated:YES];
            
            CVThumbnailView *gridView = [demoGridViewController thumbnailView];
            [gridView setImageAdorner:imageAdorner];
            [gridView setSelectedImageAdorner:selectedImageAdorner];
            [gridView setEditModeEnabled:YES];
            [demoGridViewController setConfigEnabled:NO];
            demoGridViewController.navigationItem.rightBarButtonItem = [demoGridViewController editButtonItem];
            [gridView setHeaderView:[self testViewWithText:@"Header View"]];
            [gridView setFooterView:[self testViewWithText:@"Footer View"]];            
            [gridView setThumbnailCellSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
            [demoGridViewController release];
            
            break;
        }
        case MANY_IMAGES_DEMO : {
            FlickrDemoViewController *flickrDemoViewController = [[FlickrDemoViewController alloc] initWithNibName:nil bundle:nil];
            [flickrDemoViewController setDataService:flickrDataService_];
            [self.navigationController pushViewController:flickrDemoViewController animated:YES];
            
            CVThumbnailView *gridView = [flickrDemoViewController thumbnailView];
            [gridView setImageAdorner:imageAdorner];
            [gridView setSelectedImageAdorner:selectedImageAdorner];
            [gridView setEditModeEnabled:NO];
            [gridView setShowTitles:NO];
            [gridView setThumbnailCellSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
            [flickrDemoViewController release];
            break;
        }
        default:
            break;
    }    
        
    [borderStyle release], borderStyle = nil;
    [selectedBorderStyle release], selectedBorderStyle = nil;
    [shadowStyle release], shadowStyle = nil;
    [imageAdorner release], imageAdorner = nil;
    [selectedImageAdorner release], selectedImageAdorner = nil;
    [titleStyle release], titleStyle = nil;
    
}

- (UIView *) testViewWithText:(NSString *) text {
    TestView *testView = [[[TestView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)] autorelease];
    
    [testView setBackgroundColor:[UIColor blueColor]];
    [testView setText:text];
    return testView;
}

@end

