//
//  ThumbnailView.m
//  ColoringBook
//
//  Created by Kerem Karatal on 1/22/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#include "CGUtils.h"

#import "CVThumbnailGridView.h"
#import "UIImage+Adornments.h"

//@interface TestView: UIView {
//    CGPoint touchLocation_;
//}
//
//@end
//
//@implementation TestView
//
//- (id) initWithFrame:(CGRect) frame {
//    self = [super initWithFrame:frame];
//    if (self != nil) {
//        NSLog(@"TestView init");
//    }
//    return self;
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    // store the location of the starting touch so we can decide when we've moved far enough to drag
//    touchLocation_ = [[touches anyObject] locationInView:self];
//    NSLog(@"TestView %f, %f", touchLocation_.x, touchLocation_.y);
//}
//
//@end

@interface CVThumbnailGridView()
- (void) commonInit;
- (void) animateThumbnailViewCell:(CVThumbnailGridViewCell *) cell;
- (CGSize) recalculateThumbnailCellSize;
- (NSUInteger) calculateNumOfColumns;
@end 

@implementation CVThumbnailGridView
@synthesize dataSource = dataSource_;
@synthesize thumbnailViewDelegate = delegate_;
@synthesize numOfRows = numOfRows_;
@synthesize numOfColumns = numOfColumns_;
@synthesize leftMargin = leftMargin_;
@synthesize rightMargin = rightMargin_;
@synthesize topMargin = topMargin_;
@synthesize bottomMargin = bottomMargin_;
@synthesize rowSpacing = rowSpacing_;
@synthesize thumbnailCount = thumbnailCount_;
@synthesize cellStyle = cellStyle_;
@synthesize fitNumberOfColumnsToFullWidth = fitNumberOfColumnsToFullWidth_;

- (void)dealloc {
    [cellStyle_ release];
    [reusableThumbnails_ release];
//    [thumbnailContainerView_ release];
    [thumbnailsInUse_ release];
    [super dealloc];
}

#define LEFT_MARGIN_DEFAULT 5.0
#define RIGHT_MARGIN_DEFAULT 5.0
#define TOP_MARGIN_DEFAULT 0.0 // TODO: Top margin is always half of ROW_SPACING 
#define ROW_SPACING_DEFAULT 10.0
#define COLUMN_COUNT_DEFAULT 1

- (id) initWithCoder:(NSCoder *) coder {
	if (self = [super initWithCoder:coder]) {
		[self commonInit];
	}
	return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self commonInit];
    }
    return self;
}

- (void) commonInit {
    leftMargin_ = LEFT_MARGIN_DEFAULT;
    rightMargin_ = RIGHT_MARGIN_DEFAULT;
    topMargin_ = TOP_MARGIN_DEFAULT;
    rowSpacing_ = ROW_SPACING_DEFAULT;
    numOfColumns_ = COLUMN_COUNT_DEFAULT;
    isAnimated_ = NO;
    fitNumberOfColumnsToFullWidth_ = NO;
    
    cellStyle_ = [[CVStyle alloc] init];     
    thumbnailsInUse_ = [[NSMutableDictionary alloc] init];
    reusableThumbnails_ = [[NSMutableSet alloc] init];
    firstVisibleRow_ = NSIntegerMax;
    lastVisibleRow_ = NSIntegerMin;
//    thumbnailContainerView_ = [[TestView alloc] initWithFrame:CGRectZero];
    self.backgroundColor = [UIColor clearColor];
//    thumbnailContainerView_.backgroundColor = [UIColor clearColor];
//    [self addSubview:thumbnailContainerView_];
    
//    [self setUserInteractionEnabled:YES];
    [self setDelaysContentTouches:YES];
    [self setCanCancelContentTouches:NO];
}

- (void) setCellStyle:(CVStyle *) style {
    if (cellStyle_ != style) {
        [cellStyle_ release];
        cellStyle_ = [style retain];
        thumbnailCellSize_ = [self recalculateThumbnailCellSize];
        [self setNeedsLayout];
    }
}

- (void) setNumOfColumns:(NSUInteger) numOfColumns {
    
    // If numOfColumns == 0, set it to 1, 0 is not expected.
    numOfColumns_ = (numOfColumns == 0) ? 1 : numOfColumns;
}

- (void) setLeftMargin:(CGFloat) leftMargin {
    leftMargin_ = leftMargin;
    if (fitNumberOfColumnsToFullWidth_) {
        numOfColumns_ = [self calculateNumOfColumns];
    }
}

- (void) setRightMargin:(CGFloat) rightMargin {
    rightMargin_ = rightMargin;
    if (fitNumberOfColumnsToFullWidth_) {
        numOfColumns_ = [self calculateNumOfColumns];
    }
}

- (NSUInteger) calculateNumOfColumns {
    NSUInteger numOfColumns;
    CGRect visibleBounds = [self bounds];
    numOfColumns = floorf((visibleBounds.size.width - leftMargin_ - rightMargin_)/thumbnailCellSize_.width);
    numOfColumns = (numOfColumns == 0) ? 1 : numOfColumns;
    return numOfColumns;
}

- (CGSize) recalculateThumbnailCellSize {
    CGSize cellSize = [UIImage adornedImageSizeForImageSize:cellStyle_.imageSize usingStyle:cellStyle_];
    
    return cellSize;
}

- (void) reloadData {
    thumbnailCount_ = [dataSource_ numberOfCellsForThumbnailView:self];
    
    for (CVThumbnailGridViewCell *thumbnailViewCell in [self subviews]) {
        if ([thumbnailViewCell isKindOfClass:[CVThumbnailGridViewCell class]]) {
            [reusableThumbnails_ addObject:thumbnailViewCell];
            [thumbnailViewCell removeFromSuperview];
        }
    }
    
    // no rows or columns are now visible; note this by making the firsts very high and the lasts very low
    firstVisibleRow_ = NSIntegerMax;
    lastVisibleRow_  = NSIntegerMin;

    [self setNeedsLayout];
}


- (CVThumbnailGridViewCell *) dequeueReusableCellWithIdentifier:(NSString *) identifier {
    CVThumbnailGridViewCell *cell = [reusableThumbnails_ anyObject];
    
    if (cell) {
        [[cell retain] autorelease];
        [reusableThumbnails_ removeObject:cell];
    }
    return cell;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    thumbnailCellSize_ = [self recalculateThumbnailCellSize];
    CGRect visibleBounds = [self bounds];

    if (fitNumberOfColumnsToFullWidth_) {
        // Calculate number of columns
        numOfColumns_ = [self calculateNumOfColumns];
    }
    numOfRows_ = ceil( (CGFloat) thumbnailCount_ / numOfColumns_);

    if (isAnimated_ || numOfRows_ == 0)
        return;

    CGFloat height = topMargin_ + (thumbnailCellSize_.height + rowSpacing_) * numOfRows_;
    CGSize scrollViewSize = CGSizeMake(visibleBounds.size.width, height);
    [self setContentSize:scrollViewSize];

    // Below algorithm is inspired/taken from Tiling Sample code in Apple iPhone SDK
    
    for (CVThumbnailGridViewCell *thumbnail in [self subviews]) {
        if ([thumbnail isKindOfClass:[CVThumbnailGridViewCell class]]) { 
            CGRect thumbnailFrame = [self convertRect:[thumbnail frame] toView:self];

            // Take into account the rowSpacing_
            thumbnailFrame = CGRectMake(thumbnailFrame.origin.x, thumbnailFrame.origin.y, 
                                        thumbnailFrame.size.width, thumbnailFrame.size.height + rowSpacing_);
            
            if (!CGRectIntersectsRect(thumbnailFrame, visibleBounds)) {
                [reusableThumbnails_ addObject:thumbnail];
                [thumbnail removeFromSuperview];
                [thumbnailsInUse_ removeObjectForKey:[thumbnail indexPath]];
    //            NSLog(@"Thumbnail %d, %d removed", thumbnail.indexPath.row, thumbnail.indexPath.column);
            }
        }
    }
    
    CGFloat rowHeight = rowSpacing_ + thumbnailCellSize_.height;
    NSInteger startingRowOnPage = MAX(0, floorf(self.contentOffset.y / rowHeight));
    NSInteger endingRowOnPage = MIN(numOfRows_ - 1, floorf(CGRectGetMaxY(visibleBounds) / rowHeight));
    CGFloat columnSpacing = 0;
    if (numOfColumns_ > 1) {
        columnSpacing = MAX(0, (visibleBounds.size.width - (thumbnailCellSize_.width * numOfColumns_) - leftMargin_ - rightMargin_) / (numOfColumns_ - 1));
    }
    
    for (NSInteger row = startingRowOnPage; row <= endingRowOnPage; row++) {
        for (NSInteger column = 0; column < numOfColumns_; column++) {
            BOOL thumbnailMissing = (firstVisibleRow_ > row) || (lastVisibleRow_ < row);
            if (thumbnailMissing) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row column:column];
                NSInteger currentCellNo = row * numOfColumns_ + column;
                if (currentCellNo >= thumbnailCount_)
                    break;
                CVThumbnailGridViewCell *thumbnailViewCell = [dataSource_ thumbnailView:self cellAtIndexPath:indexPath];
                if (nil != thumbnailViewCell) {
                    CGFloat xPos = leftMargin_ + (thumbnailCellSize_.width + columnSpacing) * column;
                    CGFloat yPos = (thumbnailCellSize_.height + rowSpacing_) * row;
                    
                    [thumbnailViewCell setFrame:CGRectMake(xPos, yPos, thumbnailCellSize_.width, thumbnailCellSize_.height)];                
                    [thumbnailViewCell setUserInteractionEnabled:YES];
                    [thumbnailViewCell setDelegate:self];
                    [thumbnailViewCell setIndexPath:indexPath];
                    
//                    NSLog(@"Thumbnail %d, %d added", thumbnailViewCell.indexPath.row, thumbnailViewCell.indexPath.column);
                    [self addSubview:thumbnailViewCell];
                    [thumbnailsInUse_ setObject:thumbnailViewCell forKey:indexPath];
                } else {
                    NSLog(@"Thumbnail nil");
                }

            }
        }
    }

    firstVisibleRow_ = startingRowOnPage;
    lastVisibleRow_ = endingRowOnPage;
}

- (CVThumbnailGridViewCell *) cellForIndexPath:(NSIndexPath *) indexPath {
    CVThumbnailGridViewCell *cell = [thumbnailsInUse_ objectForKey:indexPath];
    
    return cell;
}

//- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
//    CGPoint touchLocation = [[touches anyObject] locationInView:self];
//    NSLog(@"ScrollView : %f, %f", touchLocation.x, touchLocation.y);
//    
//    return YES;
//}
//
//- (BOOL)touchesShouldCancelInContentView:(UIView*)view {
//  
//    return NO;
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    // store the location of the starting touch so we can decide when we've moved far enough to drag
//    CGPoint touchLocation = [[touches anyObject] locationInView:self];
//    NSLog(@"TouchesBegan %f, %f", touchLocation.x, touchLocation.y);
//    UIResponder *responder = self.nextResponder;
//    [responder touchesBegan:touches withEvent:event];
//}

#pragma mark CVThumbnailGridViewCellDelegate methods 

- (void)thumbnailGridViewCellWasTapped:(CVThumbnailGridViewCell *) cell {
    [self animateThumbnailViewCell:cell];
}

- (void)thumbnailGridViewCellStartedTracking:(CVThumbnailGridViewCell *) cell {
    
}

- (void)thumbnailGridViewCellMoved:(CVThumbnailGridViewCell *) cell {
    
}

- (void)thumbnailGridViewCellStoppedTracking:(CVThumbnailGridViewCell *) cell {
    
}

#define SELECT_ANIMATION_DURATION 0.15
- (void) animateThumbnailViewCell:(CVThumbnailGridViewCell *) cell {
	//NSLog(@"*Animation 1 - x=%f, y=%f, width=%f, height=%f ", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
	isAnimated_ = YES;
	[UIView beginAnimations:@"SelectThumbnail" context:cell];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:SELECT_ANIMATION_DURATION];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
	cell.transform = transform;
	[UIView commitAnimations];	
}

- (void) animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	CVThumbnailGridViewCell *cell = (CVThumbnailGridViewCell *) context;
	if (animationID == @"SelectThumbnail") {
		//NSLog(@"**Animation 2 - x=%f, y=%f, width=%f, height=%f ", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
		[UIView beginAnimations:@"DeSelectThumbnail" context:cell];
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:SELECT_ANIMATION_DURATION];
		CGAffineTransform transform = CGAffineTransformIdentity;
		cell.transform = transform;
		[UIView commitAnimations];			
	} else {
		//NSLog(@"***Animation 3 - x=%f, y=%f, width=%f, height=%f ", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
		[delegate_ thumbnailView:self didSelectCellAtIndexPath:cell.indexPath];		 
		isAnimated_ = NO;
	}	
}
@end

@implementation NSIndexPath(ThumbnailView) 

+ (NSIndexPath *)indexPathForRow:(NSUInteger)row column:(NSUInteger)column {
	return [NSIndexPath indexPathForRow:row inSection:column];
}

- (NSUInteger) column {
	return self.section;
}
@end
