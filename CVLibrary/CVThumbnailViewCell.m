//
//  CVThumbnailViewCell.m
//  CVLibrary
//
//  Created by Kerem Karatal on 1/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVThumbnailViewCell.h"
#import "CVThumbnailViewCell_Private.h"
#import "CVThumbnailView.h"
#import "CVTitleStyle.h"
#include "CGUtils.h"

#define DRAG_THRESHOLD 10

CGFloat distanceBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat deltaX = a.x - b.x;
    CGFloat deltaY = a.y - b.y;
    return sqrtf( (deltaX * deltaX) + (deltaY * deltaY) );
}

@implementation CVThumbnailViewCell
@synthesize delegate = delegate_;
@synthesize indexPath = indexPath_;
@synthesize home = home_;
@synthesize touchLocation = touchLocation_;
@synthesize thumbnailImage = thumbnailImage_;
@synthesize editing = editing_;
@synthesize imageUrl = imageUrl_;
@synthesize selected = selected_;
@synthesize title = title_;

- (void)dealloc {
    [title_ release], title_ = nil;
	[indexPath_ release], indexPath_ = nil;
    [thumbnailImage_ release], thumbnailImage_ = nil;
    [imageUrl_ release], imageUrl_ = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *) identifier {
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
        [self setOpaque:NO];
        editing_ = NO;
        imageUrl_ = nil;
        selected_ = NO;
    }
    return self;
}

- (void) setEditing:(BOOL) editing {
    if (editing != editing_) {
        editing_ = editing;
        [self setNeedsDisplay];
    }
}

- (void) setSelected:(BOOL) selected {
    if (selected != selected_) {
        selected_ = selected;
        [self setNeedsDisplay];
    }
}

- (UIImage *) deleteSignIcon {
    UIImage *deleteSignIcon = nil;
    if ([delegate_ respondsToSelector:@selector(deleteSignIcon)]) {
        deleteSignIcon = [delegate_ deleteSignIcon];
    }
    return deleteSignIcon;
}

- (CVImageAdorner *) imageAdorner {
    CVImageAdorner *imageAdorner;
    if (self.selected) {
        imageAdorner = [delegate_ selectedImageAdorner];
    } else {
        imageAdorner = [delegate_ imageAdorner];
    }
    return imageAdorner;
}

#define CORNER_OVAL_WIDTH 10
#define CORNER_OVAL_HEIGHT 10

- (void) drawRect:(CGRect) rect {    
    CGSize padding = CGSizeZero;
    if ([delegate_ respondsToSelector:@selector(editModeEnabled)]) {
        if ([delegate_ editModeEnabled]) {
            padding = [self.imageAdorner paddingRequiredForUpperLeftBadgeSize:[[self deleteSignIcon] size]];
        }
    }
    CGPoint pointToDrawImage = CGPointMake(padding.width, padding.height);
    [self.thumbnailImage drawAtPoint:pointToDrawImage];

    if (editing_) {
        CGRect deleteSignRect = [self deleteSignRect];
        [[self deleteSignIcon] drawAtPoint:deleteSignRect.origin];
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.selected && [self.delegate showDefaultSelectionEffect]) {
        
        CGContextBeginPath(context);
        CVAddRoundedRectToPath(context, rect, CORNER_OVAL_WIDTH, CORNER_OVAL_HEIGHT); 
        CGContextClosePath(context);
        UIColor *borderColor = [self.delegate selectionBorderColor];
        CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
        CGFloat borderWidth = [self.delegate selectionBorderWidth];
        CGContextSetLineWidth(context, borderWidth);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if ([self.delegate showTitles]) {
        CVTitleStyle *titleStyle = [self.delegate titleStyle];
        CGSize sizeRequiredForTitle = [self.title sizeWithFont:titleStyle.font];
        CGFloat yPoint = self.frame.size.height - sizeRequiredForTitle.height;
        CGFloat xPoint = MAX(0.0, (self.frame.size.width - sizeRequiredForTitle.width) / 2.0);

        sizeRequiredForTitle.width = MIN(sizeRequiredForTitle.width, self.frame.size.width);

        // Draw the text background
        CGRect textBackgroundRect = CGRectMake(0.0, yPoint, self.frame.size.width, sizeRequiredForTitle.height);
        CGContextSetFillColorWithColor(context, [titleStyle.backgroundColor CGColor]);
        CGContextFillRect(context, textBackgroundRect);
        
        // Draw the text
        CGPoint titlePoint = CGPointMake(xPoint, yPoint);
        CGContextSetFillColorWithColor(context, [titleStyle.foregroundColor CGColor]);
        [self.title drawAtPoint:titlePoint forWidth:sizeRequiredForTitle.width withFont:titleStyle.font lineBreakMode:titleStyle.lineBreakMode];        
    }
}

- (CGFloat) deleteSignSideLength {
    CGSize deleteSignSize = [[self deleteSignIcon] size];
    CGFloat deleteSignSideLength = deleteSignSize.width;
    
    return deleteSignSideLength;
}

- (CGRect) deleteSignRect {
    CGSize padding = [self.imageAdorner paddingRequiredForUpperLeftBadgeSize:[[self deleteSignIcon] size]];
    
    CGFloat deleteSignOriginX, deleteSignOriginY;
    if (padding.width > 0) {
        deleteSignOriginX = 0;
    } else {
        deleteSignOriginX = padding.width;
    }
    
    if (padding.height > 0) {
        deleteSignOriginY = 0;
    } else {
        deleteSignOriginY = padding.height;
    }

    return CGRectMake(deleteSignOriginX, deleteSignOriginY, self.deleteSignSideLength, self.deleteSignSideLength);
}

- (UIImage *) image { 
    return self.thumbnailImage;
}

- (void) setImage:(UIImage *)image {
    if (nil != image) {
        self.thumbnailImage = image;
        [self setNeedsDisplay];
    } 
}

#pragma mark Touch events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (editing_) {
        // store the location of the starting touch so we can decide when we've moved far enough to drag
        touchLocation_ = [[touches anyObject] locationInView:self];
//        NSLog(@"Cell %f, %f", touchLocation_.x, touchLocation_.y);
        if ([delegate_ respondsToSelector:@selector(thumbnailViewCellStartedTracking:)])
            [delegate_ thumbnailViewCellStartedTracking:self];
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
        
        if (editing_ && CGRectContainsPoint(self.deleteSignRect, touchLocation)) {         
            if ([delegate_ respondsToSelector:@selector(deleteSignWasTapped:)]) {
                [delegate_ deleteSignWasTapped:self];
            }
        } else {
            if ([delegate_ respondsToSelector:@selector(thumbnailViewCellWasTapped:)])
                [delegate_ thumbnailViewCellWasTapped:self];
        }
            
    }
    
    if (editing_ && [delegate_ respondsToSelector:@selector(thumbnailViewCellStoppedTracking:)]) 
        [delegate_ thumbnailViewCellStoppedTracking:self];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!editing_) return;
    
    [self goHome];
    dragging_ = NO;
    if ([delegate_ respondsToSelector:@selector(thumbnailViewCellStoppedTracking:)]) 
        [delegate_ thumbnailViewCellStoppedTracking:self];
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
    if ([delegate_ respondsToSelector:@selector(thumbnailViewCellMoved:)])
        [delegate_ thumbnailViewCellMoved:self];
}    

@end

