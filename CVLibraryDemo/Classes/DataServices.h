/*
 *  DataSources.h
 *  ActivityApp
 *
 *  Created by Kerem Karatal on 4/14/09.
 *  Copyright 2009 Coding Ventures. All rights reserved.
 *
 */

@class CVStyle, CVImage;

@protocol DemoDataServiceDelegate <NSObject>
@required
- (void) updatedWithItems:(NSArray *) items;

@optional
- (void) updatedImage:(NSDictionary *) dict;
@end

@protocol DemoDataService <NSObject>
@required 
- (void) beginLoadDemoData;
@property (nonatomic, assign) NSObject<DemoDataServiceDelegate> *delegate;

@optional
- (void) beginLoadImageForUrl:(NSString *) url;
- (void) beginLoadImageForUrl:(NSString *) url usingStyle:(CVStyle *)style;
@end

