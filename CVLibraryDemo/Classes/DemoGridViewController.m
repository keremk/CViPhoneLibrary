//
//  DemoGridViewController.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 6/24/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "DemoGridViewController.h"
#import "DemoItem.h"
#import "ConfigOptions.h"

@interface DemoGridViewController()
- (void) configureGridViewSelected;
- (void) loadDemoItems;
@end

@implementation DemoGridViewController
@synthesize dataService = dataService_;
@synthesize imageLoadingIcon = imageLoadingIcon_;
@synthesize adornedImageLoadingIcon = adornedImageLoadingIcon_;

- (void)dealloc {
    [demoItems_ release];
    [imageLoadingIcon_ release];
    [adornedImageLoadingIcon_ release];  
    [dataService_ setDelegate:nil];
    [dataService_ release];
    [super dealloc];
}

- (void) loadDemoItems {
    // Set up the demo items
    if (nil == demoItems_) {
        demoItems_ = [[NSMutableArray alloc] init];
        [dataService_ setDelegate:self];
        [dataService_ beginLoadDemoData];
    }
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        demoItems_ = nil;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageLoadingIcon = [UIImage imageNamed:@"LoadingIcon.png"];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Config" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self 
                                                                 action:@selector(configureGridViewSelected)]; 
    self.navigationItem.rightBarButtonItem = barButton;
    [barButton release];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BGTile.png"]]]; 
}

- (UIImage *) adornedImageLoadingIcon {
    if (nil == adornedImageLoadingIcon_) {
        if (nil != self.thumbnailView.cellStyle) {
//            self.adornedImageLoadingIcon = [UIImage adornedImageFromImage:self.imageLoadingIcon usingStyle:self.thumbnailView.cellStyle];
            self.adornedImageLoadingIcon = [self.thumbnailView.cellStyle imageByApplyingStyleToImage:self.imageLoadingIcon];
        }
    }
    return adornedImageLoadingIcon_;
}

- (void) configureGridViewSelected {
    CVSettingsViewController *configViewController = [[[CVSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    ConfigOptions *configOptions = [[ConfigOptions alloc] init];
    configOptions.thumbnailWidth = self.thumbnailView.cellStyle.imageSize.width;
    configOptions.thumbnailHeight = self.thumbnailView.cellStyle.imageSize.height;    
    configOptions.numOfColumns = self.thumbnailView.numOfColumns;
    configOptions.fitNumberOfColumnsToFullWidth = self.thumbnailView.fitNumberOfColumnsToFullWidth;
    configOptions.borderWidth = self.thumbnailView.cellStyle.borderStyle.width;
    configOptions.borderColor = self.thumbnailView.cellStyle.borderStyle.color;
    configOptions.borderRoundedRadius = self.thumbnailView.cellStyle.borderStyle.roundedRadius;
    configOptions.shadowBlur = self.thumbnailView.cellStyle.shadowStyle.blur;
    configOptions.shadowOffsetWidth = self.thumbnailView.cellStyle.shadowStyle.offset.width;
    configOptions.shadowOffsetHeight = self.thumbnailView.cellStyle.shadowStyle.offset.height;    
    configViewController.settingsData = configOptions;
    [configOptions release];
    
    configViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:configViewController];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self 
                                                                 action:@selector(dismissModalViewControllerAnimated:)]; 
    
    configViewController.navigationItem.rightBarButtonItem = barButton;
    [[self navigationController] presentModalViewController:navController animated:YES];    
    [barButton release];
    [navController release];
    //[configViewController release];
}

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
    [dataService_ setDelegate:nil];
}

#pragma mark CVThumbnailGridViewDelegate methods

- (NSInteger) numberOfCellsForThumbnailView:(CVThumbnailGridView *)thumbnailView {
    if (nil == demoItems_) {
        [self loadDemoItems];
    }
    return [demoItems_ count];
}

- (CVThumbnailGridViewCell *)thumbnailView:(CVThumbnailGridView *)thumbnailView cellAtIndexPath:(NSIndexPath *)indexPath {
    CVThumbnailGridViewCell *cell = [thumbnailView dequeueReusableCellWithIdentifier:@"Thumbnails"];
    if (nil == cell) {
        cell = [[[CVThumbnailGridViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Thumbnails"] autorelease];
    }
    
//    NSUInteger index = indexPath.row * [self.thumbnailView numOfColumns] + indexPath.column;
    NSUInteger index = [indexPath indexForNumOfColumns:[self.thumbnailView numOfColumns]];
    DemoItem *demoItem = (DemoItem *) [demoItems_ objectAtIndex:index];
    CVImage *demoImage = [[[CVImageCache sharedCVImageCache] imageForKey:demoItem.imageUrl] retain];
    UIImage *adornedImage = nil;
    if (nil == demoImage) {
        demoImage = [[CVImage alloc] initWithUrl:demoItem.imageUrl indexPath:indexPath];
        [demoImage setDelegate:self];
        [demoImage beginLoadingImage];
        [[CVImageCache sharedCVImageCache] setImage:demoImage];
        adornedImage = self.adornedImageLoadingIcon;
    } else {
        if (demoImage.isLoaded) {
            adornedImage = [demoImage adornedImage];
        } else {
            if (!demoImage.isLoading) {
                [demoImage beginLoadingImage];
            }
            adornedImage = self.adornedImageLoadingIcon;
        }
    } 
    
    [cell setImage:adornedImage];
    [demoImage release];
    return cell;
}

- (void)thumbnailView:(CVThumbnailGridView *)thumbnailView moveCellAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSUInteger startingIndex = [fromIndexPath indexForNumOfColumns:[self.thumbnailView numOfColumns]];
    NSUInteger endingIndex = [toIndexPath indexForNumOfColumns:[self.thumbnailView numOfColumns]];
    
    DemoItem *demoItem = [[demoItems_ objectAtIndex:startingIndex] retain];
    [demoItems_ removeObjectAtIndex:startingIndex];
    [demoItems_ insertObject:demoItem atIndex:endingIndex];
    [demoItem release];
}

- (void) thumbnailView:(CVThumbnailGridView *) thumbnailView didSelectCellAtIndexPath:(NSIndexPath *) indexPath {
    NSUInteger index = indexPath.row * [thumbnailView numOfColumns] + indexPath.column;
    
    
}

#pragma mark DemoDataServiceDelegate methods
- (void) updatedWithItems:(NSArray *) items {
    [demoItems_ addObjectsFromArray:items];
    [self.thumbnailView reloadData];
}

- (void) updatedWithImage:(CVImage *) image {
    CVThumbnailGridViewCell *cell = [self.thumbnailView cellForIndexPath:image.indexPath];
    [cell setImage:image.adornedImage];
}


#pragma mark CVImageLoadingService methods
- (void) beginLoadImageForUrl:(NSString *) url {
    [dataService_ beginLoadImageForUrl:url usingStyle:[self.thumbnailView cellStyle]];
}

#pragma mark GridConfigViewControllerDelegate methods
- (void) configurationUpdatedForGridConfigViewController:(CVSettingsViewController *) controller{
    ConfigOptions *configOptions = controller.settingsData;
        
    [self.thumbnailView setNumOfColumns:configOptions.numOfColumns];
    [self.thumbnailView setFitNumberOfColumnsToFullWidth:configOptions.fitNumberOfColumnsToFullWidth];
    
    CVStyle *cellStyle = [self.thumbnailView cellStyle];
    cellStyle.borderStyle.width = configOptions.borderWidth;
    cellStyle.borderStyle.roundedRadius = configOptions.borderRoundedRadius;
    cellStyle.borderStyle.color = configOptions.borderColor;
    
    cellStyle.shadowStyle.offset = CGSizeMake(configOptions.shadowOffsetWidth, configOptions.shadowOffsetHeight);
    cellStyle.shadowStyle.blur = configOptions.shadowBlur;

    cellStyle.imageSize = CGSizeMake(configOptions.thumbnailWidth, configOptions.thumbnailHeight);

    // Clear the image cache
    [[CVImageCache sharedCVImageCache] clearMemoryCache];
    
    [self.thumbnailView reloadData];
}

@end
