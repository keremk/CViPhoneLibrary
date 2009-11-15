/*
 *  CVStyleProtocols.h
 *  CVLibrary
 *
 *  Created by Kerem Karatal on 8/10/09.
 *  Copyright 2009 Coding Ventures. All rights reserved.
 *
 */

@protocol CVRenderStyle<NSObject>
@required
// Image size is the requested resized image size 
- (void) drawInContext:(CGContextRef) context forImageSize:(CGSize) imageSize; 
- (CGSize) sizeRequiredForRendering;
@end

@protocol CVRenderPath
@required
- (void) addShapeToPath:(CGMutablePathRef) path boundedByRect:(CGRect) rect;
@end

@protocol CVBorderStyle<CVRenderStyle> 
@required
@property (nonatomic, retain) UIColor *color;
@property (nonatomic) CGFloat width;
@end