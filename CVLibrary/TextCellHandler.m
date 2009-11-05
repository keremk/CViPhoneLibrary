//
//  TextCellHandler.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/12/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "TextCellHandler.h"

@interface TextCellHandler()
- (UITableViewCell *) tableView:(UITableView *) tableView cellWithReuseIdentifier:(NSString *) identifier;
- (UIKeyboardType) determineKeyboardType;
@end


@implementation TextCellHandler
@synthesize delegate = delegate_;
@synthesize label = label_;
@synthesize keyPath = keyPath_;
@synthesize identifier = identifier_;
@synthesize keyboardType = keyboardType_;

- (void) dealloc {
    [label_ release], label_ = nil;
    [keyPath_ release], keyPath_ = nil;
    [identifier_ release], identifier_ = nil;
    [keyboardType_ release], keyboardType_ = nil;
    [super dealloc];
}

#define LABEL_TAG 1
#define TEXTFIELD_TAG 2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath usingData:(id) data {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_];
    if (cell == nil) {
        cell = [self tableView:tableView cellWithReuseIdentifier:identifier_];
    }
    
    UITextField *textField = (UITextField *) [cell viewWithTag:TEXTFIELD_TAG];
    textField.delegate = self;
    textField.keyboardType = [self determineKeyboardType];

    if (nil == data) {
        textField.text = @"";
    } else if ([data isKindOfClass:[NSNumber class]]) {
        textField.text = [data stringValue];
    } else if ([data isKindOfClass:[NSString class]]) {
        textField.text = data;
    }
    
    UILabel *labelField = (UILabel *) [cell viewWithTag:LABEL_TAG];
    labelField.text = label_;

    return cell;
}


#define LEFT_COLUMN_OFFSET 10.0
#define LEFT_COLUMN_WIDTH 140.0

#define RIGHT_COLUMN_OFFSET 150.0
#define RIGHT_COLUMN_WIDTH 100.0

#define MAIN_FONT_SIZE 16.0
#define LABEL_HEIGHT 26.0

- (UITableViewCell *) tableView:(UITableView *) tableView cellWithReuseIdentifier:(NSString *) identifier {    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];

    CGRect frame = CGRectMake(LEFT_COLUMN_OFFSET, (tableView.rowHeight - LABEL_HEIGHT) / 2.0, LEFT_COLUMN_WIDTH, LABEL_HEIGHT);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.tag = LABEL_TAG;
    label.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = UITextAlignmentLeft;
    [cell.contentView addSubview:label];
    [label release];
    
    frame = CGRectMake(RIGHT_COLUMN_OFFSET, (tableView.rowHeight - LABEL_HEIGHT) / 2.0, RIGHT_COLUMN_WIDTH, LABEL_HEIGHT);
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleNone;
    textField.tag = TEXTFIELD_TAG;
    textField.font = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
    textField.textAlignment = UITextAlignmentLeft;
    textField.textColor = [UIColor blueColor];
    textField.returnKeyType = UIReturnKeyDone;
    [cell.contentView addSubview:textField];
    [textField release];
    
    return cell;
}

- (UIKeyboardType) determineKeyboardType {
    UIKeyboardType keyboardType = UIKeyboardTypeDefault;
    if ([keyboardType_ compare:@"Numeric"] == NSOrderedSame) {
        keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return keyboardType;
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // TODO: This is only handling implicit conversions from NSString. For example it fails for unsigned int type. Fix
    [delegate_ cellData:textField.text changedForHandler:self];
}


@end
