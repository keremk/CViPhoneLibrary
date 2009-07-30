//
//  DemoItem.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 6/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "DemoItem.h"

@implementation DemoItem
@synthesize title = title_;
@synthesize imageUrl = imageUrl_;
@synthesize demoItemId = demoItemId_;

- (void) dealloc {
    [title_ release];
    [imageUrl_ release];
    [demoItemId_ release];
    [super dealloc];
}

- (id) initWithDictionary:(NSDictionary *) dict {
    self = [super init];
    if (self != nil) {
        self.title = [dict objectForKey:@"title"];
        self.imageUrl = [dict objectForKey:@"image_url"];
        self.demoItemId = [dict objectForKey:@"demo_item_id"];
    }
    return self;    
}

@end
