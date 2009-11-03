//
//  CVEllipseBorder.h
//  CVLibrary
//
//  Created by Kerem Karatal on 9/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVBorderStyle.h"

@interface CVEllipseBorder : CVBorderStyle {
    CGFloat radius_;
}

@property (nonatomic) CGFloat radius;
@end
