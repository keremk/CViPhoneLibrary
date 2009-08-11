//
//  CVStyle.h
//  CVLibrary
//
//  Created by Kerem Karatal on 5/14/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVBorderStyle.h"
#import "CVShadowStyle.h"

@interface CVStyle : NSObject {
    CVBorderStyle *borderStyle_;
    CVShadowStyle *shadowStyle_;
    CGSize imageSize_;
}

@property (nonatomic, retain) CVBorderStyle *borderStyle;
@property (nonatomic, retain) CVShadowStyle *shadowStyle;
@property (nonatomic) CGSize imageSize;

- (UIImage *) imageByApplyingStyleToImage:(UIImage *) image;
- (CGSize) sizeAfterStylingImage;

@end
