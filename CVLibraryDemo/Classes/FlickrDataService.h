//
//  FlickrDataService.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/28/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataServices.h"
#import "ObjectiveFlickr.h"

@interface FlickrDataService : NSObject<DemoDataService, OFFlickrAPIRequestDelegate> {
    NSObject <DemoDataServiceDelegate> *delegate_;
    OFFlickrAPIContext *context_;
    NSOperationQueue *operationQueue_;
}

@end
