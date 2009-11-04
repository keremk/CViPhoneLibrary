//
//  CVSettingsViewController.m
//  CVLibraryDemo
//
//  Created by Kerem Karatal on 7/2/09.
//  Copyright 2009 Coding Ventures. All rights reserved.
//

#import "CVSettingsViewController.h"

@implementation CVSettingsViewController
@synthesize delegate = delegate_;
@synthesize settingsData = settingsData_;

- (void)dealloc {
    [cellHandlers_ release];
    [sectionNames_ release];
    [super dealloc];
}

- (void) createCellHandlers {
    if (!cellHandlers_) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ConfigOptions" ofType:@"plist"];
        NSData *pListData = [NSData dataWithContentsOfFile:filePath];
        NSPropertyListFormat format;
        NSString *error;
        NSArray *configSections = (NSArray *) [NSPropertyListSerialization propertyListFromData:pListData 
																   mutabilityOption:NSPropertyListImmutable 
																			 format:&format
																   errorDescription:&error];
        if (!configSections) {
            // This is some catastrophic error
            // TODO: figure out what to do.
            NSLog(@"%@", error);
            [error release];
        } else {
            cellHandlers_ = [[NSMutableArray alloc] init];
            sectionNames_ = [[NSMutableArray alloc] init];

            for (NSInteger i = 0; i < [configSections count]; i++) {
                NSMutableArray *cellHandlerRows = [[NSMutableArray alloc] init];
                for (NSInteger j = 0; j < [[[configSections objectAtIndex:i] objectForKey:@"sectionOptions"] count]; j++) {
                    NSDictionary *cellConfig = [[[configSections objectAtIndex:i] 
                                                 objectForKey:@"sectionOptions"] 
                                                objectAtIndex:j];

                    Class cellHandlerClass = NSClassFromString([cellConfig objectForKey:@"cellHandlerClass"]);
                    id<CellHandler> cellHandler = [[cellHandlerClass alloc] init];
                    NSString *keyPath = [cellConfig objectForKey:@"keyPath"];
                    if (nil != keyPath) {
                        cellHandler.keyPath = [NSString stringWithFormat:@"settingsData.%@", keyPath];
                    }
                    cellHandler.label = [cellConfig objectForKey:@"label"];
                    cellHandler.identifier = [cellConfig objectForKey:@"identifier"];
                    NSString *optionsString;
                    if (optionsString = [cellConfig objectForKey:@"options"]) {
                        cellHandler.options = [optionsString componentsSeparatedByString:@","];
                    }
                    cellHandler.delegate = self;
                    NSString *converterClassName;
                    if (converterClassName = [cellConfig objectForKey:@"dataConverter"]) {
                        cellHandler.dataConverterClassName = converterClassName;
                    }
                    NSString *keyboardType;
                    if (keyboardType = [cellConfig objectForKey:@"keyboardType"]) {
                        cellHandler.keyboardType = keyboardType;
                    }
                    [cellHandlerRows addObject:cellHandler];
                    [cellHandler release];
                }
                [cellHandlers_ addObject:cellHandlerRows];
                [sectionNames_ addObject:[[configSections objectAtIndex:i] objectForKey:@"sectionName"]];
                [cellHandlerRows release];
            }
             
        }
                 
    }
}
/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

    [self.delegate configurationUpdatedForGridConfigViewController:self];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!cellHandlers_) {
        [self createCellHandlers];
    }
    return [cellHandlers_ count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!cellHandlers_) {
        [self createCellHandlers];
    }
    return [[cellHandlers_ objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<CellHandler> cellHandler = [[cellHandlers_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];    
    id data = [self valueForKeyPath:cellHandler.keyPath];
    UITableViewCell *cell = [cellHandler tableView:tableView cellForRowAtIndexPath:indexPath usingData:data];
        
    return cell;
}

- (id) valueForUndefinedKey:(NSString *) key {
    return nil;    
}

- (void) setValue:(id) value forUndefinedKey:(NSString *) key {
    // Do nothing - no exception raised
    NSLog(@"Undefined Key = %@", key);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<CellHandler> cellHandler = [[cellHandlers_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]; 
    
    if ([cellHandler respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:usingNavigationController:)]) {
        [cellHandler tableView:tableView didSelectRowAtIndexPath:indexPath usingNavigationController:[self navigationController]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) cellData:(id) data changedForHandler:(id<CellHandler>) handler {
    id convertedData = data;
    if ([handler respondsToSelector:@selector(dataConverterClassName)]) {
        Class converterClass = NSClassFromString(handler.dataConverterClassName);
        
        if (nil != converterClass) {
            id<DataConverter> dataConverter = [[converterClass alloc] init]; 
            convertedData = [dataConverter convertFromString:data];
            [dataConverter release];
        }
    }
    [self setValue:convertedData forKeyPath:handler.keyPath];
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!cellHandlers_) {
        [self createCellHandlers];
    }
    return [sectionNames_ objectAtIndex:section];
}


@end

