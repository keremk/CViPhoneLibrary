//
//  BoolCellHandler.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/26/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "BoolCellHandler.h"

@interface BoolCellHandler()
- (UITableViewCell *) tableView:(UITableView *) tableView cellWithReuseIdentifier:(NSString *) identifier;
- (IBAction) switchControlChanged:(id) sender;
@end

@implementation BoolCellHandler
@synthesize delegate = delegate_;
@synthesize label = label_;
@synthesize keyPath = keyPath_;
@synthesize identifier = identifier_;

- (void) dealloc {
    [label_ release];
    [keyPath_ release];
    [identifier_ release];
    [super dealloc];
}

#define LABEL_TAG 1
#define SWITCH_TAG 2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath usingData:(id) data {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_];
    if (nil == cell) {
        cell = [self tableView:tableView cellWithReuseIdentifier:identifier_];
    }
    
    UISwitch *switchControl = (UISwitch *) [cell viewWithTag:SWITCH_TAG];
    if (nil == data) {
        switchControl.on = YES;
    } else if ([data isKindOfClass:[NSNumber class]]) {
        switchControl.on = [data boolValue];
    }

    UILabel *labelField = (UILabel *) [cell viewWithTag:LABEL_TAG];
    labelField.text = label_;

    return cell;
}

#define LEFT_COLUMN_OFFSET 10.0
#define LEFT_COLUMN_WIDTH 160.0

#define RIGHT_COLUMN_OFFSET 150.0
#define RIGHT_COLUMN_WIDTH 80.0

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
    UISwitch *switchControl = [[UISwitch alloc] initWithFrame:frame];
    switchControl.tag = SWITCH_TAG;
    switchControl.on = YES;
    [switchControl addTarget:self action:@selector(switchControlChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:switchControl];
    [switchControl release];
    
    return cell;
}

- (IBAction) switchControlChanged:(id) sender {
    UISwitch *switchControl = (UISwitch *) sender;
    
    BOOL controlState = switchControl.on;
    NSNumber *packedValue = [NSNumber numberWithBool:controlState];
    [delegate_ cellData:packedValue changedForHandler:self];
}

@end
