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

@interface CVThumbnailGridView()
- (void) commonInit;
- (void) animateThumbnailViewCell:(CVThumbnailGridViewCell *) cell;
- (CGSize) recalculateThumbnailCellSize;
- (NSUInteger) calculateNumOfColumns;
- (CGRect) rectForColumn:(NSUInteger) column row:(NSUInteger) row;
- (CGFloat) columnSpacing;
- (CVThumbnailGridViewCell *) createCellFromDataSourceForIndexPath:(NSIndexPath *) indexPath;
- (NSString *) keyFromIndexPath:(NSIndexPath *) indexPath;
- (void) cleanupNonVisibleCells;
- (void) maybeAutoscrollForThumb:(CVThumbnailGridViewCell *) cell;
- (CGFloat) autoscrollDistanceForProximityToEdge:(CGFloat)proximity;
- (void) legalizeAutoscrollDistance;
- (void) autoscrollTimerFired:(NSTimer*)timer;
@end 

@implementation CVThumbnailGridView
@synthesize dataSource = dataSource_;
@synthesize delegate = delegate_;
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
@synthesize animateSelection = animateSelection_;
@synthesize editing = editing_;

- (void)dealloc {
    [cellStyle_ release];
    [reusableThumbnails_ release];
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
    animateSelection_ = YES;
    fitNumberOfColumnsToFullWidth_ = NO;
    editing_ = NO;
    
    cellStyle_ = [[CVStyle alloc] init];     
    thumbnailsInUse_ = [[NSMutableDictionary alloc] init];
    reusableThumbnails_ = [[NSMutableSet alloc] init];
    firstVisibleRow_ = NSIntegerMax;
    lastVisibleRow_ = NSIntegerMin;
    self.backgroundColor = [UIColor clearColor];
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
//    CGSize cellSize = [UIImage adornedImageSizeForImageSize:cellStyle_.imageSize usingStyle:cellStyle_];
    CGSize cellSize = [cellStyle_ sizeAfterStylingImage];
    
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

    [self cleanupNonVisibleCells];
    
    CGFloat rowHeight = rowSpacing_ + thumbnailCellSize_.height;
    NSInteger startingRowOnPage = MAX(0, floorf(self.contentOffset.y / rowHeight));
    NSInteger endingRowOnPage = MIN(numOfRows_ - 1, floorf(CGRectGetMaxY(visibleBounds) / rowHeight));
    
    for (NSInteger row = startingRowOnPage; row <= endingRowOnPage; row++) {
        for (NSInteger column = 0; column < numOfColumns_; column++) {
            BOOL thumbnailMissing = (firstVisibleRow_ > row) || (lastVisibleRow_ < row);
            if (thumbnailMissing) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row column:column];
                NSInteger currentCellNo = row * numOfColumns_ + column;
                if (currentCellNo >= thumbnailCount_)
                    break;
                [self createCellFromDataSourceForIndexPath:indexPath];
            }
        }
    }

    firstVisibleRow_ = startingRowOnPage;
    lastVisibleRow_ = endingRowOnPage;
}

- (CGRect) rectForColumn:(NSUInteger) column row:(NSUInteger) row {
    CGFloat xPos = leftMargin_ + (thumbnailCellSize_.width + [self columnSpacing]) * column;
    CGFloat yPos = (thumbnailCellSize_.height + rowSpacing_) * row;
    CGRect rect = CGRectMake(xPos, yPos, thumbnailCellSize_.width, thumbnailCellSize_.height);

    return rect;
}

- (CVThumbnailGridViewCell *) cellForIndexPath:(NSIndexPath *) indexPath {
    CVThumbnailGridViewCell *cell = [thumbnailsInUse_ objectForKey:[self keyFromIndexPath:indexPath]];
    if (nil == cell) {
        [self cleanupNonVisibleCells];
        cell = [self createCellFromDataSourceForIndexPath:indexPath];
    }
    return cell;
}

- (CVThumbnailGridViewCell *) createCellFromDataSourceForIndexPath:(NSIndexPath *) indexPath {
    CVThumbnailGridViewCell *cell = [dataSource_ thumbnailView:self cellAtIndexPath:indexPath];
    if (nil != cell) {
        CGRect frame = [self rectForColumn:[indexPath column] row:[indexPath row]];       
        [cell setFrame:frame];
        [cell setHome:frame];
        [cell setUserInteractionEnabled:YES];
        [cell setDelegate:self];
        [cell setIndexPath:indexPath];
        [self addSubview:cell];
        [thumbnailsInUse_ setObject:cell forKey:[self keyFromIndexPath:indexPath]];
    } else {
        NSLog(@"Datasource returned nil thumbnail cell");
    }        
    
    return cell;
}

- (void) cleanupNonVisibleCells {
    for (CVThumbnailGridViewCell *thumbnail in [self subviews]) {
        if ([thumbnail isKindOfClass:[CVThumbnailGridViewCell class]]) { 
            CGRect thumbnailFrame = [self convertRect:[thumbnail frame] toView:self];

            // Take into account the rowSpacing_
            thumbnailFrame = CGRectMake(thumbnailFrame.origin.x, thumbnailFrame.origin.y, 
                                        thumbnailFrame.size.width, thumbnailFrame.size.height + rowSpacing_);
            
            if (!CGRectIntersectsRect(thumbnailFrame, [self bounds])) {
                [reusableThumbnails_ addObject:thumbnail];
                [thumbnail removeFromSuperview];
                [thumbnailsInUse_ removeObjectForKey:[self keyFromIndexPath:[thumbnail indexPath]]];
            }
        }
    }
}

- (CGFloat) columnSpacing {
    CGFloat columnSpacing = 0;
    if (numOfColumns_ > 1) {
        columnSpacing = MAX(0, (self.bounds.size.width - (thumbnailCellSize_.width * numOfColumns_) - leftMargin_ - rightMargin_) / (numOfColumns_ - 1));
    }
    
    return columnSpacing;
}

- (NSString *) keyFromIndexPath:(NSIndexPath *) indexPath {
    NSString *key = [NSString stringWithFormat:@"%d, %d", indexPath.row, indexPath.column];
    return key;
}

#pragma mark CVThumbnailGridViewCellDelegate methods 

- (BOOL) isInEditMode {
    return editing_;
}

- (void)thumbnailGridViewCellWasTapped:(CVThumbnailGridViewCell *) cell {
    if (animateSelection_) {
        [self animateThumbnailViewCell:cell];
    } else {
        if ([delegate_ respondsToSelector:@selector(thumbnailView:didSelectCellAtIndexPath:)]) {
            [delegate_ thumbnailView:self didSelectCellAtIndexPath:[cell indexPath]];
        }
    }
}

- (void)thumbnailGridViewCellStartedTracking:(CVThumbnailGridViewCell *) cell {
    [self bringSubviewToFront:cell];
}

- (void)thumbnailGridViewCellMoved:(CVThumbnailGridViewCell *) draggingThumb {
    [self maybeAutoscrollForThumb:draggingThumb];
    
    // Estimate cell number we are moving to based on location
    NSInteger draggingThumbMoveToColumn = floor((CGRectGetMidX([draggingThumb frame]) - leftMargin_) / (thumbnailCellSize_.width + [self columnSpacing]));
    NSInteger draggingThumbMoveToRow = floor(CGRectGetMidY([draggingThumb frame]) / (thumbnailCellSize_.height + rowSpacing_));
    NSInteger moveToIndex = draggingThumbMoveToRow * numOfColumns_ + draggingThumbMoveToColumn;
    
    if (draggingThumbMoveToColumn < 0 || draggingThumbMoveToColumn >= numOfColumns_) return;
    if (moveToIndex < 0 || moveToIndex >= thumbnailCount_) return;
    
    // Calculate starting cell number
    NSUInteger startingColumn = floor(([draggingThumb home].origin.x - leftMargin_) / (thumbnailCellSize_.width + [self columnSpacing]));
    NSUInteger startingRow = floor([draggingThumb home].origin.y / (thumbnailCellSize_.height + rowSpacing_));
    NSUInteger startingIndex = startingRow * numOfColumns_ + startingColumn;

//    NSLog(@"Start %d, %d - %d  -- Move to: %d, %d - %d", startingRow, startingColumn, startingIndex, draggingThumbMoveToRow, draggingThumbMoveToColumn, moveToIndex);

    if (moveToIndex == startingIndex) return;
    
    BOOL moveToHigherIndex = moveToIndex > startingIndex;
    
    NSInteger i = startingIndex;
    NSInteger endIndex = moveToIndex;
    NSInteger increment = moveToHigherIndex ? 1 : -1;

//    NSLog(@"StartIndex = %d, EndIndex = %d, increment = %d", i, endIndex, increment);
    while (i != endIndex + increment) {
        NSInteger row = floor(i / numOfColumns_);
        NSInteger column = i - row * numOfColumns_;
//        NSLog(@"NewRow - %d, NewColumn - %d For index = %d", row, column, i);
        CVThumbnailGridViewCell *cell = [self cellForIndexPath:[NSIndexPath indexPathForRow:row column:column]];
        if (nil == cell) {
            NSLog(@"Cell is nil");
        }
        if (nil != cell && cell != draggingThumb) {
            // Go opposite direction
            NSInteger moveToColumn = column - increment;
            NSInteger moveToRow = row;
            if (moveToColumn < 0) {
                moveToColumn = numOfColumns_ - 1;
                moveToRow = row - increment;
            } else if (moveToColumn == numOfColumns_) {
                moveToColumn = 0;
                moveToRow = row - increment;
            }
//            NSLog(@"Calculated -> Start (%d, %d) MoveTo (%d, %d)", row, column, moveToRow, moveToColumn);
            CGRect frame = [self rectForColumn:moveToColumn row:moveToRow];
            
            [cell setIndexPath:[NSIndexPath indexPathForRow:moveToRow column:moveToColumn]];
            [thumbnailsInUse_ setObject:cell forKey:[self keyFromIndexPath:[NSIndexPath indexPathForRow:moveToRow column:moveToColumn]]];
            
            [cell setHome:frame];
            [cell goHome];
        }
        i += increment;
    }
    [draggingThumb setIndexPath:[NSIndexPath indexPathForRow:draggingThumbMoveToRow column:draggingThumbMoveToColumn]];
    [thumbnailsInUse_ setObject:draggingThumb forKey:[self keyFromIndexPath:[NSIndexPath indexPathForRow:draggingThumbMoveToRow column:draggingThumbMoveToColumn]]];
    CGRect moveToFrame = [self rectForColumn:draggingThumbMoveToColumn row:draggingThumbMoveToRow];
    [draggingThumb setHome:moveToFrame];
    if ([dataSource_ respondsToSelector:@selector(thumbnailView:moveCellAtIndexPath:toIndexPath:)]) {
        [dataSource_ thumbnailView:self 
               moveCellAtIndexPath:[NSIndexPath indexPathForRow:startingRow column:startingColumn] 
                       toIndexPath:[NSIndexPath indexPathForRow:draggingThumbMoveToRow column:draggingThumbMoveToColumn]];
    }
}

- (void)thumbnailGridViewCellStoppedTracking:(CVThumbnailGridViewCell *) cell {
    autoscrollDistance_ = 0;
    [autoscrollTimer_ invalidate];
    autoscrollTimer_ = nil;
}

#pragma mark AutoScroll 
// Autoscroll implementation below is taken from the Apple iPhone SDK sample code "ScrollViewSuite"

#define AUTOSCROLL_THRESHOLD 30
- (void) maybeAutoscrollForThumb:(CVThumbnailGridViewCell *) cell {
    autoscrollDistance_ = 0;
    
    if (CGRectIntersectsRect([cell frame], [self bounds])) {
        CGPoint touchLocation = [cell convertPoint:[cell touchLocation] toView:self];
        CGFloat distanceFromTopEdge  = touchLocation.y - CGRectGetMinY([self bounds]);
        CGFloat distanceFromBottomEdge = CGRectGetMaxY([self bounds]) - touchLocation.y;
        
        if (distanceFromTopEdge < AUTOSCROLL_THRESHOLD) {
            autoscrollDistance_ = [self autoscrollDistanceForProximityToEdge:distanceFromTopEdge] * -1;
        } else if (distanceFromBottomEdge < AUTOSCROLL_THRESHOLD) {
            autoscrollDistance_ = [self autoscrollDistanceForProximityToEdge:distanceFromBottomEdge];
        }        
    }
    
    if (autoscrollDistance_ == 0) {
        [autoscrollTimer_ invalidate];
        autoscrollTimer_ = nil;
    } 
    else if (autoscrollTimer_ == nil) {
        autoscrollTimer_ = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                           target:self 
                                                         selector:@selector(autoscrollTimerFired:) 
                                                         userInfo:cell 
                                                          repeats:YES];
    } 
}

- (CGFloat) autoscrollDistanceForProximityToEdge:(CGFloat)proximity {
    return ceilf((AUTOSCROLL_THRESHOLD - proximity) / 5.0);
}

- (void) legalizeAutoscrollDistance {
    CGFloat minimumLegalDistance = [self contentOffset].y * -1;
    CGFloat maximumLegalDistance = [self contentSize].height - ([self frame].size.height + [self contentOffset].y);
    autoscrollDistance_ = MAX(autoscrollDistance_, minimumLegalDistance);
    autoscrollDistance_ = MIN(autoscrollDistance_, maximumLegalDistance);
}

- (void) autoscrollTimerFired:(NSTimer*)timer {
    [self legalizeAutoscrollDistance];
    
    CGPoint contentOffset = [self contentOffset];
    contentOffset.y += autoscrollDistance_;
    [self setContentOffset:contentOffset];
    
    CVThumbnailGridViewCell *cell = (CVThumbnailGridViewCell *)[timer userInfo];
    [cell moveByOffset:CGPointMake(0, autoscrollDistance_)];
}

#pragma mark Cell Selection Animation

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
        if ([delegate_ respondsToSelector:@selector(thumbnailView:didSelectCellAtIndexPath:)]) {
            [delegate_ thumbnailView:self didSelectCellAtIndexPath:[cell indexPath]];
        }

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

- (NSUInteger) indexForNumOfColumns:(NSUInteger) numOfColumns {
    return self.row * numOfColumns + self.column;
}

@end
