//
//  EnumCellHandler.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/13/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "EnumCellHandler.h"


@interface EnumCellHandler()
- (UITableViewCell *) tableViewCellWithReuseIdentifier:(NSString *) identifier;
@end


@implementation EnumCellHandler
@synthesize delegate = delegate_;
@synthesize label = label_;
@synthesize keyPath = keyPath_;
@synthesize identifier = identifier_;
@synthesize options = options_;
@synthesize dataConverterClassName = dataConverterClassName_;

- (void) dealloc {
    [label_ release];
    [keyPath_ release];
    [identifier_ release];
    [options_ release];
    [dataConverterClassName_ release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        selectedOptionIndex_ = 0;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath usingData:(id) data {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_];
    if (cell == nil) {
        cell = [self tableViewCellWithReuseIdentifier:identifier_];
    }
    
    cell.textLabel.text = label_;
    cell.detailTextLabel.text = [options_ objectAtIndex:selectedOptionIndex_];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
                            usingNavigationController:(UINavigationController *) navController{
    EnumOptionsViewController *optionsViewController = [[EnumOptionsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    optionsViewController.options = options_;
    optionsViewController.delegate = self;
    optionsViewController.selectedIndex = selectedOptionIndex_;
    [navController pushViewController:optionsViewController animated:YES];
    [optionsViewController release];
}


- (UITableViewCell *) tableViewCellWithReuseIdentifier:(NSString *) identifier {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark OptionSelectionChangedDelegate methods

- (void) selectionChangedToOptionIndex:(NSUInteger) index {
    NSString *selection = [options_ objectAtIndex:index];
    
    selectedOptionIndex_ = index;
    [delegate_ cellData:selection changedForHandler:self];
}

@end
