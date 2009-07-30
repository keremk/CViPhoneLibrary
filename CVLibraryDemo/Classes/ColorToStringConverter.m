//
//  ColorToStringConverter.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/15/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "ColorToStringConverter.h"


@implementation ColorToStringConverter

- (id) convertUsingData:(id) data {
    NSString *stringInput = [NSString stringWithFormat:@"%@Color", (NSString *) data];
    return [UIColor performSelector:NSSelectorFromString(stringInput)];
}

@end
