//
//  GlobalUtil.h
//  HappyStudy
//
//  Created by Quan on 14/10/25.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define POLAR_ADJUST(x) x + (M_PI * 0.5f)

@interface GlobalUtil : NSObject

+ (NSString *)randomCharacter;
+ (NSString *)stringWithNumber:(NSInteger)number;
+ (NSString *)levelKeyWith:(NSInteger)level;

+ (NSArray *)allShengMu;
+ (NSArray *)allYunMu;
+ (NSArray *)allZhengTi;
+ (NSArray *)loadFramesFromAtlas:(NSString *)atlasName baseFileName:(NSString *)baseFileName frameNum:(NSInteger)frameNum;

+ (CGPoint)centerInSize:(CGSize)size;

+ (NSUInteger)randomIntegerWithMax:(NSUInteger)maxIndex;

+ (void)randomArray:(NSMutableArray *)sourceArray;
+ (AVSpeechSynthesizer *)speakText:(NSString *)text;
+ (AVSpeechSynthesizer *)speakEnglishText:(NSString *)text;

+ (id)gameInfoWithKey:(NSString *)key;

+ (BOOL)isNetworkConnection;
+ (BOOL)soundFileExist:(NSString *)fileName;

CGFloat RadiansBetweenPoints(CGPoint first, CGPoint second);
CGFloat DistanceBetweenPoints(CGPoint first, CGPoint second);

@end
