//
//  CVEllipseBorder.h
//  CVLibrary
//
//  Created by Kerem Karatal on 9/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStyleProtocols.h"

@interface CVEllipseBorder : NSObject<CVBorderStyle> {
    CGFloat width_;
    UIColor *color_;

    CGFloat radius_;
}

@property (nonatomic) CGFloat radius;
@end
