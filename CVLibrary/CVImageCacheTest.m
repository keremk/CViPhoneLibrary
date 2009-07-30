//
//  CVImageCacheTest.m
//  CVLibrary
//
//  Created by Kerem Karatal on 7/23/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//
//  Link to Google Toolbox For Mac (IPhone Unit Test): 
//					http://code.google.com/p/google-toolbox-for-mac/wiki/iPhoneUnitTesting
//  Link to OCUnit:	http://www.sente.ch/s/?p=276&lang=en
//  Link to OCMock:	http://www.mulle-kybernetik.com/software/OCMock/



#import <UIKit/UIKit.h>
#import <OCMock/OCMock.h>
#import <OCMock/OCMConstraint.h>
#import "GTMSenTestCase.h"
#import "CVLibrary.h"

@interface CVImageCacheTest : GTMTestCase {
	id mock; // Mock object used in tests	
}

- (UIImage *) fakeImageForText:(NSString *) text size:(CGSize) size;
@end

@implementation CVImageCacheTest

#if TARGET_IPHONE_SIMULATOR     // Only run when the target is simulator

#define TEST_CACHE_SIZE 20000000 // 10M
#define SMALL_CACHE_SIZE 10000 // 10K

- (void) setUp {
    // Because (unfortunately) CVImageCache is a singleton not much needed here.
    // Just initialize with the test cache size, rather than the default one
    // Do not forget to clear the cache after each test and change memory cache size
    
    CVImageCache *imageCache = [CVImageCache sharedCVImageCache]; 
    
    [imageCache setMemoryCacheSize:TEST_CACHE_SIZE];     
}

- (void) testCacheSize {
    CVImageCache *imageCache = [CVImageCache sharedCVImageCache];
    NSUInteger size = [imageCache memoryCacheSize];
    STAssertTrue(size == TEST_CACHE_SIZE, @"Size is not set correct");
    
    CVImage *image = [[CVImage alloc] initWithUrl:@"1" indexPath:nil];
    [imageCache setImage:image];
    [image release]; 
    image = nil;
        
    [imageCache setMemoryCacheSize:SMALL_CACHE_SIZE];
    
    image = [imageCache imageForKey:@"1"];
    STAssertTrue(image == nil, @"Changing memory size should clear cache");
    
    size = [imageCache memoryCacheSize];
    STAssertTrue(size == SMALL_CACHE_SIZE, @"Changing memory size, should return new memory size");
    
    // Set the memory back to test size, clear memory cache
    [imageCache setMemoryCacheSize:TEST_CACHE_SIZE];
}

- (void) testImageSizeInCache {
    CVImageCache *imageCache = [CVImageCache sharedCVImageCache];
    
    UIImage *image = [self fakeImageForText:@"1" size:CGSizeMake(80.0, 80.0)];
    NSUInteger imageSize = [image imageMemorySize];
    
    CVImage *cvImage = [[CVImage alloc] initWithUrl:@"1" indexPath:nil];
    [cvImage setImage:image usingStyle:nil];
    [imageCache setImage:cvImage];
    [cvImage release];
    
    NSUInteger memoryCacheSize = [imageCache currentMemoryCacheSize];
    STAssertTrue(memoryCacheSize == imageSize, @"Cache memory size should be equal to the sum of mem sizes of images");
    
    [imageCache clearMemoryCache];
}

- (void) testImageSizeChange {
    CVImageCache *imageCache = [CVImageCache sharedCVImageCache];
    
    // Step 1
    UIImage *image = [self fakeImageForText:@"1" size:CGSizeMake(80.0, 80.0)];
    NSUInteger imageSize = [image imageMemorySize];
    CVImage *cvImage = [[CVImage alloc] initWithUrl:@"1" indexPath:nil];
    [imageCache setImage:cvImage];
    NSUInteger memoryCacheSize = [imageCache currentMemoryCacheSize];
    STAssertTrue(memoryCacheSize == 0, @"When there is no image contents, cache size should stay the same");
    
    // Step 2
    [cvImage setImage:image usingStyle:nil];    
    memoryCacheSize = [imageCache currentMemoryCacheSize];    
    STAssertTrue(memoryCacheSize == imageSize, @"When the image contents change, cache should update");
    
    // Step 3
    image = [self fakeImageForText:@"1" size:CGSizeMake(150.0, 150.0)];
    imageSize = [image imageMemorySize];    
    [cvImage setImage:image usingStyle:nil];
    memoryCacheSize = [imageCache currentMemoryCacheSize];
    STAssertTrue(memoryCacheSize == imageSize, @"When the image contents change again, cache should update");
    
    [cvImage release];    
    [imageCache clearMemoryCache];
}

- (void) testCacheAllocation {
    CVImageCache *imageCache = [CVImageCache sharedCVImageCache];
    
    for (NSInteger i = 0; i < 1000; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d", i];
        CVImage *cvImage = [[CVImage alloc] initWithUrl:imageName indexPath:nil];
        [imageCache setImage:cvImage];
        [cvImage release];
    }
    NSUInteger memoryCacheSize = [imageCache currentMemoryCacheSize];
    STAssertTrue(memoryCacheSize == 0, @"Should have 0 size, no actual images in memory");
    
    NSUInteger totalSize = 0;
    for (NSInteger i = 0; i < 1000; i++) {
        CGFloat randomSize = (arc4random() % 501) + 30.0;
        NSString *imageName = [NSString stringWithFormat:@"%d", i];
        UIImage *image = [self fakeImageForText:imageName size:CGSizeMake(randomSize, randomSize)];
        NSUInteger imageSize = [image imageMemorySize];
        totalSize += imageSize;
        
        CVImage *cvImage = [imageCache imageForKey:imageName];
        [cvImage setImage:image usingStyle:nil];        
    }
    memoryCacheSize = [imageCache currentMemoryCacheSize];
    if (totalSize > TEST_CACHE_SIZE) {
        STAssertTrue(memoryCacheSize < totalSize, @"Some images should be deleted and cache should be less than allowed max");
    } else {
        STAssertTrue(memoryCacheSize == totalSize, @"No images deleted, cache should be equal total size of images");
    }

    
    [imageCache clearMemoryCache];    
}

- (void) tearDown {
    // Because CVImageCache is a singleton not much needed here.
}

#pragma mark Helper Functions

- (UIImage *) fakeImageForText:(NSString *) text size:(CGSize) size{
    UIGraphicsBeginImageContext(size);    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    CGContextFillRect(context, rect);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1.0);
    [text drawInRect:rect withFont:[UIFont boldSystemFontOfSize:64.0]];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#endif

@end
