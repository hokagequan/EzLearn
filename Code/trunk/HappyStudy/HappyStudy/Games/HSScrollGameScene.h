//
//  HSScrollGameScene.h
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSGameScene.h"
#import "SubGameMgr.h"

typedef enum {
    HSSWorldLayerGround = 0,
    HSSWorldLayerSky = 100,
    HSSWorldLayerCharacter = 200,
    HSSWorldLayerControl = 300,
    HSSWorldLayerCount
}HSSWorldLayer;

typedef NS_ENUM(NSInteger, zPostion) {
    zPostionBackground = 0,
    zPostionHoleBehind = 100,
    zPostionCharacter = 200,
    zPostionFront = 300
};

@interface HSScrollGameScene : HSGameScene<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *uikitContainer;
@property (strong, nonatomic) UICollectionView *indexController;
@property (strong, nonatomic) UIButton *heart;

@property (strong, nonatomic) SubGameMgr *gameMgr;

@property (nonatomic) NSInteger pageCount;
@property (nonatomic) NSInteger curIndex;
@property (nonatomic) BOOL scrollWorld;

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval;

- (void)addIndexController;
- (void)setIndexControllerFocusOldIndex:(NSIndexPath *)oldIndex currentIndex:(NSIndexPath *)currentIndex;
- (void)showMask:(BOOL)show;

- (void)addNode:(SKNode *)node atWorldLayer:(HSSWorldLayer)layer;
- (SKNode *)layerWith:(HSSWorldLayer)layerID;
- (void)animationCorrect:(SKNode *)node;
- (void)playSoundWrong;
- (void)playSoundCorrect;
- (void)expandIndexController;
- (void)startFromBegain;
- (void)finishAll;

- (void)clickBack:(id)sender;
- (void)addCharacters:(NSInteger)index;
- (void)destroyCharacters;
- (NSString *)indexStringWith:(NSInteger)index;
- (void)refreshScore:(NSInteger)score;
- (NSInteger)currentTotalCount;
- (void)loadMore;
- (void)next;
- (void)clickLeft:(id)sender;
- (void)clickRight:(id)sender;
- (void)loadGameMgr;
- (void)gameOver;

@end
