//
//  FlickrDemoViewController.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 8/25/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "FlickrDemoViewController.h"
#import "DemoItem.h"
#import "LoadMoreControl.h"
#import "TestView.h"

@interface FlickrDemoViewController()
- (void) loadFlickrItems;
- (IBAction) loadMoreRequested:(id) sender;
@end

@implementation FlickrDemoViewController
@synthesize dataService = dataService_;

- (void)dealloc {
    [flickrItems_ release];
    [dataService_ setDelegate:nil];
    [dataService_ release];
    [activeDownloads_ release];
    [super dealloc];
}

- (void) loadFlickrItems {
    // Set up the demo items
    if (nil == flickrItems_) {
        flickrItems_ = [[NSMutableArray alloc] init];
        [dataService_ setDelegate:self];
        [dataService_ beginLoadDemoData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        flickrItems_ = nil;
        currentPage_ = 1;
        activeDownloads_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    LoadMoreControl *loadMoreControl = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
    [self.thumbnailView setFooterView:loadMoreControl];
    [self.thumbnailView setNeedsLayout];
    [loadMoreControl addTarget:self action:@selector(loadMoreRequested:) forControlEvents:UIControlEventTouchDown]; 
    [loadMoreControl release];
    
}

- (IBAction) loadMoreRequested:(id) sender {
    currentPage_++;
    [dataService_ beginLoadDemoDataForPage:currentPage_];
    LoadMoreControl *loadMoreControl = (LoadMoreControl *) sender;
    [loadMoreControl enableLoadMoreButton];
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
    if (nil == flickrItems_) {
        [self loadFlickrItems];
        self.thumbnailView.imageLoadingIcon = [UIImage imageNamed:@"LoadingIcon.png"];
    }
    return [flickrItems_ count];
}

- (CVThumbnailGridViewCell *)thumbnailView:(CVThumbnailGridView *)thumbnailView cellAtIndexPath:(NSIndexPath *)indexPath {
    CVThumbnailGridViewCell *cell = [thumbnailView dequeueReusableCellWithIdentifier:@"Thumbnails"];
    if (nil == cell) {
        cell = [[[CVThumbnailGridViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Thumbnails"] autorelease];
    }
    
    DemoItem *demoItem = (DemoItem *) [flickrItems_ objectAtIndex:[indexPath indexForNumOfColumns:[self.thumbnailView numOfColumns]]];
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


#pragma mark DemoDataServiceDelegate methods
- (void) updatedWithItems:(NSArray *) items {
    [flickrItems_ addObjectsFromArray:items];
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

//#pragma mark CVImageLoadingService methods
//- (void) beginLoadImageForUrl:(NSString *) url {
//    [dataService_ beginLoadImageForUrl:url usingStyle:[self.thumbnailView imageAdorner]];
//}


@end
