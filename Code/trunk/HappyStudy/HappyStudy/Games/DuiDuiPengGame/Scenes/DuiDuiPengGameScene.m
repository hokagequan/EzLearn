//
//  DuiDuiPengGameScene.m
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "DuiDuiPengGameScene.h"
#import "GameSelectScene.h"
#import "GameSelectIndividualScene.h"
#import "HSButtonSprite.h"
#import "DDPPinYin.h"
#import "DDPHanZi.h"
#import "DDPMgr.h"
#import "AccountMgr.h"
#import "DDPGroupModel.h"
#import "PinYinModel.h"
#import "HanZiModel.h"
#import "GlobalUtil.h"
#import "DDPHttpReqMgr.h"
#import "AppDelegate.h"
#import "HSError.h"
#import "GlobalUtil.h"
#import "GameMgr.h"

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kBackButton @"backButton"

@interface DuiDuiPengGameScene ()

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *toDestroyCards;
@property (strong, nonatomic) NSMutableArray *selectCharacters;
@property (strong, nonatomic) NSMutableArray *cardPosistions;

@property (strong, nonatomic) SKTexture *bubbleTexture;
@property (nonatomic) NSInteger count;

@end

@implementation DuiDuiPengGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _cards = [[NSMutableArray alloc] init];
        _toDestroyCards = [[NSMutableArray alloc] init];
        _selectCharacters = [[NSMutableArray alloc] init];
        _cardPosistions = [@[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8)] mutableCopy];
        self.scrollWorld = YES;
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Environment"]];
        self.bubbleTexture = [atlas textureNamed:@"bubble"];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    self.pageCount = [DDPMgr sharedInstance].models.count;
    [self buildWorld];
    [self playBackgroundMusic];
    [self spawnStars];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
}

- (void)addBackground {
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"duiduipent_game_bg"];
    bgNode.anchorPoint = CGPointZero;
    bgNode.position = CGPointZero;
    bgNode.size = self.size;
    [self addNode:bgNode atWorldLayer:HSSWorldLayerGround];
}

- (void)addEnvironment {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"DDPFlower"]];
    SKSpriteNode *flower = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"ddpflower_0001"]];
    flower.size = CGSizeMake(self.size.width, flower.size.height);
    flower.anchorPoint = CGPointZero;
    flower.position = CGPointMake(0, 0);
    flower.zPosition = 100;
    [self addNode:flower atWorldLayer:HSSWorldLayerGround];
    
    SKAction *action = [SKAction animateWithTextures:flowerAnimationFrames
                                        timePerFrame:1 / 5.
                                              resize:NO
                                             restore:NO];
    [flower runAction:[SKAction repeatActionForever:action]];
}

- (void)addControllers {
    HSButtonSprite *leftNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"pre_page_nor"
                                                            selImage:@"pre_page_sel"];
    leftNode.position = [UniversalUtil universaliPadPoint:CGPointMake(832, 102)
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:-30
                                                  offsetY:-20];
    leftNode.name = kLeftButton;
    leftNode.zPosition = zPostionFront;
    [self addNode:leftNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:leftNode];
    
    HSButtonSprite *rightNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                             norImage:@"next_page_nor"
                                                             selImage:@"next_page_sel"];
    rightNode.position = [UniversalUtil universaliPadPoint:CGPointMake(962, 102)
                                               iPhonePoint:CGPOINT_NON
                                                   offsetX:-30
                                                   offsetY:-20];
    rightNode.name = kRightButton;
    rightNode.zPosition = zPostionFront;
    [self addNode:rightNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:rightNode];
    
    HSButtonSprite *backNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"back_nor"
                                                            selImage:@"back_sel"];
    backNode.position = [UniversalUtil universaliPadPoint:CGPointMake(705, 102)
                                              iPhonePoint:CGPointMake(332, 31)
                                                  offsetX:-30
                                                  offsetY:-20];
    backNode.name = kBackButton;
    backNode.zPosition = zPostionFront;
    [self addNode:backNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:backNode];
}

- (void)addStar {
    // 随即大小
    CGFloat standardSize = 20.;
    int minScale = 1.0 * standardSize;
    int maxScale = 2.0 * standardSize;
    int randomScale = (arc4random() % (maxScale - minScale)) + minScale;
    // 随即位置
    int minX = randomScale / 2;
    int maxX = self.size.width - randomScale / 2;
    int randomX = (arc4random() % (maxX - minX)) + minX;
    // 随即时间
    int minDuration = 3;
    int maxDuration = 6;
    int randomDuration = (arc4random() % (maxDuration - minDuration)) + minDuration;
    
    SKSpriteNode *star = [SKSpriteNode spriteNodeWithTexture:self.bubbleTexture
                                                        size:CGSizeMake(randomScale, randomScale)];
    star.position = CGPointMake(randomX, -(randomScale + 50));
    star.zPosition = 200;
    [self addNode:star atWorldLayer:HSSWorldLayerGround];
    
    SKAction *rotateOnceAction = [SKAction rotateByAngle:2 * M_PI duration:1.];
    SKAction *rotateAction = [SKAction repeatActionForever:rotateOnceAction];
    [star runAction:rotateAction];
    SKAction *moveAction = [SKAction moveByX:0. y:self.size.height + 50 + randomScale duration:randomDuration];
    SKAction *doneAction = [SKAction runBlock:^{
        [star removeFromParent];
    }];
    
    [star runAction:[SKAction sequence:@[moveAction, doneAction]]];
}

- (void)buildWorld {
    [self addBackground];
    [self addEnvironment];
    [self addControllers];
    [self addCharacters:0];
}

- (void)checkMatch {
    if (self.selectCharacters.count < 2) {
        return;
    }
    
    DDPCharacter *character1 = self.selectCharacters[0];
    DDPCharacter *character2 = self.selectCharacters[1];
    if ([character1.matchKey isEqualToString:character2.matchKey]) {
        // Match
        [self playSoundCorrect];
        character1.requestedAnimation = HSAnimationStateDeath;
        character2.requestedAnimation = HSAnimationStateDeath;
        [self.selectCharacters removeAllObjects];
    }
    else {
        // Not match
        [self playSoundWrong];
        character1.selected = NO;
        character2.selected = NO;
        [self.selectCharacters removeAllObjects];
    }
}

- (void)playBackgroundMusic {
    [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"duiduipeng_game_bg.mp3"];
}

- (void)playSound:(NSString *)soundName {
    if (!soundName || ![GlobalUtil soundFileExist:soundName]) {
        return;
    }
    
    [self runAction:[SKAction playSoundFileNamed:soundName waitForCompletion:YES]];
}

- (CGPoint)positionWithIndex:(NSInteger)index {
    if (index >= self.cardPosistions.count) {
        return CGPointZero;
    }
    NSInteger pos = [self.cardPosistions[index] integerValue];
    NSInteger row = (pos - 1) / 4;
    NSInteger column = (pos - 1) % 4;
    
    return CGPointMake(226 + column * 194, 272 + row * 214);
}

- (void)removeCharacter:(DDPCharacter *)character {
    if ([self.cards containsObject:character]) {
        [self.cards removeObject:character];
    }
    
    if (self.cards.count == 0) {
        [self animationCorrect:nil];
        
        DDPGroupModel *gModel = [DDPMgr sharedInstance].models[self.curIndex];
        NSMutableArray *options = [NSMutableArray array];
        for (PinYinModel *option in gModel.pyModels) {
            [options addObject:option.title];
        }
        for (HanZiModel *option in gModel.hzModels) {
            [options addObject:option.title];
        }
        [self.gameMgr correct:[NSString stringWithFormat:@"%ld", (long)gModel.modelID] options:options];
        
        if (self.curIndex == [DDPMgr sharedInstance].models.count - 1) {
            if ([DDPMgr sharedInstance].curGroupCount > 0) {
                [self clickRight:nil];
            }
            else {
                [self finishAll];
            }
            
            return;
        }
        
        self.userInteractionEnabled = NO;
        [self performSelector:@selector(next) withObject:nil afterDelay:GAME_INTERVAL];
    }
}

- (void)spawnStars {
    SKAction *addAction = [SKAction runBlock:^{
        [self addStar];
    }];
    SKAction *waitAction = [SKAction waitForDuration:1.5];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[addAction, waitAction]]]];
}

+ (void)loadEnvironmentAssets {
    flowerAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"DDPFlower"]
                                               baseFileName:@"ddpflower_"
                                                   frameNum:3];
}

#pragma mark - Override
+ (void)loadSceneAssets {
    [DDPPinYin loadAssets];
    [DDPHanZi loadAssets];
    [self loadEnvironmentAssets];
}

+ (void)releaseSceneAssets {
    flowerAnimationFrames = nil;
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (fromPos == 0) {
        [[DDPMgr sharedInstance].models removeAllObjects];
    }
    
    [DDPHttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                                 from:fromPos
                                count:count
                           completion:^(NSDictionary *info) {
                               if ([DDPMgr sharedInstance].models.count == 0) {
                                   if (failure) {
                                       HSError *error = [HSError errorWith:HSHttpErrorCodeNoData];
                                       failure(@{@"error": error});
                                   }
                               }
                               else {
                                   if (complete) {
                                       complete();
                                   }
                               }
                           } failure:^(HSError *error) {
                               if (failure) {
                                   NSDictionary *dict;
                                   if (error.message) {
                                       dict = @{@"code": @(error.code), @"message": error.message};
                                   }
                                   failure(dict);
                               }
                           }];
}

- (void)addCharacters:(NSInteger)index {
    [self.selectCharacters removeAllObjects];
    
    if (self.cards.count > 0) {
        [self.toDestroyCards addObjectsFromArray:self.cards];
        [self.cards removeAllObjects];
    }
    
    if ([DDPMgr sharedInstance].models.count == 0 ||
        [DDPMgr sharedInstance].models.count <= index) {
        return;
    }
    
    [GlobalUtil randomArray:self.cardPosistions];
    NSInteger posIndex = 0;
    DDPGroupModel *groupModel = [DDPMgr sharedInstance].models[index];
    for (PinYinModel *pinyin in groupModel.pyModels) {
        CGPoint pos = [UniversalUtil universaliPadPoint:[self positionWithIndex:posIndex]
                                            iPhonePoint:CGPOINT_NON
                                                offsetX:0
                                                offsetY:-40];
        DDPPinYin *pinyinNode = [[DDPPinYin alloc] initWithString:pinyin.title
                                                        soundName:pinyin.soundName
                                                         matchKey:pinyin.matchKey
                                                         position:CGPointMake(pos.x + index * self.size.width,
                                                                              pos.y)];
        pinyinNode.label.fontName = FONT_NAME_AM;
        [self addNode:pinyinNode atWorldLayer:HSSWorldLayerCharacter];
        [self.cards addObject:pinyinNode];
        posIndex++;
    }
    for (HanZiModel *hanzi in groupModel.hzModels) {
        CGPoint pos = [UniversalUtil universaliPadPoint:[self positionWithIndex:posIndex]
                                            iPhonePoint:CGPOINT_NON
                                                offsetX:0
                                                offsetY:-40];
        DDPHanZi *hanziNode = [[DDPHanZi alloc] initWithString:hanzi.title
                                                     soundName:hanzi.soundName
                                                      matchKey:hanzi.matchKey
                                                      position:CGPointMake(pos.x + index * self.size.width,
                                                                           pos.y)];
        hanziNode.label.fontName = FONT_NAME_CUTOON;
        [self addNode:hanziNode atWorldLayer:HSSWorldLayerCharacter];
        [self.cards addObject:hanziNode];
        posIndex++;
    }
}

- (void)destroyCharacters {
    if (self.toDestroyCards.count > 0) {
        for (SKNode *node in self.toDestroyCards) {
            [node removeFromParent];
        }
        [self.toDestroyCards removeAllObjects];
    }
}

- (NSString *)indexStringWith:(NSInteger)index {
    DDPGroupModel *model = [DDPMgr sharedInstance].models[index];
    return model.indexStr;
}

- (NSInteger)currentTotalCount {
    return [DDPMgr sharedInstance].models.count;
}

- (void)loadMore {
    if ([DDPMgr sharedInstance].curGroupCount > 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [self loadGameDataFrom:[DDPMgr sharedInstance].curGroupCount - 1
                         count:1000
                      Complete:^{
                          [SVProgressHUD dismiss];
                          [self expandIndexController];
                          //                                         self.curIndex++;
                      } failure:^(NSDictionary *info) {
                          [SVProgressHUD dismiss];
                      }];
    }
}

- (void)loadGameMgr {
    self.gameMgr = [DDPMgr sharedInstance];
}

- (void)next {
    self.userInteractionEnabled = YES;
    self.curIndex++;
}

#pragma mark - Actions
- (void)clickBack:(id)sender {
    [[DDPMgr sharedInstance].models removeAllObjects];
    
    if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
        GameSelectIndividualScene *scene = [[GameSelectIndividualScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    }
    else if ([GameMgr sharedInstance].gameGroup == GroupSchool) {
        GameSelectScene *scene = [[GameSelectScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    }
}

- (void)clickLeft:(id)sender {
    NSInteger index = self.curIndex;
    index--;
    if (index < 0) {
        index = 0;
    }
    
    self.curIndex = index;
}

- (void)clickRight:(id)sender {
    NSInteger index = self.curIndex;
    index++;
    if (index > [DDPMgr sharedInstance].models.count - 1) {
        if ([DDPMgr sharedInstance].curGroupCount > 0) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [self loadGameDataFrom:[DDPMgr sharedInstance].curGroupCount - 1
                             count:1000
                          Complete:^{
                              [SVProgressHUD dismiss];
                              [self expandIndexController];
                              self.curIndex = index;
                          } failure:^(NSDictionary *info) {
                              [SVProgressHUD dismiss];
                          }];
            return;
        }
        else {
            index = [DDPMgr sharedInstance].models.count - 1;
        }
    }
    
    self.curIndex = index;
}

- (void)clickCharacter:(DDPCharacter *)character {
    [self playSound:@"click_card.wav"];
    
    self.gameMgr.clickCount++;
    
    character.selected = YES;
    if (![self.selectCharacters containsObject:character]) {
        [self.selectCharacters addObject:character];
        [self checkMatch];
    }
}

#pragma mark - Loop
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    for (DDPCharacter *character in self.cards) {
        [character updateWithTimeSinceLastUpdate:interval];
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:loc];
    NSString *buttonName = node.name;
    [self setButtonSelectState:buttonName];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:loc];
    if ([node.name isEqualToString:kLeftButton]) {
        [self clickLeft:node];
    }
    else if ([node.name isEqualToString:kRightButton]) {
        [self clickRight:node];
    }
    else if ([node.name isEqualToString:kBackButton]) {
        [self clickBack:node];
    }
    
    [self setButtonSelectState:nil];
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Animations
static NSArray *flowerAnimationFrames = nil;
- (NSArray *)flowerAnimationFrames {
    return flowerAnimationFrames;
}

@end
