//
//  FakeDataService.h
//  ActivityApp
//
//  Created by Kerem Karatal on 4/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataServices.h"
#import "DemoItem.h"

@interface FakeDataService : NSObject <DemoDataService>{
    NSObject <DemoDataServiceDelegate> *delegate_;
    NSOperationQueue *operationQueue_;
}

- (id) init;
- (UIImage *) createFakeImageForUrl:(NSDictionary *) args;
- (DemoItem *) createDummyDemoItemForId:(NSNumber *) demoItemId title:(NSString *) title url:(NSString *) url;
@end
