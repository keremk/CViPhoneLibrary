//
//  BoolCellHandler.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/26/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellHandler.h"

@interface BoolCellHandler : NSObject<CellHandler> {
    id<CellHandlerDelegate> delegate_;
    NSString *label_;
    NSString *keyPath_;
    NSString *identifier_;
}

@end
