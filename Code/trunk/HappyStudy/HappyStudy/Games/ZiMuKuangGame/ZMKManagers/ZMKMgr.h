//
//  DDSMgr.h
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubGameMgr.h"
#import "HSLabelSprite.h"

#define ORIGINAL_DROPPING_TIME 3.4
#define MIN_DROPPING_TIME 1.5

@class ZiMuKuangScene;

typedef NS_ENUM(uint8_t, ZMKColliderType) {
    ZMKColliderTypeBasket       = 1,
    ZMKColliderTypeFruit        = 2
};

typedef enum {
    ZMKGameStatStart = 0,
    ZMKGameStatEnd,
}ZMKGameStat;

#define ZMK_PASS_COUNT 2

@interface ZMKMgr : SubGameMgr

@property (weak, nonatomic) ZiMuKuangScene *gameScene;

@property (nonatomic) ZMKGameStat stat;
@property (nonatomic) NSInteger basketFruitNumber;
@property (nonatomic) NSInteger life;

// 字母筐
- (void)loadServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadLocalGameData;

// 拼字筐
- (void)loadPinZiKuangServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiKuangServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiKuangIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiKuangIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiKuangLocalGameData;

- (CGPoint)randomPosition;
- (NSString *)characterInFruit;

- (void)checkNode:(HSLabelSprite *)nodeA with:(HSLabelSprite *)nodeB;
- (void)gameLogic:(NSTimeInterval)interval;
- (void)correct;
- (void)wrong;
- (void)goNext;
- (CGFloat)caculateStayTimeWith:(NSInteger)index;

@end
