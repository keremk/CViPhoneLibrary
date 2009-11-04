//
//  ThumbnailView.h
//  ColoringBook
//
//  Created by Kerem Karatal on 1/22/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVThumbnailGridViewCell.h"
#import "CVImageAdorner.h"

typedef enum {
   CVThumbnailGridViewCellEditingStyleNone,
   CVThumbnailGridViewCellEditingStyleDelete,
   CVThumbnailGridViewCellEditingStyleInsert
} CVThumbnailGridViewCellEditingStyle;

@protocol CVThumbnailGridViewDataSource, CVThumbnailGridViewDelegate;

@interface CVThumbnailGridView : UIScrollView<CVThumbnailGridViewCellDelegate> {
@private
	id<CVThumbnailGridViewDataSource> dataSource_;
	id<CVThumbnailGridViewDelegate> delegate_;
	NSInteger numOfRows_, numOfColumns_, thumbnailCount_;
	CGFloat leftMargin_, rightMargin_, topMargin_, bottomMargin_, rowSpacing_, columnSpacing_;
	BOOL isAnimated_, animateSelection_;
    CVImageAdorner *imageAdorner_;
    CGSize thumbnailCellSize_;
    
    NSIndexPath *indexPathForSelectedCell_;
    NSMutableSet *reusableThumbnails_;
    NSMutableDictionary *thumbnailsInUse_;
    NSInteger firstVisibleRow_, lastVisibleRow_;
    BOOL fitNumberOfColumnsToFullWidth_;

    BOOL allowsSelection_;
    BOOL editModeEnabled_;
    BOOL editing_;
    UIImage *imageLoadingIcon_, *adornedImageLoadingIcon_;
    
    NSTimer *autoscrollTimer_;  // Timer used for auto-scrolling.
    CGFloat autoscrollDistance_;  // Distance to scroll the thumb view when auto-scroll timer fires.

    CGFloat deleteSignSideLength_;
    UIImage *deleteSignIcon_;
    UIColor *deleteSignForegroundColor_;
    UIColor *deleteSignBackgroundColor_;
    
    UIView *headerView_, *footerView_;
    NSOperationQueue *operationQueue_;
    
    CGFloat selectionBorderWidth_;
    UIColor *selectionBorderColor_;
}

@property (nonatomic, assign) id <CVThumbnailGridViewDataSource> dataSource;
@property (nonatomic, assign) id <CVThumbnailGridViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger thumbnailCount;
@property (nonatomic, readonly) NSInteger numOfRows;
@property (nonatomic) NSInteger numOfColumns;
@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGFloat rightMargin;
@property (nonatomic) CGFloat topMargin;
@property (nonatomic) CGFloat bottomMargin;
@property (nonatomic) CGFloat rowSpacing;
@property (nonatomic) CGFloat columnSpacing;
@property (nonatomic, retain) CVImageAdorner *imageAdorner;
@property (nonatomic) BOOL fitNumberOfColumnsToFullWidth;
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

- (id) initWithFrame:(CGRect)frame;
- (void) resetCachedImages;
- (void) reloadData;
- (CVThumbnailGridViewCell *) dequeueReusableCellWithIdentifier:(NSString *) identifier;
- (CVThumbnailGridViewCell *) cellForIndexPath:(NSIndexPath *) indexPath;
- (void) deleteCellsAtIndexPaths:(NSArray *)indexPaths;
- (void) insertCellsAtIndexPaths:(NSArray *) indexPaths;

- (void) image:(UIImage *) image loadedForUrl:(NSString *) url forCellAtIndexPath:(NSIndexPath *) indexPath;
@end


@protocol CVThumbnailGridViewDataSource<NSObject>
@required
- (NSInteger) numberOfCellsForThumbnailView:(CVThumbnailGridView *)thumbnailView;
- (CVThumbnailGridViewCell *)thumbnailView:(CVThumbnailGridView *)thumbnailView cellAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void) thumbnailView:(CVThumbnailGridView *)thumbnailView loadImageForUrl:(NSString *) url forCellAtIndexPath:(NSIndexPath *) indexPath;
- (BOOL) thumbnailView:(CVThumbnailGridView *)thumbnailView canMoveCellAtIndexPath:(NSIndexPath *)indexPath;
- (void) thumbnailView:(CVThumbnailGridView *)thumbnailView moveCellAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (BOOL) thumbnailView:(CVThumbnailGridView *)thumbnailView canEditCellAtIndexPath:(NSIndexPath *)indexPath;
- (void) thumbnailView:(CVThumbnailGridView *)thumbnailView commitEditingStyle:(CVThumbnailGridViewCellEditingStyle) editingStyle forCellAtIndexPath:(NSIndexPath *) indexPath;
@end

@protocol CVThumbnailGridViewDelegate<NSObject>
@optional
- (void) thumbnailView:(CVThumbnailGridView *) thumbnailView didSelectCellAtIndexPath:(NSIndexPath *) indexPath;
@end


@interface NSIndexPath (ThumbnailView)
+ (NSIndexPath *) indexPathForRow:(NSUInteger)row column:(NSUInteger)column;
+ (NSIndexPath *) indexPathForIndex:(NSUInteger) index forNumOfColumns:(NSUInteger) numOfColumns;
@property (nonatomic, readonly) NSUInteger column;
- (NSUInteger) indexForNumOfColumns:(NSUInteger) numOfColumns;
@end
