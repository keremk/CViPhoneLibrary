//
//  ThumbnailView.h
//  ColoringBook
//
//  Created by Kerem Karatal on 1/22/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVThumbnailGridViewCell.h"
#import "CVStyle.h"

@protocol CVThumbnailGridViewDataSource, CVThumbnailGridViewDelegate;
//@class TestView;

@interface CVThumbnailGridView : UIScrollView<CVThumbnailGridViewCellDelegate> {
@private
	id<CVThumbnailGridViewDataSource> dataSource_;
	id<CVThumbnailGridViewDelegate> delegate_;
	NSUInteger numOfRows_, numOfColumns_, thumbnailCount_;
	CGFloat leftMargin_, rightMargin_, topMargin_, bottomMargin_, rowSpacing_;
	CGSize	thumbnailCellSize_;
	BOOL isAnimated_, animateSelection_;
    CVStyle *cellStyle_;
    CGRect moveToFrame_;
    
    NSMutableSet *reusableThumbnails_;
    NSMutableDictionary *thumbnailsInUse_;
    NSInteger firstVisibleRow_, lastVisibleRow_;
    BOOL fitNumberOfColumnsToFullWidth_;
    
    NSTimer *autoscrollTimer_;  // Timer used for auto-scrolling.
    CGFloat autoscrollDistance_;  // Distance to scroll the thumb view when auto-scroll timer fires.

}

@property (nonatomic, assign) id <CVThumbnailGridViewDataSource> dataSource;
@property (nonatomic, assign) id <CVThumbnailGridViewDelegate> thumbnailViewDelegate;
@property (nonatomic) NSUInteger thumbnailCount;
@property (nonatomic) NSUInteger numOfRows;
@property (nonatomic) NSUInteger numOfColumns;
@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGFloat rightMargin;
@property (nonatomic) CGFloat topMargin;
@property (nonatomic) CGFloat bottomMargin;
@property (nonatomic) CGFloat rowSpacing;
@property (nonatomic, retain) CVStyle *cellStyle;
@property (nonatomic) BOOL fitNumberOfColumnsToFullWidth;
@property (nonatomic) BOOL animateSelection;

- (id) initWithFrame:(CGRect)frame;
- (void) reloadData;
- (CVThumbnailGridViewCell *) dequeueReusableCellWithIdentifier:(NSString *) identifier;
- (CVThumbnailGridViewCell *) cellForIndexPath:(NSIndexPath *) indexPath;
@end


@protocol CVThumbnailGridViewDataSource<NSObject>
@required
- (NSInteger) numberOfCellsForThumbnailView:(CVThumbnailGridView *)thumbnailView;
- (CVThumbnailGridViewCell *)thumbnailView:(CVThumbnailGridView *)thumbnailView cellAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)thumbnailView:(CVThumbnailGridView *)thumbnailView moveCellAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
@end

@protocol CVThumbnailGridViewDelegate<NSObject>
@optional
- (void) thumbnailView:(CVThumbnailGridView *) thumbnailView didSelectCellAtIndexPath:(NSIndexPath *) indexPath;
@end


@interface NSIndexPath (ThumbnailView)
+ (NSIndexPath *)indexPathForRow:(NSUInteger)row column:(NSUInteger)column;
@property (nonatomic, readonly) NSUInteger column;
- (NSUInteger) indexForNumOfColumns:(NSUInteger) numOfColumns;
@end
