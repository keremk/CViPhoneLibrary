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
#import "FakeDataService.h"

@interface DemoGridViewController()
- (void) configureGridViewSelected;
- (void) loadDemoItems;
- (void) addNewItem:(id) sender;
- (void) insertNewItem:(id) sender;
@end

@implementation DemoGridViewController
@synthesize dataService = dataService_;
@synthesize configEnabled = configEnabled_;

- (void)dealloc {
    [demoItems_ release];
    [dataService_ setDelegate:nil];
    [dataService_ release];
    [addItemViewController_ release];
    [activeDownloads_ release];
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
        configEnabled_ = YES;
        addItemViewController_ = nil;
        activeDownloads_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) setEditing:(BOOL) editing animated:(BOOL) animated {
    [super setEditing:editing animated:animated];
    [self.thumbnailView setEditing:editing];
    if (editing) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                                   target:self 
                                                                                   action:@selector(addNewItem:)];
        [self.navigationItem setLeftBarButtonItem:barButton animated:YES];
        [barButton release];
    } else {
        [self.navigationItem setLeftBarButtonItem:[self.navigationItem backBarButtonItem] animated:YES];
    }

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.thumbnailView.imageLoadingIcon = [UIImage imageNamed:@"LoadingIcon.png"];
    if (configEnabled_) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Config" 
                                                                      style:UIBarButtonItemStyleBordered 
                                                                     target:self 
                                                                     action:@selector(configureGridViewSelected)]; 
        self.navigationItem.rightBarButtonItem = barButton;
        [barButton release];
    }
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BGTile.png"]]]; 
}

- (void) addNewItem:(id) sender {
    if (nil == addItemViewController_) { 
        addItemViewController_ = [[AddItemViewController alloc] initWithNibName:@"AddItemViewController" 
                                                                                           bundle:nil];
    }
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemViewController_];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self 
                                                                 action:@selector(insertNewItem:)]; 
    addItemViewController_.navigationItem.rightBarButtonItem = barButton;
    [[self navigationController] presentModalViewController:navController animated:YES];    
    [barButton release];
    [navController release];
}

- (void) insertNewItem:(id) sender {
    NSString *itemName = addItemViewController_.itemName.text;
    NSString *itemIndex = addItemViewController_.itemIndex.text;
    NSInteger index = [itemIndex intValue];
    if ((index >= 0 && index < [demoItems_ count]) && ([dataService_ respondsToSelector:@selector(createFakeImageForUrl:)])) {
        FakeDataService *fakeDataService = (FakeDataService *) dataService_;
        
        // Create a fake DemoItem
        int randomId = (arc4random() % 501) + 500;
        NSNumber *demoItemId = [NSNumber numberWithInt:randomId];
        NSString *title = [NSString stringWithFormat:@"Title_%d", randomId];
        DemoItem *demoItem = [fakeDataService createDummyDemoItemForId:demoItemId title:title url:itemName];

        // Create a fake image for it
        NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"url", [self.thumbnailView imageAdorner], @"style", nil];
        UIImage *image = [fakeDataService createFakeImageForUrl:args];
        
        // Add to cache if it does not exist yet
        CVImage *cvImage = [[CVImageCache sharedCVImageCache] imageForKey:itemName];
        if (nil != cvImage && nil != image) {
            [cvImage setImage:image];
        }
        
        [demoItems_ insertObject:demoItem atIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForIndex:index forNumOfColumns:[self.thumbnailView numOfColumns]];
        [self.thumbnailView insertCellsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];        
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void) configureGridViewSelected {
    CVSettingsViewController *configViewController = [[[CVSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    ConfigOptions *configOptions = [[ConfigOptions alloc] init];
    configOptions.thumbnailWidth = self.thumbnailView.thumbnailCellSize.width;
    configOptions.thumbnailHeight = self.thumbnailView.thumbnailCellSize.height;    
    configOptions.numOfColumns = self.thumbnailView.numOfColumns;
    configOptions.fitNumberOfColumnsToFullWidth = self.thumbnailView.fitNumberOfColumnsToFullWidth;
    configOptions.borderWidth = self.thumbnailView.imageAdorner.borderStyle.width;
    configOptions.borderColor = self.thumbnailView.imageAdorner.borderStyle.color;
    if ([self.thumbnailView.imageAdorner.borderStyle respondsToSelector:@selector(radius)]) {
        configOptions.borderRoundedRadius = self.thumbnailView.imageAdorner.borderStyle.radius;
    } else {
        configOptions.borderRoundedRadius = 0.0;
    }
    configOptions.shadowBlur = self.thumbnailView.imageAdorner.shadowStyle.blur;
    configOptions.shadowOffsetWidth = self.thumbnailView.imageAdorner.shadowStyle.offset.width;
    configOptions.shadowOffsetHeight = self.thumbnailView.imageAdorner.shadowStyle.offset.height;    
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
        self.thumbnailView.imageLoadingIcon = [UIImage imageNamed:@"LoadingIcon.png"];
    }
    return [demoItems_ count];
}

- (CVThumbnailGridViewCell *)thumbnailView:(CVThumbnailGridView *)thumbnailView cellAtIndexPath:(NSIndexPath *)indexPath {
    CVThumbnailGridViewCell *cell = [thumbnailView dequeueReusableCellWithIdentifier:@"Thumbnails"];
    if (nil == cell) {
        cell = [[[CVThumbnailGridViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Thumbnails"] autorelease];
    }
    
    DemoItem *demoItem = (DemoItem *) [demoItems_ objectAtIndex:[indexPath indexForNumOfColumns:[self.thumbnailView numOfColumns]]];
    [cell setImageUrl:demoItem.imageUrl];
//    CVImage *demoImage = [[[CVImageCache sharedCVImageCache] imageForKey:demoItem.imageUrl] retain];
//    if (nil == demoImage) {
//        demoImage = [[CVImage alloc] initWithUrl:demoItem.imageUrl indexPath:indexPath];
//        [demoImage setDelegate:self];
//        [demoImage beginLoadingImage];
//        [[CVImageCache sharedCVImageCache] setImage:demoImage];
//    }
//    
//    [cell setCachedImage:demoImage];
//    [demoImage release];
    return cell;
}

- (void) thumbnailView:(CVThumbnailGridView *)thumbnailView loadImageForUrl:(NSString *) url forCellAtIndexPath:(NSIndexPath *) indexPath {
    [activeDownloads_ setObject:indexPath forKey:url];
    [dataService_ beginLoadImageForUrl:url]; 
}

- (void)thumbnailView:(CVThumbnailGridView *)thumbnailView moveCellAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSUInteger startingIndex = [fromIndexPath indexForNumOfColumns:[self.thumbnailView numOfColumns]];
    NSUInteger endingIndex = [toIndexPath indexForNumOfColumns:[self.thumbnailView numOfColumns]];
    
    DemoItem *demoItem = [[demoItems_ objectAtIndex:startingIndex] retain];
    [demoItems_ removeObjectAtIndex:startingIndex];
    [demoItems_ insertObject:demoItem atIndex:endingIndex];
    [demoItem release];
}

- (void) thumbnailView:(CVThumbnailGridView *)thumbnailView commitEditingStyle:(CVThumbnailGridViewCellEditingStyle) editingStyle forCellAtIndexPath:(NSIndexPath *) indexPath {
    switch (editingStyle) {
        case CVThumbnailGridViewCellEditingStyleInsert:
            // TODO: We don't have a built-in Insert Action like UITableView yet, so this is never called
            break;
        case CVThumbnailGridViewCellEditingStyleDelete:
            [thumbnailView deleteCellsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
            [demoItems_ removeObjectAtIndex:[indexPath indexForNumOfColumns:[thumbnailView numOfColumns]]];
            break;
        default:
            break;
    }

}

- (void) thumbnailView:(CVThumbnailGridView *) thumbnailView didSelectCellAtIndexPath:(NSIndexPath *) indexPath {
    NSUInteger index = indexPath.row * [thumbnailView numOfColumns] + indexPath.column;
}

#pragma mark DemoDataServiceDelegate methods
- (void) updatedWithItems:(NSArray *) items {
    [demoItems_ addObjectsFromArray:items];
    [self.thumbnailView reloadData];
}

- (void) updatedImage:(NSDictionary *) dict {
    NSString *url = [dict objectForKey:@"url"];
    UIImage *image = [dict objectForKey:@"image"];
    
    NSIndexPath *indexPath = [activeDownloads_ objectForKey:url];
    if (indexPath) {
        [self.thumbnailView image:image loadedForUrl:url forCellAtIndexPath:indexPath]; 
        [activeDownloads_ removeObjectForKey:url];
    }

}

#pragma mark GridConfigViewControllerDelegate methods
- (void) configurationUpdatedForGridConfigViewController:(CVSettingsViewController *) controller{
    ConfigOptions *configOptions = controller.settingsData;
        
    [self.thumbnailView setNumOfColumns:configOptions.numOfColumns];
    [self.thumbnailView setFitNumberOfColumnsToFullWidth:configOptions.fitNumberOfColumnsToFullWidth];
    [self.thumbnailView setThumbnailCellSize:CGSizeMake(configOptions.thumbnailWidth, configOptions.thumbnailHeight)];
    
    CVImageAdorner *imageAdorner = [self.thumbnailView imageAdorner];
    imageAdorner.borderStyle.width = configOptions.borderWidth;
    if ([imageAdorner.borderStyle respondsToSelector:@selector(setRadius:)]) {
        [imageAdorner.borderStyle setRadius:configOptions.borderRoundedRadius];
    }
    imageAdorner.borderStyle.color = configOptions.borderColor;
    
    imageAdorner.shadowStyle.offset = CGSizeMake(configOptions.shadowOffsetWidth, configOptions.shadowOffsetHeight);
    imageAdorner.shadowStyle.blur = configOptions.shadowBlur;

//    imageAdorner.targetImageSize = CGSizeMake(configOptions.thumbnailWidth, configOptions.thumbnailHeight);

    // Clear the image cache
    [[CVImageCache sharedCVImageCache] clearMemoryCache];
    
    [self.thumbnailView reloadData];
}

@end
