//
//  ThumbnailViewCell.m
//  ColoringBook
//
//  Created by Kerem Karatal on 1/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVThumbnailGridViewCell.h"
#import "CVThumbnailGridView.h"

#define DRAG_THRESHOLD 10

CGFloat distanceBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat deltaX = a.x - b.x;
    CGFloat deltaY = a.y - b.y;
    return sqrtf( (deltaX * deltaX) + (deltaY * deltaY) );
}

@interface CVThumbnailGridViewCell()
@property (nonatomic, retain) UIImage *thumbnailImage;
//@property (nonatomic, retain) UIImage *deleteSignImage;
- (void) renderAdornedImageLoadingIcon;
- (CGPoint) deleteSignOrigin;
- (UIImage *) deleteSignIcon;
@end

@implementation CVThumbnailGridViewCell
@synthesize delegate = delegate_;
@synthesize indexPath = indexPath_;
@synthesize home = home_;
@synthesize touchLocation = touchLocation_;
@synthesize cachedImage = cachedImage_;
@synthesize thumbnailImage = thumbnailImage_;
//@synthesize deleteSignImage = deleteSignImage_;
@synthesize style = style_;
@synthesize editing = editing_;
@synthesize upperLeftMargin = upperLeftMargin_;

- (void)dealloc {
	[indexPath_ release];
    [thumbnailImage_ release];
//    [deleteSignImage_ release];
    [style_ release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *) identifier {
    if (self = [super initWithFrame:frame]) {
//		thumbnailImageView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [thumbnailImageView_ setUserInteractionEnabled:YES];
//		if (nil == thumbnailImageView_.superview) {
//			[self addSubview:thumbnailImageView_];
//		}
        [self setUserInteractionEnabled:YES];
        [self setOpaque:NO];
//        deleteSignImage_ = [[UIImage imageNamed:@"X-Sign.png"] retain]; // 34x34
        editing_ = NO;
//        [self setExclusiveTouch:YES];
    }
    return self;
}

- (void) setEditing:(BOOL) editing {
    if (editing != editing_) {
        editing_ = editing;
        [self setNeedsDisplay];
    }
}

- (void) renderAdornedImageLoadingIcon {
    if ([delegate_ respondsToSelector:@selector(adornedImageLoadingIcon)]) {
        UIImage *adornedImageLoadingIcon = [delegate_ adornedImageLoadingIcon];
        if (nil != adornedImageLoadingIcon) {
            self.thumbnailImage = adornedImageLoadingIcon;
            [self setNeedsDisplay];
//            [thumbnailImageView_ setImage:adornedImageLoadingIcon];
        }
    }
}

- (UIImage *) deleteSignIcon {
    UIImage *deleteSignIcon = nil;
    if ([delegate_ respondsToSelector:@selector(deleteSignIcon)]) {
        deleteSignIcon = [delegate_ deleteSignIcon];
    }
    return deleteSignIcon;
}

- (void) drawRect:(CGRect) rect {    
    CGPoint shadowOffset = [style_.shadowStyle effectiveOffsetInUIKitCoordinateSystem];
    CGPoint thumbnailPoint;
    
    thumbnailPoint.x = (upperLeftMargin_.x >= shadowOffset.x) ? upperLeftMargin_.x - shadowOffset.x : shadowOffset.x;
    thumbnailPoint.y = (upperLeftMargin_.y >= shadowOffset.y) ? upperLeftMargin_.y - shadowOffset.y : shadowOffset.y;
    
    [self.thumbnailImage drawAtPoint:thumbnailPoint];

    if (editing_) {
        [[self deleteSignIcon] drawAtPoint:[self deleteSignOrigin]];
    }
}

- (CGPoint) deleteSignOrigin {
    CGPoint shadowOffset = [style_.shadowStyle effectiveOffsetInUIKitCoordinateSystem];

    CGPoint deleteSignPoint;
    deleteSignPoint.x = (upperLeftMargin_.x >= shadowOffset.x) ? 0 : shadowOffset.x - upperLeftMargin_.x;
    deleteSignPoint.y = (upperLeftMargin_.y >= shadowOffset.y) ? 0 : shadowOffset.y - upperLeftMargin_.y;
    
    return deleteSignPoint;
}

- (void) setImage:(UIImage *)image {
    if (nil != image) {
        self.thumbnailImage = image;
        [self setNeedsDisplay];
//        [thumbnailImageView_ setImage:image];
    } else {
        if (nil == delegate_) {
            // Wait until the CVThumbnailGridView sets the delegate
            [self performSelector:@selector(renderAdornedImageLoadingIcon) withObject:nil afterDelay:0.01];
        } else  {
            [self renderAdornedImageLoadingIcon];
        }
    }
}

static char imageObservingContext;

- (void) setCachedImage:(CVImage *) image {
    if (cachedImage_ != image) {
        [cachedImage_ removeObserver:self forKeyPath:@"image"];
        [cachedImage_ release];
        cachedImage_ = [image retain];
        [self setImage:[cachedImage_ image]];
        [cachedImage_ addObserver:self forKeyPath:@"image" options:NSKeyValueChangeSetting context:&imageObservingContext];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &imageObservingContext) {
        CVImage *cachedImage = (CVImage *) object;
        [self setImage:[cachedImage image]];
//        [thumbnailImageView_ setImage:[cachedImage image]];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//- (void) setIndexPath:(NSIndexPath *) indexPath {
//    if (indexPath_ != indexPath) {
//        [indexPath_ release];
//        indexPath_ = [indexPath retain];
//        NSLog(@"IndexPath %d, %d set", indexPath.row, indexPath.column);
//    }
//}

//- (void) setFrame:(CGRect) frame {
//	[super setFrame:frame];
//	
//    [thumbnailImageView_ setFrame:self.bounds];
//}

#pragma mark Touch events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (editing_) {
        // store the location of the starting touch so we can decide when we've moved far enough to drag
        touchLocation_ = [[touches anyObject] locationInView:self];
//        NSLog(@"Cell %f, %f", touchLocation_.x, touchLocation_.y);
        if ([delegate_ respondsToSelector:@selector(thumbnailGridViewCellStartedTracking:)])
            [delegate_ thumbnailGridViewCellStartedTracking:self];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!editing_) return;
    
    // we want to establish a minimum distance that the touch has to move before it counts as dragging,
    // so that the slight movement involved in a tap doesn't cause the frame to move.
    
    CGPoint newTouchLocation = [[touches anyObject] locationInView:self];
    
    if (dragging_) {
        float deltaX = newTouchLocation.x - touchLocation_.x;
        float deltaY = newTouchLocation.y - touchLocation_.y;
        [self moveByOffset:CGPointMake(deltaX, deltaY)];
    }
    else if (distanceBetweenPoints(touchLocation_, newTouchLocation) > DRAG_THRESHOLD) {
        touchLocation_ = newTouchLocation;
        dragging_ = YES;
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {    
    if (dragging_) {
        [self goHome];
        dragging_ = NO;
    } else if ([[touches anyObject] tapCount] == 1) {
        CGPoint touchLocation = [[touches anyObject] locationInView:self];
        CGPoint deleteSignOrigin = [self deleteSignOrigin];
        CGSize deleteSignSize = [[self deleteSignIcon] size];
        CGRect deleteSignRect = CGRectMake(deleteSignOrigin.x, deleteSignOrigin.y, deleteSignSize.width, deleteSignSize.width);
        
        if (CGRectContainsPoint(deleteSignRect, touchLocation)) {         
            if ([delegate_ respondsToSelector:@selector(deleteSignWasTapped:)]) {
                [delegate_ deleteSignWasTapped:self];
            }
        } else {
            if ([delegate_ respondsToSelector:@selector(thumbnailGridViewCellWasTapped:)])
                [delegate_ thumbnailGridViewCellWasTapped:self];
        }
            
    }
    
    if (editing_ && [delegate_ respondsToSelector:@selector(thumbnailGridViewCellStoppedTracking:)]) 
        [delegate_ thumbnailGridViewCellStoppedTracking:self];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!editing_) return;
    
    [self goHome];
    dragging_ = NO;
    if ([delegate_ respondsToSelector:@selector(thumbnailGridViewCellStoppedTracking:)]) 
        [delegate_ thumbnailGridViewCellStoppedTracking:self];
}

- (void) goHome {
    CGFloat distanceFromHome = distanceBetweenPoints([self frame].origin, [self home].origin); // distance is in pixels
    CGFloat animationDuration = 0.1 + distanceFromHome * 0.001;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [self setFrame:[self home]];
    [UIView commitAnimations];
}
    
- (void) moveByOffset:(CGPoint)offset {
    CGRect frame = [self frame];
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    [self setFrame:frame];
    if ([delegate_ respondsToSelector:@selector(thumbnailGridViewCellMoved:)])
        [delegate_ thumbnailGridViewCellMoved:self];
}    

@end

