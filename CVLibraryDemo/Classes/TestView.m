//
//  TestView.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 8/24/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "TestView.h"


@implementation TestView
@synthesize text = text_;

- (void)dealloc {
    [text_ release], text_ = nil;
    [label_ release], label_ = nil;
    [super dealloc];
}

#define FONT_SIZE 24.0

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        label_ = [[UILabel alloc] initWithFrame:CGRectZero];
        label_.font = [UIFont systemFontOfSize:FONT_SIZE];
        label_.textColor = [UIColor blackColor];
        [self addSubview:label_];
    }
    return self;
}

- (void) setText:(NSString *) text {
    if (text != text_) {
        [text_ release];
        text_ = [[NSString alloc] initWithString:text];
        label_.text = text_;
        CGSize size = [text_ sizeWithFont:label_.font];
        CGFloat x = (self.bounds.size.width - size.width) / 2;
        CGFloat y = (self.bounds.size.height - size.height) / 2;
        label_.frame = CGRectMake(x, y, size.width, size.height);
        label_.backgroundColor = [self backgroundColor];
        [self setNeedsLayout];
    }
}

@end
