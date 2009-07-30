/*
 *  CGUtils.h
 *  CVLibrary
 *
 *  Created by Kerem Karatal on 5/16/09.
 *  Copyright 2009 Coding Ventures. All rights reserved.
 *
 */

#ifndef CGUTILS_H_
#define CGUTILS_H_

#include <CoreGraphics/CoreGraphics.h>
#include <math.h>

static inline double radians (double degrees) {return degrees * M_PI/180;}

void CVAddRoundedRectToPath(CGContextRef context, CGRect rect, CGFloat ovalWidth, CGFloat ovalHeight);
void CVPathAddRoundedRect(CGMutablePathRef path, CGRect rect, CGFloat ovalWidth, CGFloat ovalHeight);

#endif