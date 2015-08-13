//
//  UniversalUtil.h
//  EasyLSP
//
//  Created by Q on 15/6/26.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CGPOINT_NON CGPointMake(100000000, 1000000000)
#define CGSIZE_NON CGSizeMake(1000000000, 1000000000)

#define IS_WIDESCREEN ( [ [ UIScreen mainScreen ] bounds ].size.width > 480 )

@interface UniversalUtil : NSObject

+ (NSString *)universalAtlasName:(NSString *)atlasName;

// 如果iPhonePoint != CGPOINT_NON 进行默认的计算
+ (CGPoint)universaliPadPoint:(CGPoint)iPadPoint iPhonePoint:(CGPoint)iPhonePoint offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

// 适用于从中间开始计算的坐标
+ (CGPoint)universalPointFromCenter:(CGPoint)center deltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

// 是否按照iphone的尺寸来适配
+ (CGPoint)universalPointFromCenter:(CGPoint)center deltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY alliPhonesSuitable:(BOOL)suitable;

// 按照比例计算坐标
+ (CGPoint)universaliPadPoint:(CGPoint)iPadPoint rateX:(CGFloat)rateX rateY:(CGFloat)rateY;

// 如果iPhoneSize != CGSIZE_NON 进行默认的计算
+ (CGSize)universaliPadSize:(CGSize)iPadSize iPhoneSize:(CGSize)iPhoneSize;

+ (CGFloat)universalFontSize:(CGFloat)fontSize;

+ (CGFloat)universalDelta:(CGFloat)delta;

// 是否按照iphone的尺寸来适配
+ (CGFloat)universalDelta:(CGFloat)delta horizantal:(BOOL)isHorizantal allIPhonesSuitable:(BOOL)suitable;

@end
