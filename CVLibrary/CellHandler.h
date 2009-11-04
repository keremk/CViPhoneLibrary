/*
 *  CellHandler.h
 *  CVLibraryDemo
 *
 *  Created by Kerem Karatal on 7/12/09.
 *  Copyright 2009 Coding Ventures. All rights reserved.
 *
 */
@protocol CellHandler;

@protocol CellHandlerDelegate<NSObject>
@required
- (void) cellData:(id) data changedForHandler:(id<CellHandler>) handler;

@end


@protocol CellHandler<NSObject>
@required
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath usingData:(id) data;

@property (assign) id<CellHandlerDelegate> delegate;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) NSString *identifier;

@optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
                        usingNavigationController:(UINavigationController *) navController;
@property (nonatomic, retain) NSArray *options;
@property (nonatomic, copy) NSString *dataConverterClassName;
@property (nonatomic, copy) NSString *keyboardType;
@end

@protocol DataConverter<NSObject>
@required
- (id) convertFromString:(NSString *) input;
- (NSString *) convertToString:(id) input;
@end
