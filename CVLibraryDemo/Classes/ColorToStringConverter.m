//
//  ColorToStringConverter.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/15/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "ColorToStringConverter.h"


@implementation ColorToStringConverter

- (id) convertFromString:(NSString *) input {
    NSString *stringInput = [NSString stringWithFormat:@"%@Color", (NSString *) input];
    return [UIColor performSelector:NSSelectorFromString(stringInput)];
}

- (NSString *) convertToString:(id) input {
    UIColor *color = (UIColor *) input;
    NSString *output = @"";
    if ([color isEqual:[UIColor redColor]]) {
        output = @"red";
    } else if ([color isEqual:[UIColor orangeColor]]) {
        output = @"orange";
    } else if ([color isEqual:[UIColor greenColor]]) {
        output = @"green";
    } else if ([color isEqual:[UIColor blueColor]]) {
        output = @"blue";
    } else if ([color isEqual:[UIColor yellowColor]]) {
        output = @"yellow";
    } else if ([color isEqual:[UIColor blackColor]]) {
        output = @"black";
    } else if ([color isEqual:[UIColor whiteColor]]) {
        output = @"white";
    } else if ([color isEqual:[UIColor cyanColor]]) {
        output = @"cyan";
    } else if ([color isEqual:[UIColor magentaColor]]) {
        output = @"magenta";
    } else if ([color isEqual:[UIColor purpleColor]]) {
        output = @"purple";
    } else if ([color isEqual:[UIColor brownColor]]) {
        output = @"brown";
    } else if ([color isEqual:[UIColor grayColor]]) {
        output = @"gray";
    } else if ([color isEqual:[UIColor lightGrayColor]]) {
        output = @"lightGray";
    } else if ([color isEqual:[UIColor darkGrayColor]]) {
        output = @"darkGray";
    }

    return output;
}

@end
