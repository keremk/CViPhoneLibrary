//
//  EnumCellHandler.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/13/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellHandler.h"
#import "EnumOptionsViewController.h"

@interface EnumCellHandler : NSObject<CellHandler, OptionSelectionChangedDelegate> {
    id<CellHandlerDelegate> delegate_;
    NSString *label_;
    NSString *keyPath_;
    NSString *identifier_;
    NSArray *options_;
    NSString *dataConverterClassName_;
    NSInteger selectedOptionIndex_;
}


@end
