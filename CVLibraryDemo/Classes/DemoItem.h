//
//  DemoItem.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 6/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DemoItem : NSObject {
    NSString *title_;
    NSString *imageUrl_;
    NSNumber *demoItemId_;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, retain) NSNumber *demoItemId;
- (id) initWithDictionary:(NSDictionary *) dict;

@end
