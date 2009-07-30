//
//  TextCellHandler.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/12/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellHandler.h"

@interface TextCellHandler : NSObject<CellHandler, UITextFieldDelegate> {
    id<CellHandlerDelegate> delegate_;
    NSString *label_;
    NSString *keyPath_;
    NSString *identifier_;
    NSString *keyboardType_;
}

@end
