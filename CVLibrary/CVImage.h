//
//  CVImage.h
//  CVLibrary
//
//  Created by Kerem Karatal on 5/24/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyle.h"

@interface CVImage : NSObject {
    NSString *imageUrl_;
    UIImage *image_;
    UIImage *adornedImage_;
    BOOL isLoaded_, isLoading_;
    id delegate_;
    NSIndexPath *indexPath_;
    NSUInteger previousMemorySize_;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) UIImage *adornedImage;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic) BOOL isLoaded;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, readonly) NSUInteger previousMemorySize;

- (id) initWithUrl:(NSString *) url indexPath:(NSIndexPath *) indexPath;
- (void) beginLoadingImage;
- (void) setImage:(UIImage *) image usingStyle:(CVStyle *) style;
- (NSUInteger) memorySize;

@end
