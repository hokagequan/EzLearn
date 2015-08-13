//
//  GlobalUtil.m
//  HappyStudy
//
//  Created by Quan on 14/10/25.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "GlobalUtil.h"
#import "Reachability.h"

@implementation GlobalUtil

+ (NSArray *)allShengMu {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Letters" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return dict[@"shengmu"];
//    return @[@"b", @"p", @"m", @"f", @"d", @"t", @"n", @"l", @"g", @"k", @"h", @"j", @"q", @"x", @"zh", @"ch", @"sh", @"r", @"z", @"c", @"s", @"y", @"w"];
}

+ (NSArray *)allYunMu {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Letters" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return dict[@"yunmu"];
//    return @[@"a", @"o", @"e", @"i", @"u", @"ü", @"ai", @"ei", @"ui", @"ao", @"ou", @"iu", @"ie", @"üe", @"er", @"an", @"en", @"in", @"un", @"ün", @"ang", @"eng", @"ing", @"ong"];
}

+ (NSArray *)allZhengTi {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Letters" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return dict[@"zhengtirendu"];
//    return @[@"zhi", @"chi", @"shi", @"ri", @"zi", @"ci", @"si", @"yi", @"wu", @"yu", @"ye", @"yue", @"yuan", @"yin", @"yun", @"ying"];
}

+ (CGPoint)centerInSize:(CGSize)size {
    return CGPointMake(size.width / 2, size.height / 2);
}

+ (id)gameInfoWithKey:(NSString *)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GameInfo" ofType:@"plist"];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return info[key];
}

+ (BOOL)isNetworkConnection {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    return networkStatus != NotReachable;
}

+ (NSArray *)loadFramesFromAtlas:(NSString *)atlasName baseFileName:(NSString *)baseFileName frameNum:(NSInteger)frameNum {
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:frameNum];
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    for (int i = 1; i <= frameNum; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%04d.png", baseFileName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        [frames addObject:texture];
    }
    
    return frames;
}

+ (NSString *)levelKeyWith:(NSInteger)level {
    switch (level) {
        case 0:
            return @"k1";
        case 1:
            return @"k2";
        case 2:
            return @"p1";
        case 3:
            return @"p2";
        default:
            break;
    }
    
    return @"hard";
}

+ (NSString *)randomCharacter {
    return [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a'];
}

+ (void)randomArray:(NSMutableArray *)sourceArray {
    for (int i = 0; i < sourceArray.count; i++) {
        int randomIndex = arc4random() % sourceArray.count;
        id obj1 = sourceArray[randomIndex];
        id obj2 = sourceArray[i];
        sourceArray[randomIndex] = obj2;
        sourceArray[i] = obj1;
    }
}

+ (NSUInteger)randomIntegerWithMax:(NSUInteger)maxIndex {
    return arc4random_uniform(maxIndex - 1);
}

+ (BOOL)soundFileExist:(NSString *)fileName {
    NSString *name = nil;
    NSString *ext = nil;
    [self splitFileName:fileName toName:&name toExt:&ext];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    
    return path != nil;
}

+ (void)splitFileName:(NSString *)fileName toName:(NSString **)name toExt:(NSString **)ext {
    if (!fileName) {
        return;
    }
    
    *name = [fileName stringByDeletingPathExtension];
    *ext = [fileName pathExtension];
}

+ (NSString *)stringWithNumber:(NSInteger)number {
    return [NSString stringWithFormat:@"%ld", (long)number];
}

+ (AVSpeechSynthesizer *)speakText:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    [synth speakUtterance:utterance];
    
    return synth;
}

+ (AVSpeechSynthesizer *)speakEnglishText:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.rate = 0.3;
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    [synth speakUtterance:utterance];
    
    return synth;
}

#pragma mark - C Method
CGFloat RadiansBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return atan2f(deltaY, deltaX);
}

CGFloat DistanceBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

@end
