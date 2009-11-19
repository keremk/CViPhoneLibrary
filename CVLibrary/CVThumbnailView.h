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
/*!
    @abstract   If allowsSelection is YES, then when a user clicks on a cell, the cell stays selected.

    @discussion 
*/
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
/*!
    @abstract   Returns the thumbnail view cell object for a given index path.

    @discussion This will return the cell even if the cell is not currently visible. If the cell is not in the visible cells list, then the view will ask its data source delegate for the current data it shows.
    @param      indexPath indexPath for the thumbnail view cell object to be returned.
    @result     A CVThumbnailViewCell object.
*/
- (CVThumbnailViewCell *) cellForIndexPath:(NSIndexPath *) indexPath;
/*!
    @abstract   Deletes all the cells specified by their index paths. 

    @discussion If the cells are visible, an animation happens to show deletion effect.
    @param      indexPaths array of NSIndexPath objects that indicate the cells to be deleted.
*/
- (void) deleteCellsAtIndexPaths:(NSArray *)indexPaths;
/*!
    @abstract   Inserts all the cells specified by their index paths.

    @discussion If the cells are visible, an animation happens to show insert effect. The new cell data is retrieved from the CVThumbnailViewDataSource.
    @param      indexPaths array of NSIndexPath objects that indicate the cells to be inserted.
*/
- (void) insertCellsAtIndexPaths:(NSArray *) indexPaths;
/*!
    @abstract   Notify thumbnail view when an image is loaded.

    @discussion This method is called by the data source object of the thumbnail view, when an image is loaded asynchronously, usually in response to the thumbnailView:loadImageForUrl:forCellAtIndexPath: call.
    @param      image The UIImage object that is loaded.
    @param      url Url of the image.
    @param      indexPath NSIndexPath object that describes the index path of the cell for the image.
    @see CVThumbnailViewDataSource
*/
- (void) image:(UIImage *) image loadedForUrl:(NSString *) url forCellAtIndexPath:(NSIndexPath *) indexPath;
@end


/*!
    @abstract   The CVThumbnailViewDataSource protocol is adopted by a object that mediates the application’s data model for a CVThumbnailView object. 
    @discussion The data source provides the thumbnail-view object with the information it needs to construct and modify a thumbnail view.

*/
@protocol CVThumbnailViewDataSource<NSObject>
@required
/*!
    @abstract   Asks the data source to return the number of cells in the thumbnail view.

    @discussion 
    @param      thumbnailView An object representing the thumbnail view requesting this information.
    @result     The number of cells in the thumbnail view. 
*/
- (NSInteger) numberOfCellsForThumbnailView:(CVThumbnailView *)thumbnailView;
/*!
    @abstract   Asks the data source for a cell to insert in a particular location of the thumbnail view. 

    @discussion 
    @param      thumbnailView A thumbnail view object requesting the cell.
    @param      indexPath An index path locating a row and column in thumbnailView.
    @result     A CVThumbnailViewCell object that the thumbnail view can use for the specified row and column. An assertion is raised if you return nil. 
*/
- (CVThumbnailViewCell *)thumbnailView:(CVThumbnailView *)thumbnailView cellAtIndexPath:(NSIndexPath *)indexPath;
@optional
/*!
    @abstract   Asks the data source to start loading an image for a given url.

    @discussion Data sources that implement this method, should load the image asynchronously and return from this method as fast as possible. In order for this method to be called, the imageUrl of the CVThumbnailViewCell must be set priorly at the thumbnailView:cellAtIndexPath: implementation.
    @param      thumbnailView A thumbnail view object requesting the cell.
    @param      url Url of the image being requested.
    @param      indexPath An index path locating a row and column in thumbnailView.
*/
- (void) thumbnailView:(CVThumbnailView *)thumbnailView loadImageForUrl:(NSString *) url forCellAtIndexPath:(NSIndexPath *) indexPath;
/*!
    @abstract   Asks the data source to synchronously return the thumbnail image of the selected cell.

    @discussion It is highly recommended that the image requested is already downloaded and cached locally at this point. The method implementation should return as fast as possible with an image. 
    @param      thumbnailView A thumbnail view object requesting the cell.
    @param      url Url of the image being requested.
    @param      indexPath An index path locating a row and column in thumbnailView.
    @result     A UIImage object without any adornments. The adornments are applied by the thumbnail view using the selectedImageAdorner object.
*/
- (UIImage *) thumbnailView:(CVThumbnailView *) thumbnailView selectedImageForUrl:(NSString *) url forCellAtIndexPath:(NSIndexPath *) indexPath;
/*!
    @abstract   Asks the permission from the delegate for the specified cell to be moved.

    @discussion 
    @param      thumbnailView A thumbnail view object informing the delegate about the new cell selection.
    @param      indexPath An index path locating a row and column in thumbnailView.
    @result     Return NO if you do not want the cell to be moved. Otherwise YES.
*/
- (BOOL) thumbnailView:(CVThumbnailView *)thumbnailView canMoveCellAtIndexPath:(NSIndexPath *)indexPath;
/*!
    @abstract   Tells the delegate that the specified cell is going to be moved to another position.

    @discussion 
    @param      thumbnailView A thumbnail view object informing the delegate about the new cell selection.
    @param      fromIndexPath An index path locating a row and column in thumbnailView that indicates the origin of location.
    @param      toIndexPath An index path locating a row and column in thumbnailView that indicates the new location.
*/
- (void) thumbnailView:(CVThumbnailView *)thumbnailView moveCellAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
/*!
    @abstract   Asks the permission from the delegate for the specified cell to be edited.

    @discussion The cell is about to be deleted or inserted.
    @param      thumbnailView A thumbnail view object informing the delegate about the new cell selection.
    @param      indexPath An index path locating a row and column in thumbnailView.
    @param      editingStyle The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath. Possible editing styles are CVThumbnailViewCellEditingStyleDelete or CVThumbnailViewCellEditingStyleInsert.
    @result     Return NO if you do not want the editing operation to be performed on the cell. Otherwise YES.
*/
- (BOOL) thumbnailView:(CVThumbnailView *)thumbnailView canEditCellAtIndexPath:(NSIndexPath *)indexPath usingEditingStyle:(CVThumbnailViewCellEditingStyle) editingStyle;
/*!
    @abstract   Asks the data source to commit the insertion or deletion of a specified cell in the receiver.

    @discussion 
    @param      thumbnailView A thumbnail view object informing the delegate about the new cell selection.
    @param      editingStyle The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath. Possible editing styles are CVThumbnailViewCellEditingStyleDelete or CVThumbnailViewCellEditingStyleInsert.
    @param      indexPath An index path locating a row and column in thumbnailView.
*/
- (void) thumbnailView:(CVThumbnailView *)thumbnailView commitEditingStyle:(CVThumbnailViewCellEditingStyle) editingStyle forCellAtIndexPath:(NSIndexPath *) indexPath;
@end

/*!
    @abstract   The delegate of a CVThumbnailView object must adopt the CVThumbnailViewDelegate protocol.

    @discussion Optional methods of the protocol allow the delegate to manage selections.
*/
@protocol CVThumbnailViewDelegate<NSObject>
@optional
/*!
    @abstract   Tells the delegate that the specified cell is now selected.

    @discussion 
    @param      thumbnailView A thumbnail view object informing the delegate about the new cell selection.
    @param      indexPath An index path locating a row and column in thumbnailView.
*/
- (void) thumbnailView:(CVThumbnailView *) thumbnailView didSelectCellAtIndexPath:(NSIndexPath *) indexPath;
@end


/*!
    @abstract   This category on NSIndexPath introduces columns instead of the sections.

    @discussion 
*/
@interface NSIndexPath (ThumbnailView)
/*!
    @abstract   Returns an instance of NSIndexPath object for a given row and column.

    @discussion Do not use the same NSIndexPath for UITableView objects. UITableView expects a section instead of a column.
    @param      row Row of the index path.
    @param      column Column of the index path, replaces the section. 
    @result     Instance of NSIndexPath object.
*/
+ (NSIndexPath *) indexPathForRow:(NSUInteger)row column:(NSUInteger)column;
/*!
    @abstract   Calculates and returns an instance of NSIndexPath object for given absolute index number and numOfColumns.

    @discussion 
    @param      index Index is the value calculated by rows * numOfcolumns + column 
    @param      numOfColumns The number of columns used to calculate the index.
    @result     Instance of the NSIndexPath object.
*/
+ (NSIndexPath *) indexPathForIndex:(NSUInteger) index forNumOfColumns:(NSUInteger) numOfColumns;
/*!
    @abstract   Column value of the NSIndexPath

    @discussion This value is overloaded by the same value of section. It is mainly a renaming of section to column so that it makes more sense within the context of the thumbnail view.
*/
@property (nonatomic, readonly) NSUInteger column;
/*!
    @abstract   Returns the index value for given numOfColumns.

    @discussion 
    @param      numOfColumns The number of columns used to calculate the index.
    @result     Returns the index as the value calculated by rows * numOfcolumns + column 
*/
- (NSUInteger) indexForNumOfColumns:(NSUInteger) numOfColumns;
@end
