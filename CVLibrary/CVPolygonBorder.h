//
//  CVPolygonBorder.h
//  CVLibrary
//
//  Created by Kerem Karatal on 9/10/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVBorderStyle.h"

@interface CVPolygonBorder : CVBorderStyle {
    NSUInteger numOfSides_;
}

@property (nonatomic) NSUInteger numOfSides;

@end
