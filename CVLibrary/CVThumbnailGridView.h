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
	BOOL isAnimated_;
    CVStyle *cellStyle_;
    
//    TestView *thumbnailContainerView_;
    NSMutableSet *reusableThumbnails_;
    NSMutableDictionary *thumbnailsInUse_;
    NSInteger firstVisibleRow_, lastVisibleRow_;
    BOOL fitNumberOfColumnsToFullWidth_;
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

- (id) initWithFrame:(CGRect)frame;
- (void) reloadData;
- (CVThumbnailGridViewCell *) dequeueReusableCellWithIdentifier:(NSString *) identifier;
- (CVThumbnailGridViewCell *) cellForIndexPath:(NSIndexPath *) indexPath;
@end


@protocol CVThumbnailGridViewDataSource
@optional
- (NSInteger) numberOfCellsForThumbnailView:(CVThumbnailGridView *)thumbnailView;
- (CVThumbnailGridViewCell *)thumbnailView:(CVThumbnailGridView *)thumbnailView cellAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol CVThumbnailGridViewDelegate
@optional
- (void) thumbnailView:(CVThumbnailGridView *) thumbnailView didSelectCellAtIndexPath:(NSIndexPath *) indexPath;
@end


@interface NSIndexPath (ThumbnailView)
+ (NSIndexPath *)indexPathForRow:(NSUInteger)row column:(NSUInteger)column;
@property (nonatomic, readonly) NSUInteger column;
@end
