//
//  CVThumbnailView.h
//  CVLibrary
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

@class CVImageCache;

/**
 * An instance of thumbnail view is a means for displaying and editing a list of thumbnail images.
 */
@interface CVThumbnailView : UIScrollView<CVThumbnailViewCellDelegate> {
@private
	id<CVThumbnailViewDataSource> dataSource_;
	id<CVThumbnailViewDelegate> delegate_;
	NSInteger numOfRows_; 
    NSInteger thumbnailCount_;
    
    CVImageCache *imageCache_;
    
	CGFloat leftMargin_;
    CGFloat rightMargin_;
    CGFloat topMargin_; 
    CGFloat bottomMargin_;
    CGFloat rowSpacing_;
    CGFloat columnSpacing_;
    
	BOOL isAnimated_;

    BOOL animateSelection_;
    BOOL allowsSelection_;
    BOOL showDefaultSelectionEffect_;
    CGFloat selectionBorderWidth_;
    UIColor *selectionBorderColor_;
    
    CVImageAdorner *selectedImageAdorner_;
    CVImageAdorner *imageAdorner_;
    CGSize thumbnailCellSize_;
    
    NSIndexPath *indexPathForSelectedCell_;
    NSMutableSet *reusableThumbnails_;
    NSMutableDictionary *thumbnailsInUse_;
    NSInteger firstVisibleRow_;
    NSInteger lastVisibleRow_;
    
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
    
    CVTitleStyle *titleStyle_;
    BOOL showTitles_;
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
    @abstract   Indicates whether the selected thumbnail should be animated when selected

    @discussion The default is YES. The animation is a built-in one, if you need to provide your own animation for selection, this should be set to NO.
*/
@property (nonatomic) BOOL animateSelection;
/*!
    @abstract   A Boolean value that determines whether the receiver is in editing mode.

    @discussion The default value is NO. When the value of this property is YES, the thumbnail view will be in editing mode. The cells will have a delete sign to enable deleting of a specific cell.
*/
@property (nonatomic) BOOL editing;
/*!
    @abstract   A UIImage that is shown before the thumbnail in a cell is loaded.

    @discussion Once the thumbnail is loaded this cell is replaced by the actual thumbnail image.
*/
@property (nonatomic, retain) UIImage *imageLoadingIcon;
/*!
    @abstract   Foreground color of the default delete sign icon.

    @discussion This icon is only shown when the thumbnail view is in editing mode.
*/
@property (nonatomic, retain) UIColor *deleteSignForegroundColor;
/*!
    @abstract   Background color of the default delete sign icon.

    @discussion This icon is only shown when the thumbnail view is in editing mode.
*/
@property (nonatomic, retain) UIColor *deleteSignBackgroundColor;
/*!
    @abstract   Side length of the delete sign icon.

    @discussion The default delete sign icon is a square and this specifies the side length of that square.
*/
@property (nonatomic) CGFloat deleteSignSideLength;
/*!
    @abstract   The optional UIView that is shown in the header part of the thumbnail view.

    @discussion 
*/
@property (nonatomic, retain) UIView *headerView;
/*!
    @abstract   The optional UIView that is shown in the footer part of the thumbnail view.

    @discussion 
*/
@property (nonatomic, retain) UIView *footerView;
/*!
    @abstract   Size of thumbnail view cell.

    @discussion This specifies the total size of the cell. The actual image size that is shown is dependent on the editing mode (size required for delete sign) and the image adornments as specified by the CVImageAdorner
*/
@property (nonatomic) CGSize thumbnailCellSize;
/*!
    @abstract   Index path for the recently selected cell.

    @discussion This is dependent on whether selection is allowed by allowSelection property.
*/
@property (nonatomic, readonly) NSIndexPath *indexPathForSelectedCell;
@property (nonatomic) BOOL allowsSelection;
@property (nonatomic) BOOL showDefaultSelectionEffect;

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
/*!
    @abstract   Returns the thumbnail view cell object for a given index path.

    @discussion 
    @param      indexPath indexPath for the thumbnail view cell object to be returned.
    @result     A CVThumbnailViewCell object.
*/
- (CVThumbnailViewCell *) cellForIndexPath:(NSIndexPath *) indexPath;
/*!
    @abstract   <#(brief description)#>

    @discussion <#(comprehensive description)#>
    @param      indexPaths <#(description)#>
*/
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
- (UIImage *) thumbnailView:(CVThumbnailView *) thumbnailView selectedImageForUrl:(NSString *) url forCellAtIndexPath:(NSIndexPath *) indexPath;
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
