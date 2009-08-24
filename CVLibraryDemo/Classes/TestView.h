//
//  TestView.h
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 8/24/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestView : UIView {
    NSString *text_;
    UILabel *label_;
}

@property (nonatomic, copy) NSString *text;
@end
