/*
 *  CVImageLoadingService.h
 *  CVLibrary
 *
 *  Created by Kerem Karatal on 6/25/09.
 *  Copyright 2009 Coding Ventures. All rights reserved.
 *
 */


@protocol CVImageLoadingService <NSObject>
@required
- (void) beginLoadImageForUrl:(NSString *) url;
@end
