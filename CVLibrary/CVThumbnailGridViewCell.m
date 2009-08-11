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
@property (nonatomic, retain) UIImageView *thumbnailImageView;

@end

@implementation CVThumbnailGridViewCell
@synthesize delegate = delegate_;
@synthesize thumbnailImageView = thumbnailImageView_;
@synthesize indexPath = indexPath_;
@synthesize home = home_;
@synthesize touchLocation = touchLocation_;
@synthesize cachedImage = cachedImage_;

- (void)dealloc {
	[indexPath_ release];
	[thumbnailImageView_ release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *) identifier {
    if (self = [super initWithFrame:frame]) {
		thumbnailImageView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
        [thumbnailImageView_ setUserInteractionEnabled:YES];
		if (nil == thumbnailImageView_.superview) {
			[self addSubview:thumbnailImageView_];
		}
        [self setUserInteractionEnabled:YES];
        [self setOpaque:YES];
        isInEditMode_ = NO;
//        [self setExclusiveTouch:YES];
    }
    return self;
}

- (void) setImage:(UIImage *)image {
	[thumbnailImageView_ setImage:image];
}

static char imageObservingContext;

- (void) setCachedImage:(CVImage *) image {
    if (cachedImage_ != image) {
        [cachedImage_ removeObserver:self forKeyPath:@"image"];
        [cachedImage_ release];
        cachedImage_ = [image retain];
        [cachedImage_ addObserver:self forKeyPath:@"image" options:NSKeyValueChangeSetting context:&imageObservingContext];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &imageObservingContext) {
        CVImage *cachedImage = (CVImage *) object;
        [thumbnailImageView_ setImage:[cachedImage adornedImage]];
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

- (void) setFrame:(CGRect) frame {
	[super setFrame:frame];
	
    [thumbnailImageView_ setFrame:self.bounds];
}

#pragma mark Touch events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isInEditMode_ = [delegate_ isInEditMode];
    
    if (isInEditMode_) {
        // store the location of the starting touch so we can decide when we've moved far enough to drag
        touchLocation_ = [[touches anyObject] locationInView:self];
//        NSLog(@"Cell %f, %f", touchLocation_.x, touchLocation_.y);
        if ([delegate_ respondsToSelector:@selector(thumbnailGridViewCellStartedTracking:)])
            [delegate_ thumbnailGridViewCellStartedTracking:self];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isInEditMode_) return;
    
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
        if ([delegate_ respondsToSelector:@selector(thumbnailGridViewCellWasTapped:)])
            [delegate_ thumbnailGridViewCellWasTapped:self];
    }
    
    if (isInEditMode_ && [delegate_ respondsToSelector:@selector(thumbnailGridViewCellStoppedTracking:)]) 
        [delegate_ thumbnailGridViewCellStoppedTracking:self];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isInEditMode_) return;
    
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

