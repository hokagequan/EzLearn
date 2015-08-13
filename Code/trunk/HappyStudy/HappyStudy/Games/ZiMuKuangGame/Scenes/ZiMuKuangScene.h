//
//  DaDiShuScene.h
//  EasyLSP
//
//  Created by Q on 15/4/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "HSScrollGameScene.h"
#import "ZMKMgr.h"
#import "ZMKBasket.h"

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kBackButton @"backButton"

#define DROPPING_ANIMATION @"dropping_animation"

@interface ZiMuKuangScene : HSScrollGameScene

@property (strong, nonatomic) HSLabelSprite *fruit;
@property (strong, nonatomic) ZMKBasket *basket;

@property (strong, nonatomic) ZMKMgr *myGameMgr;

@property (strong, nonatomic) NSMutableArray *characters;
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) CGFloat droppingDuration;

- (void)addControllers;
- (void)changeLifeWith:(NSInteger)life;
- (void)dropFruitFrom:(CGPoint)position text:(NSString *)text duration:(CGFloat)duration;
- (BOOL)isFruitDropping;
- (void)buildWorld;
- (void)addFruitToBasket:(HSLabelSprite *)fruit;
- (void)removeFruitFromBasket;
- (void)cleanBasketFruits;
- (void)resetFruit;

@end
