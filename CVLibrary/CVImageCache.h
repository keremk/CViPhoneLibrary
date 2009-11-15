//
//  CVImageCache.h
//  CVLibrary
//
//  Created by Kerem Karatal on 5/17/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVImage.h"

@interface CVImageCache : NSObject {
@private
    NSMutableArray *imageCacheHistory_;     // To manage to LRU cache management
    NSMutableDictionary *imageCache_;       // Fast access to cache objects by id
    NSUInteger memoryCacheSize_;
    NSUInteger currentMemCacheSize_;
}

//+ (CVImageCache *) sharedCVImageCache;

- (id) init;
- (void) setImage:(CVImage *) image;
- (CVImage *) imageForKey:(NSString *) key;
- (void) clearMemoryCache;

@property (nonatomic) NSUInteger memoryCacheSize;
@property (nonatomic, readonly) NSUInteger currentMemoryCacheSize;

@end
