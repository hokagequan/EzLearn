//
//  UniversalUtil.m
//  EasyLSP
//
//  Created by Q on 15/6/26.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "UniversalUtil.h"

@implementation UniversalUtil

+ (CGPoint)convertToiPhonePointFrom:(CGPoint)point offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY {
    CGPoint iPhonePoint = CGPointMake(point.x / 2 + offsetX, point.y / 2 + offsetY);
    
    if (IS_WIDESCREEN) {
        return [self convertToWideScreenPointFrom:iPhonePoint];
    }
    
    return iPhonePoint;
}

+ (CGPoint)convertToWideScreenPointFrom:(CGPoint)point {
    return CGPointMake(point.x * [UIScreen mainScreen].bounds.size.width / 480.,
                       point.y * [UIScreen mainScreen].bounds.size.height / 320.);
}

+ (CGSize)convertToiPhoneSizeFrom:(CGSize)size {
    return CGSizeMake(size.width / 2, size.height / 2);
}

+ (CGFloat)iphoneSuitableValueFromIphone4:(CGFloat)iPhone4Value horizantal:(BOOL)isHorizantal {
    CGFloat rate = [UIScreen mainScreen].bounds.size.width / 480.;
    if (!isHorizantal) {
        rate = [UIScreen mainScreen].bounds.size.height / 320.;
    }
    
    return iPhone4Value * rate;
}

+ (NSString *)universalAtlasName:(NSString *)atlasName {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return atlasName;
    }
    
    return [NSString stringWithFormat:@"%@-iphone", atlasName];
}

+ (CGPoint)universaliPadPoint:(CGPoint)iPadPoint iPhonePoint:(CGPoint)iPhonePoint offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return iPadPoint;
    }
    
    if (!CGPointEqualToPoint(iPhonePoint, CGPOINT_NON)) {
        if (IS_WIDESCREEN) {
            return [self convertToWideScreenPointFrom:iPhonePoint];
        }
        
        return iPhonePoint;
    }
    
    return [self convertToiPhonePointFrom:iPadPoint offsetX:offsetX offsetY:offsetY];
}

+ (CGPoint)universalPointFromCenter:(CGPoint)center deltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY {
    CGFloat x = deltaX;
    CGFloat y = deltaY;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        x = x == 0 ? x : x / 2 - x * offsetX / fabs(x);
        y = y == 0 ? y : y / 2 - y * offsetY / fabs(y);
    }
    
    return CGPointMake(center.x + x, center.y + y);
}

+ (CGPoint)universalPointFromCenter:(CGPoint)center deltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY alliPhonesSuitable:(BOOL)suitable {
    if (!suitable) {
        return [self universalPointFromCenter:center deltaX:deltaX deltaY:deltaY offsetX:offsetX offsetY:offsetY];
    }
    
    CGFloat x = deltaX;
    CGFloat y = deltaY;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGFloat tempOffsetX = offsetX;
        CGFloat tempOffsetY = offsetY;
        if (IS_WIDESCREEN) {
            tempOffsetX = [self iphoneSuitableValueFromIphone4:tempOffsetX horizantal:YES];
            tempOffsetY = [self iphoneSuitableValueFromIphone4:tempOffsetY horizantal:NO];
            x = [self iphoneSuitableValueFromIphone4:x horizantal:YES];
            y = [self iphoneSuitableValueFromIphone4:y horizantal:NO];
        }
        x = x == 0 ? x : x / 2 - x * tempOffsetX / fabs(x);
        y = y == 0 ? y : y / 2 - y * tempOffsetY / fabs(y);
    }
    
    return CGPointMake(center.x + x, center.y + y);
}

+ (CGPoint)universaliPadPoint:(CGPoint)iPadPoint rateX:(CGFloat)rateX rateY:(CGFloat)rateY {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return iPadPoint;
    }
    
    return CGPointMake(iPadPoint.x * rateX, iPadPoint.y * rateY);
}

+ (CGSize)universaliPadSize:(CGSize)iPadSize iPhoneSize:(CGSize)iPhoneSize {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return iPadSize;
    }
    
    if (!CGSizeEqualToSize(iPhoneSize, CGSIZE_NON)) {
        return iPhoneSize;
    }
    
    return [self convertToiPhoneSizeFrom:iPadSize];
}

+ (CGFloat)universalFontSize:(CGFloat)fontSize {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return fontSize;
    }
    
    return fontSize / 2 - 2;
}

+ (CGFloat)universalDelta:(CGFloat)delta {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return delta;
    }
    
    return delta / 2;
}

+ (CGFloat)universalDelta:(CGFloat)delta horizantal:(BOOL)isHorizantal allIPhonesSuitable:(BOOL)suitable {
    CGFloat iPhoneDelta = [self universalDelta:delta];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && suitable && IS_WIDESCREEN) {
        return [self iphoneSuitableValueFromIphone4:iPhoneDelta horizantal:isHorizantal];
    }
    
    return iPhoneDelta;
}

@end
