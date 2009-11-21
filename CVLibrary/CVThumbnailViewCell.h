//
//  CVThumbnailViewCell.h
//  CVLibrary
//
//  Created by Kerem Karatal on 1/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVImageAdorner.h"
#import "CVTitleStyle.h"

@protocol CVThumbnailViewCellDelegate;

/*!
    @abstract   The CVThumbnailViewCell class defines the attributes and behavior of the cells that appear in CVThumbnailView objects.

    @discussion 
*/
@interface CVThumbnailViewCell : UIView {
@private
	id<CVThumbnailViewCellDelegate> delegate_;
	NSIndexPath *indexPath_;
    CGPoint touchLocation_; // Location of touch in own coordinates (stays constant during dragging).
    BOOL dragging_; 
    BOOL editing_;
    BOOL selected_;
    CGRect home_;
    UIImage *thumbnailImage_;
    NSString *title_;
    CVImageAdorner *imageAdorner_;
    NSString *imageUrl_;
}

/*!
    @abstract   The container object that CVThumbnailViewCells communicates with. (Implemented by CVThumbnailView)

    @discussion This is automatically set by the CVThumbnailView. Should not be set by the clients.
*/
@property (nonatomic, assign) id<CVThumbnailViewCellDelegate> delegate;
/*!
    @abstract   Instance of NSIndexPath object that points to the index this cell corresponds to.

    @discussion 
*/
@property (nonatomic, retain) NSIndexPath *indexPath;
/*!
    @abstract   Indicates whether the cell is selected.

    @discussion 
*/
@property (nonatomic) BOOL selected;
/*!
    @abstract   The url of the image to be displayed in the cell.

    @discussion The clients should set this value to make sure that image can be loaded asynchronously, and also the image adornments are performed only for images that are loaded asynchronously by setting this property.
*/
@property (nonatomic, copy) NSString *imageUrl;
/*!
    @abstract   The title to be displayed in the lower bottom of the cell.

    @discussion 
*/
@property (nonatomic, copy) NSString *title;
/*!
    @abstract   The image to be displayed in the cell.

    @discussion If you set this directly the image adornments will NOT be applied as specified in the thumbnail view. 
*/
@property (nonatomic, assign) UIImage *image;

/*!
    @abstract   Initializes a thumbnail view cell with a frame and a reuse identifier and returns it to the caller.

    @discussion 
    @param      frame The frame rectangle of the cell. Because the table view automatically positions the cell and makes it the optimal size, you can pass in CGRectZero in most cases. 
    @param      identifier A string used to identify the cell object if it is to be reused for drawing multiple cells of a thumbnail view.
    @result     An initialized CVThumbnailViewCell object or nil if the object could not be created.
*/
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *) identifier;
@end

/*!
    @abstract   This protocol is implemented by the CVThumbnailView and defines the contract between the thumbnail view and its cell.

    @discussion 
*/
@protocol CVThumbnailViewCellDelegate <NSObject>
@required
/*!
    @abstract   Instance of the class used to adorn thumbnails in the thumbnail view.

    @discussion All thumbnails except for the selected thumbnail is adorned using the instance of this class.
*/
@property (nonatomic, retain) CVImageAdorner *imageAdorner;
/*!
    @abstract   Instance of the class used to adorn the selected thumbnail in the thumbnail view.

    @discussion Selected thumbnail is adorned using the instance of this class.
*/
@property (nonatomic, retain) CVImageAdorner *selectedImageAdorner;
/*!
    @abstract   The delete sign icon displayed when the cell is in edit mode.

    @discussion The thumbnail view provides a default icon if this is not set explicitly by the client.
*/
@property (nonatomic, retain) UIImage *deleteSignIcon;
/*!
    @abstract   Border width for the default selection adornment provided by the thumbnail view.

    @discussion The default selection adornment is a rounded rectangle around the whole cell. See showDefaultSelectionEffect to turn this on/off. Default is 3 pixels.
*/
@property (nonatomic) CGFloat selectionBorderWidth;
/*!
    @abstract   Border color for the default selection adornment provided by the thumbnail view.

    @discussion The default selection adornment is a rounded rectangle around the whole cell. See showDefaultSelectionEffect to turn this on/off. Default is red.
*/
@property (nonatomic, copy) UIColor *selectionBorderColor;
/*!
    @abstract   Indicates if the edit mode is on/off. 

    @discussion YES if the edit mode is enabled. Default is NO. If this is NO, the setting editing on thumbnail view has no effect.
*/
@property (nonatomic) BOOL editModeEnabled;
/*!
    @abstract   Indicates if the default selection adornment should be provided or not.

    @discussion Default is YES. If YES, then a simple rectangular border is shown around the selected cell if the allowsSelection is also YES.
*/
@property (nonatomic) BOOL showDefaultSelectionEffect;
/*!
    @abstract   Indicates whether the titles in the cell can be shown.

    @discussion Default is NO. If YES, then the titles are shown at the lower bottom of the cell. A certain spacing depending on the font size of the title is allocated.
*/
@property (nonatomic) BOOL showTitles;
/*!
    @abstract   Instance of CVTitleStyle class to be used for displaying titles in the cells.

    @discussion 
*/
@property (nonatomic, retain) CVTitleStyle *titleStyle;

@optional
/*!
    @abstract   Tells the thumbnail view that the delete sign for the cell is tapped.

    @discussion 
    @param      cell Instance of CVThumbnailViewCell for which the delete sign is tapped.
*/
- (void) deleteSignWasTapped:(CVThumbnailViewCell *) cell;
/*!
    @abstract   Tells the thumbnail view that the cell is tapped.

    @discussion 
    @param      cell Instance of CVThumbnailViewCell that is tapped.
*/
- (void) thumbnailViewCellWasTapped:(CVThumbnailViewCell *) cell;
/*!
    @abstract   Tells the thumbnail view that the cell is started to be tracked.

    @discussion 
    @param      cell Instance of CVThumbnailViewCell that is tapped.
*/
- (void) thumbnailViewCellStartedTracking:(CVThumbnailViewCell *) cell;
/*!
    @abstract   Tells the thumbnail view that the cell is moved.

    @discussion 
    @param      cell Instance of CVThumbnailViewCell that is tapped.
*/
- (void) thumbnailViewCellMoved:(CVThumbnailViewCell *) cell;
/*!
    @abstract   Tells the thumbnail view that the cell is stopped being tracked.

    @discussion 
    @param      cell Instance of CVThumbnailViewCell that is tapped.
*/
- (void) thumbnailViewCellStoppedTracking:(CVThumbnailViewCell *) cell;
@end

