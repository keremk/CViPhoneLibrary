//
//  ThumbnailView.h
//  ColoringBook
//
//  Created by Kerem Karatal on 1/22/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVThumbnailViewCell.h"
#import "CVImageAdorner.h"

typedef enum {
   CVThumbnailViewCellEditingStyleNone,
   CVThumbnailViewCellEditingStyleDelete,
   CVThumbnailViewCellEditingStyleInsert
} CVThumbnailViewCellEditingStyle;

@protocol CVThumbnailViewDataSource, CVThumbnailViewDelegate;

/**
 * An instance of thumbnail view is a means for displaying and editing a list of thumbnail images.
 */
@interface CVThumbnailView : UIScrollView<CVThumbnailViewCellDelegate> {
@private
	id<CVThumbnailViewDataSource> dataSource_;
	id<CVThumbnailViewDelegate> delegate_;
	NSInteger numOfRows_; 
//    NSInteger numOfColumns_;
    NSInteger thumbnailCount_;
    
	CGFloat leftMargin_;
    CGFloat rightMargin_;
    CGFloat topMargin_; 
    CGFloat bottomMargin_;
    CGFloat rowSpacing_;
    CGFloat columnSpacing_;
    
	BOOL isAnimated_;

    BOOL animateSelection_;
    BOOL allowsSelection_;
    CGFloat selectionBorderWidth_;
    UIColor *selectionBorderColor_;
    
    CVImageAdorner *imageAdorner_;
    CGSize thumbnailCellSize_;
    
    NSIndexPath *indexPathForSelectedCell_;
    NSMutableSet *reusableThumbnails_;
    NSMutableDictionary *thumbnailsInUse_;
    NSInteger firstVisibleRow_;
    NSInteger lastVisibleRow_;

//    BOOL fitNumberOfColumnsToFullWidth_;
    
    BOOL editModeEnabled_;
    BOOL editing_;

    UIImage *imageLoadingIcon_; 
    UIImage *adornedImageLoadingIcon_;
    
    NSTimer *autoscrollTimer_;  // Timer used for auto-scrolling.
    CGFloat autoscrollDistance_;  // Distance to scroll the thumb view when auto-scroll timer fires.

    CGFloat deleteSignSideLength_;
    UIImage *deleteSignIcon_;
    UIColor *deleteSignForegroundColor_;
    UIColor *deleteSignBackgroundColor_;
    
    UIView *headerView_;
    UIView *footerView_;

    NSOperationQueue *operationQueue_;
}

/*!
    @abstract The object that acts as a data source of the receiving thumbnail view.
  
    @discussion The data source must adopt the CVThumbnailViewDataSource protocol. The data source is not retained.
 */
@property (nonatomic, assign) id <CVThumbnailViewDataSource> dataSource;
/*!
    @abstract The object that acts as the delegate of the receiving table view.
  
    @discussion The delegate must adopt to the CVThumbnailViewDelegate protocol. The delegate is not retained.
 */
@property (nonatomic, assign) id <CVThumbnailViewDelegate> delegate;
/*!
    @abstract   The total number of thumbnails in the thumbnail view.

    @discussion This is read-only. The data source (object that implements CVThumbnailDataSource protocol) is responsible from providing this value.
*/
@property (nonatomic, readonly) NSInteger thumbnailCount;
/*!
    @abstract   The total number of rows in the thumbnail view.

    @discussion This is read-only. The number is derived from the thumbnailCount and numOfColumns.
*/
@property (nonatomic, readonly) NSInteger numOfRows;
/*!
    @abstract   The number of columns per row in the thumbnail view.

    @discussion This is read-only. The number is derived from columnSpacing, thumbnailCellSize, leftMargin and rightMargin.
*/
@property (nonatomic, readonly) NSInteger numOfColumns;
/*!
    @abstract   Left margin used before the first thumbnail in a row.

    @discussion 
*/
@property (nonatomic) CGFloat leftMargin;
/*!
    @abstract   Right margin used before the first thumbnail in a row.

    @discussion 
*/
@property (nonatomic) CGFloat rightMargin;
/*!
    @abstract   Top margin used before the first thumbnail in the first row.

    @discussion 
*/
@property (nonatomic) CGFloat topMargin;
/*!
    @abstract   Bottom margin used after the last thumbnail in the last row.

    @discussion 
*/
@property (nonatomic) CGFloat bottomMargin;
/*!
    @abstract   Spacing in pixels between 2 rows.

    @discussion 
*/
@property (nonatomic) CGFloat rowSpacing;
/*!
    @abstract   Spacing in pixels between 2 columns.

    @discussion 
*/
@property (nonatomic) CGFloat columnSpacing;
/*!
    @abstract   Instance of the class used to adorn thumbnails in the thumbnail view.

    @discussion There can only be one instance of CVImageAdorner for all the thumbnails in the thumbnail view.
*/
@property (nonatomic, retain) CVImageAdorner *imageAdorner;
@property (nonatomic) BOOL animateSelection;
@property (nonatomic) BOOL editing;
@property (nonatomic, retain) UIImage *imageLoadingIcon;
@property (nonatomic, retain) UIColor *deleteSignForegroundColor;
@property (nonatomic, retain) UIColor *deleteSignBackgroundColor;
@property (nonatomic) CGFloat deleteSignSideLength;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic) CGSize thumbnailCellSize;
@property (nonatomic, readonly) NSIndexPath *indexPathForSelectedCell;
@property (nonatomic) BOOL allowsSelection;

/*!
    @abstract   Initializes and returns a thumbnail view object having the given frame

    @param      frame A rectangle specifying the initial location and size of the thumbnail view in its superview's coordinates.
    @result     Returns an initialized CVThumbnailView object or nil if the object could not be successfully initialized.
*/
- (id) initWithFrame:(CGRect)frame;

/*!
    @abstract   Clears up the cached images used by the CVThumbnailView
 
    @discussion In order to provide faster performance, CVThumbnailView caches images in its final display form, including the adornments. If the adornment styles change, the clients need to call this method to clear up the cache.
*/
- (void) resetCachedImages;
/*!
    @abstract   Instructs the thumbnail view to reload all thumbnails

    @discussion Thumbnail view will invalidate its cache and ask its data source for the data.
*/
- (void) reloadData;
/*!
    @abstract   Returns a re-usable thumbnail view cell object located by its identifier

    @discussion  
    @param      identifier A string identifying the cell object to be reused.
    @result     A CVThumbnailViewCell object with the associated identifier or nil if no such object exists in the reusable-cell queue.
*/
- (CVThumbnailViewCell *) dequeueReusableCellWithIdentifier:(NSString *) identifier;
- (CVThumbnailViewCell *) cellForIndexPath:(NSIndexPath *) indexPath;
- (void) deleteCellsAtIndexPaths:(NSArray *)indexPaths;
- (void) insertCellsAtIndexPaths:(NSArray *) indexPaths;
- (void) image:(UIImage *) image loadedForUrl:(NSString *) url forCellAtIndexPath:(NSIndexPath *) indexPath;
@end


@protocol CVThumbnailViewDataSource<NSObject>
@required
- (NSInteger) numberOfCellsForThumbnailView:(CVThumbnailView *)thumbnailView;
- (CVThumbnailViewCell *)thumbnailView:(CVThumbnailView *)thumbnailView cellAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void) thumbnailView:(CVThumbnailView *)thumbnailView loadImageForUrl:(NSString *) url forCellAtIndexPath:(NSIndexPath *) indexPath;
- (BOOL) thumbnailView:(CVThumbnailView *)thumbnailView canMoveCellAtIndexPath:(NSIndexPath *)indexPath;
- (void) thumbnailView:(CVThumbnailView *)thumbnailView moveCellAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (BOOL) thumbnailView:(CVThumbnailView *)thumbnailView canEditCellAtIndexPath:(NSIndexPath *)indexPath;
- (void) thumbnailView:(CVThumbnailView *)thumbnailView commitEditingStyle:(CVThumbnailViewCellEditingStyle) editingStyle forCellAtIndexPath:(NSIndexPath *) indexPath;
@end

@protocol CVThumbnailViewDelegate<NSObject>
@optional
- (void) thumbnailView:(CVThumbnailView *) thumbnailView didSelectCellAtIndexPath:(NSIndexPath *) indexPath;
@end


@interface NSIndexPath (ThumbnailView)
+ (NSIndexPath *) indexPathForRow:(NSUInteger)row column:(NSUInteger)column;
+ (NSIndexPath *) indexPathForIndex:(NSUInteger) index forNumOfColumns:(NSUInteger) numOfColumns;
@property (nonatomic, readonly) NSUInteger column;
- (NSUInteger) indexForNumOfColumns:(NSUInteger) numOfColumns;
@end
