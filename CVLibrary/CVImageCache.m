//
//  CVImageCache.m
//  CVLibrary
//
//  Created by Kerem Karatal on 5/17/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVImageCache.h"
#import "SynthesizeSingleton.h"

@interface CVImageCache() 
- (void) removeObserversFromImages;
- (void) checkAndHandleLowMemory;
@end

@implementation CVImageCache
@synthesize memoryCacheSize = memoryCacheSize_;
@synthesize currentMemoryCacheSize = currentMemCacheSize_;

static NSUInteger const kDefaultMemCacheSize = 10000 * 1024; // 10MB

- (void) dealloc {
    [self removeObserversFromImages];
    [imageCache_ release], imageCache_ = nil;
    [imageCacheHistory_ release], imageCacheHistory_ = nil;
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        memoryCacheSize_ = kDefaultMemCacheSize;
        imageCache_ = nil;
        imageCacheHistory_ = nil;        
        [self clearMemoryCache];
    }
    return self;
}

- (void) setMemoryCacheSize:(NSUInteger) newSize {
    memoryCacheSize_ = newSize;
    [self clearMemoryCache];
}

static char imageSizeObservingContext;

- (void) setImage:(CVImage *) image {
    if (nil == image) 
        return;
    
    if ([imageCache_ objectForKey:image.imageUrl]) {
        return;
    }
    
    NSUInteger newImageMemSize = [image memorySize];
    currentMemCacheSize_ += newImageMemSize;        
    
    [imageCache_ setObject:image forKey:image.imageUrl];
    if (newImageMemSize > 0) {
        [imageCacheHistory_ addObject:image.imageUrl];
    }
    [image addObserver:self forKeyPath:@"image" options:NSKeyValueChangeSetting context:&imageSizeObservingContext];

    [self checkAndHandleLowMemory];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &imageSizeObservingContext) {
        CVImage *image = (CVImage *) object;
        
        currentMemCacheSize_ -= image.previousMemorySize;
        NSUInteger newImageMemSize = [image memorySize];
        currentMemCacheSize_ += newImageMemSize;
        
        // Image is changes so add this to the top of history
        if (newImageMemSize > 0) {
            [imageCacheHistory_ addObject:image.imageUrl];
        }
        [self checkAndHandleLowMemory];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (CVImage *) imageForKey:(NSString *) key {
    CVImage *image = [imageCache_ objectForKey:key];
    
    return image;
}

- (void) removeObserversFromImages {
    if (nil != imageCache_) { 
        for (CVImage *image in [imageCache_ allValues]) {
            [image removeObserver:self forKeyPath:@"image"];
        }
    }
}

- (void) clearMemoryCache {
    [self removeObserversFromImages];
    [imageCache_ release]; 
    [imageCacheHistory_ release];

    imageCache_ = [[NSMutableDictionary alloc] init];
    imageCacheHistory_ = [[NSMutableArray alloc] init];
    currentMemCacheSize_ = 0;
}

- (void) checkAndHandleLowMemory {
    while ((currentMemCacheSize_ > memoryCacheSize_) && ([imageCacheHistory_ count] > 0)) {
        // Get the oldest image entry
        NSString *oldImageUrl = [imageCacheHistory_ objectAtIndex:0];
        CVImage *oldImage = [imageCache_ objectForKey:oldImageUrl];
        
        // Remove it
        currentMemCacheSize_ -= [oldImage memorySize];
        [imageCacheHistory_ removeObjectAtIndex:0];
        [imageCache_ removeObjectForKey:oldImage.imageUrl];        
    }    
}

@end
