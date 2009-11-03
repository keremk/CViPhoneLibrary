//
//  LoadMoreView.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 8/26/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "LoadMoreControl.h"

@interface LoadMoreControl()
- (IBAction) buttonTapped:(id) sender;
@end


@implementation LoadMoreControl

- (void)dealloc {
    [loadMoreButton_ removeTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchDown];
    [loadMoreButton_ release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        loadMoreButton_ = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [loadMoreButton_ setTitle:@"Load More..." forState:UIControlStateNormal];
        [loadMoreButton_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loadMoreButton_ setShowsTouchWhenHighlighted:YES];
        [loadMoreButton_ addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchDown];
        [loadMoreButton_ setContentMode:UIViewContentModeCenter];
        [loadMoreButton_ setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [loadMoreButton_ setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:loadMoreButton_];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGSize size = [loadMoreButton_.currentTitle sizeWithFont:loadMoreButton_.titleLabel.font];
    size.width = size.width * 1.2;
    size.height = size.height * 1.2;
    CGFloat x = (self.bounds.size.width - size.width) / 2;
    CGFloat y = (self.bounds.size.height - size.height) / 2;
    loadMoreButton_.frame = CGRectMake(x, y, size.width, size.height);
}


- (IBAction) buttonTapped:(id) sender {
    [loadMoreButton_ setTitle:@"Loading..." forState:UIControlStateNormal];
    loadMoreButton_.enabled = NO;
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void) enableLoadMoreButton {
    loadMoreButton_.enabled = YES;
    [loadMoreButton_ setTitle:@"Load More..." forState:UIControlStateNormal];
}


@end
