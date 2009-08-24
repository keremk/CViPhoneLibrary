//
//  ColorToStringConverter.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/15/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellHandler.h"

@interface ColorToStringConverter : NSObject<DataConverter> {
}
- (id) convertUsingData:(id) data;
@end
