//
//  CVImage.h
//  CVLibrary
//
//  Created by Kerem Karatal on 5/24/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVImageAdorner.h"

@interface CVImage : NSObject {
    NSString *imageUrl_;
    UIImage *image_;
    NSIndexPath *indexPath_;
    NSUInteger previousMemorySize_;
}

@property (nonatomic, assign) UIImage *image;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, readonly) NSUInteger previousMemorySize;

- (id) initWithUrl:(NSString *) url indexPath:(NSIndexPath *) indexPath;
- (NSUInteger) memorySize;
@end
