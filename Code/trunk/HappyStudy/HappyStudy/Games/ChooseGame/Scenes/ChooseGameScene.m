//
//  ChooseGameScene.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "ChooseGameScene.h"
#import "GameSelectScene.h"
#import "GameSelectIndividualScene.h"
#import "HSButtonSprite.h"
#import "CGQuestion.h"
#import "CGBallonBlue.h"
#import "CGBallonYellow.h"
#import "CGBallonGreen.h"
#import "CGBallonRed.h"
#import "CGMgr.h"
#import "AccountMgr.h"
#import "CGHttpReqMgr.h"
#import "GameMgr.h"
#import "AppDelegate.h"


@interface ChooseGameScene ()

@end

@implementation ChooseGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _optionCharacters = [[NSMutableArray alloc] init];
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Environment"]];
        self.bubbleTexture = [atlas textureNamed:@"bubble"];
        
        NSValue *ballonPos1 = [NSValue valueWithCGPoint:CGPointMake(426, 230)];
        NSValue *ballonPos2 = [NSValue valueWithCGPoint:CGPointMake(592, 230)];
        NSValue *ballonPos3 = [NSValue valueWithCGPoint:CGPointMake(796, 230)];
        NSValue *ballonPos4 = [NSValue valueWithCGPoint:CGPointMake(898, 230)];
        _optionPositions = [[NSArray alloc] initWithObjects:
                            ballonPos1,
                            ballonPos2,
                            ballonPos3,
                            ballonPos4, nil];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    self.pageCount = self.myGameMgr.models.count;
    
    [self buildWorld];
    [self playBackgroundMusic];
    [self startAnimations];
    [self spawnStars];
}

- (void)willMoveFromView:(SKView *)view {
    [self.myGameMgr.models removeAllObjects];
    
    [super willMoveFromView:view];
}

- (void)addBackground {
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"choose_game_bg"];
    bgNode.anchorPoint = CGPointZero;
    bgNode.position = CGPointZero;
    bgNode.size = self.size;
    [self addNode:bgNode atWorldLayer:HSSWorldLayerGround];
}

- (void)addEnvironment {
    _farCloud = [SKSpriteNode spriteNodeWithImageNamed:@"game_sel_cloud_far"];
    _farCloud.position = [UniversalUtil universaliPadPoint:CGPointMake(self.size.width / 2 + 380, 700)
                                               iPhonePoint:CGPointMake(self.size.width / 2 + 180, 310)
                                                   offsetX:0
                                                   offsetY:0];
    [self addNode:_farCloud atWorldLayer:HSSWorldLayerSky];
    
    _nearCloud = [SKSpriteNode spriteNodeWithImageNamed:@"game_sel_cloud_near"];
    _nearCloud.position = [UniversalUtil universaliPadPoint:CGPointMake(self.size.width / 2, 680)
                                                iPhonePoint:CGPointMake(self.size.width / 2, 300)
                                                    offsetX:0
                                                    offsetY:0];
    [self addNode:_nearCloud atWorldLayer:HSSWorldLayerSky];
}

- (void)addControllers {
    HSButtonSprite *leftNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"pre_page_nor"
                                                            selImage:@"pre_page_sel"];
    leftNode.position = [UniversalUtil universaliPadPoint:CGPointMake(765, 102)
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:-30
                                                  offsetY:0];
    leftNode.name = kLeftButton;
    [self addNode:leftNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:leftNode];
    
    HSButtonSprite *rightNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                             norImage:@"next_page_nor"
                                                             selImage:@"next_page_sel"];
    rightNode.position = [UniversalUtil universaliPadPoint:CGPointMake(896, 102)
                                               iPhonePoint:CGPOINT_NON
                                                   offsetX:-30
                                                   offsetY:0];
    rightNode.name = kRightButton;
    [self addNode:rightNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:rightNode];
    
    HSButtonSprite *backNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"back_nor"
                                                            selImage:@"back_sel"];
    backNode.position = [UniversalUtil universaliPadPoint:CGPointMake(280, 102)
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:-30
                                                  offsetY:0];
    backNode.name = kBackButton;
    [self addNode:backNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:backNode];
    
    HSButtonSprite *soundNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                             norImage:@"sound_nor"
                                                             selImage:@"sound_sel"];
    soundNode.position = [UniversalUtil universaliPadPoint:CGPointMake(98, 308)
                                               iPhonePoint:CGPOINT_NON
                                                   offsetX:0
                                                   offsetY:-16];
    soundNode.name = kSoundButton;
    [self addNode:soundNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:soundNode];
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

- (Class)ballonClass:(NSInteger)index {
    switch (index) {
        case 0:
            return [CGBallonBlue class];
        case 1:
            return [CGBallonYellow class];
        case 2:
            return [CGBallonGreen class];
        case 3:
            return [CGBallonRed class];
            
        default:
            break;
    }
    
    return [CGOption class];
}

- (void)buildWorld {
    [self addBackground];
    [self addEnvironment];
    [self addCharacters:0];
    [self addControllers];
}

- (void)chooseCorrect:(CGOption *)optionSp {
    CGChooseModel *cModel = self.myGameMgr.models[self.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (CGOptionModel *option in cModel.options) {
        [options addObject:option.title];
    }
    [self.gameMgr correct:[NSString stringWithFormat:@"%ld", (long)cModel.modelID] options:options];
    
    if ([self.optionCharacters containsObject:optionSp]) {
        [self.optionCharacters removeObject:optionSp];
    }
#ifdef EZLEARN_DEBUG
#else
    [self playSoundCorrect];
#endif
    [self animationCorrect:optionSp];
}

- (void)chooseWrong:(CGOption *)option {
    CGChooseModel *cModel = self.myGameMgr.models[self.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (CGOptionModel *option in cModel.options) {
        [options addObject:option.title];
    }
    [self.gameMgr wrong:[NSString stringWithFormat:@"%ld", (long)cModel.modelID] options:options];
    
#ifdef EZLEARN_DEBUG
#else
    [self playSoundWrong];
#endif
    [option animationWrong];
}

- (void)playBackgroundMusic {
    [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"choose_game_bg.mp3"];
}

- (void)playSound:(CGQuestion *)questionSp {
    [questionSp playSound];
}

- (void)startAnimations {
    [self startEnvironmentAnimations];
}

- (void)startEnvironmentAnimations {
    SKAction *nearMove = [SKAction moveByX:-(self.size.width + 2 * self.nearCloud.size.width) y:0 duration:15];
    SKAction *nearDone = [SKAction runBlock:^{
        self.nearCloud.position = CGPointMake(self.size.width + self.nearCloud.size.width,
                                              self.nearCloud.position.y);
    }];
    SKAction *nearAction = [SKAction sequence:@[nearMove, nearDone]];
    [self.nearCloud runAction:[SKAction repeatActionForever:nearAction]];
    
    SKAction *farMove = [SKAction moveByX:-(self.size.width + 2 * self.farCloud.size.width) y:0 duration:20];
    SKAction *farDone = [SKAction runBlock:^{
        self.farCloud.position = CGPointMake(self.size.width + self.farCloud.size.width,
                                             self.farCloud.position.y);
    }];
    SKAction *farAction = [SKAction sequence:@[farMove, farDone]];
    [self.farCloud runAction:[SKAction repeatActionForever:farAction]];
}

- (void)spawnStars {
    SKAction *addAction = [SKAction runBlock:^{
        [self addStar];
    }];
    SKAction *waitAction = [SKAction waitForDuration:1.5];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[addAction, waitAction]]]];
}

#pragma mark - Override
+ (void)loadSceneAssets {
    [CGBallonBlue loadAssets];
    [CGBallonYellow loadAssets];
    [CGBallonGreen loadAssets];
    [CGBallonRed loadAssets];
}

+ (void)releaseSceneAssets {
    [CGBallonBlue releaseAssets];
    [CGBallonYellow releaseAssets];
    [CGBallonGreen releaseAssets];
    [CGBallonRed releaseAssets];
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (fromPos == 0) {
        [self.myGameMgr.models removeAllObjects];
    }
    
    [CGHttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                                from:fromPos
                               count:count
                          completion:^(NSDictionary *info) {
                              if (self.myGameMgr.models.count == 0) {
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
                                  failure(@{@"error": error});
                              }
                          }];
}

- (void)addCharacters:(NSInteger)index {
    //    if (self.optionCharacters.count > 0) {
    //        [self.toDestroyOptions addObjectsFromArray:self.optionCharacters];
    //        [self.optionCharacters removeAllObjects];
    //    }
    //    if (self.questionCharacters.count > 0) {
    //        [self.toDestroyQuestions addObjectsFromArray:self.questionCharacters];
    //        [self.questionCharacters removeAllObjects];
    //    }
    //
    //    if ([CGMgr sharedInstance].chooseModels.count == 0 ||
    //        index >= [CGMgr sharedInstance].chooseModels.count) {
    //        return;
    //    }
    //
    //    CGChooseModel *chooseModel = [CGMgr sharedInstance].chooseModels[index];
    //    CGQuestion *questionSp = [[CGQuestion alloc] initWithString:chooseModel.question.title
    //                                                      soundName:chooseModel.question.soundName
    //                                                       position:CGPointMake(190 + index * self.size.width, 459)];
    //    [self addNode:questionSp atWorldLayer:HSSWorldLayerCharacter];
    //    [self.questionCharacters addObject:questionSp];
    //
    //    for (int j = 0; j < chooseModel.options.count; j++) {
    //        CGOptionModel *optionModel = chooseModel.options[j];
    //        CGPoint pos = [self.optionPositions[j] CGPointValue];
    //        CGOption *ballon = [[[self ballonClass:(j % 4)] alloc] initWithString:optionModel.title
    //                                                                     position:CGPointMake(pos.x + index * self.size.width, pos.y)
    //                                                                     isAnswer:optionModel.isAnswer];
    //        ballon.requestedAnimation = HSAnimationStateIdle;
    //        [self addNode:ballon atWorldLayer:HSSWorldLayerCharacter];
    //        [self.optionCharacters addObject:ballon];
    //    }
    
    if (self.myGameMgr.models.count == 0 ||
        index >= self.myGameMgr.models.count) {
        return;
    }
    
    CGChooseModel *chooseModel = self.myGameMgr.models[index];
    
    if (!self.question) {
        self.question = [[CGQuestion alloc] initWithString:chooseModel.question.title
                                                 soundName:chooseModel.question.soundName
                                                  position:[UniversalUtil universaliPadPoint:CGPointMake(190, 459)
                                                                                 iPhonePoint:CGPointMake(95, 190)
                                                                                     offsetX:0
                                                                                     offsetY:0]];
        [self addNode:self.question atWorldLayer:HSSWorldLayerCharacter];
        
        for (int j = 0; j < chooseModel.options.count; j++) {
            CGOptionModel *optionModel = chooseModel.options[j];
            CGPoint pos = [self.optionPositions[j] CGPointValue];
            CGOption *ballon = [[[self ballonClass:(j % 4)] alloc] initWithString:optionModel.title
                                                                         position:[UniversalUtil universaliPadPoint:pos
                                                                                                        iPhonePoint:CGPOINT_NON
                                                                                                            offsetX:0
                                                                                                            offsetY:0]
                                                                         isAnswer:optionModel.isAnswer];
            ballon.requestedAnimation = HSAnimationStateIdle;
            [self addNode:ballon atWorldLayer:HSSWorldLayerCharacter];
            [self.optionCharacters addObject:ballon];
        }
        SKAction *wait = [SKAction waitForDuration:1];
        SKAction *done = [SKAction runBlock:^{
#ifdef EZLEARN_DEBUG
#else
            [self.question playSound];
#endif
        }];
        
        SKNode *layer = [self layerWith:HSSWorldLayerCharacter];
        [layer runAction:[SKAction sequence:@[wait, done]] withKey:@"ChangeQuestion"];
    }
    else {
        SKNode *layer = [self layerWith:HSSWorldLayerCharacter];
        
        if ([layer actionForKey:@"ChangeQuestion"]) {
            [layer removeActionForKey:@"ChangeQuestion"];
        }
        
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.6];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.6];
        SKAction *changeContent = [SKAction runBlock:^{
            self.question.label.text = chooseModel.question.title;
            self.question.soundName = chooseModel.question.soundName;
            
            for (CGOption *ballon in self.optionCharacters) {
                [ballon removeFromParent];
            }
            
            if (self.optionCharacters.count > 0) {
                [self.optionCharacters removeAllObjects];
            }
            
            for (int j = 0; j < chooseModel.options.count; j++) {
                CGOptionModel *optionModel = chooseModel.options[j];
                CGPoint pos = [self.optionPositions[j] CGPointValue];
                CGOption *ballon = [[[self ballonClass:(j % 4)] alloc] initWithString:optionModel.title
                                                                             position:[UniversalUtil universaliPadPoint:pos
                                                                                                            iPhonePoint:CGPOINT_NON
                                                                                                                offsetX:0
                                                                                                                offsetY:0]
                                                                             isAnswer:optionModel.isAnswer];
                ballon.requestedAnimation = HSAnimationStateIdle;
                [self addNode:ballon atWorldLayer:HSSWorldLayerCharacter];
                [self.optionCharacters addObject:ballon];
            }
        }];
        SKAction *wait = [SKAction waitForDuration:0.25];
        SKAction *done = [SKAction runBlock:^{
#ifdef EZLEARN_DEBUG
#else
            [self.question playSound];
#endif
        }];
        
        [layer runAction:[SKAction sequence:@[fadeOut, changeContent, fadeIn, wait, done]] withKey:@"ChangeQuestion"];
    }
}

- (void)animationCorrect:(SKNode *)node {
    SKAction *move = [SKAction moveTo:[UniversalUtil universaliPadPoint:CGPointMake(70, 700)
                                                            iPhonePoint:CGPOINT_NON
                                                                offsetX:0
                                                                offsetY:0]
                             duration:0.5];
    SKAction *zoomIn = [SKAction scaleTo:0. duration:0.5];
    SKAction *group = [SKAction group:@[move, zoomIn]];
    [node runAction:group completion:^{
        [node removeFromParent];
        NSInteger subScore = [[self.heart titleForState:UIControlStateNormal] integerValue];
        subScore++;
        [self refreshScore:subScore];
        if (self.curIndex == self.myGameMgr.models.count - 1) {
            if (self.myGameMgr.curGroupCount > 0) {
                [self clickRight:nil];
            }
            else {
                [self finishAll];
            }
            
        }
        else {
            self.userInteractionEnabled = NO;
            [self performSelector:@selector(next) withObject:nil afterDelay:0];
        }
    }];
}

- (void)destroyCharacters {
    //    for (CGOption *character in self.toDestroyOptions) {
    //        [character removeFromParent];
    //    }
    //    for (CGOption *character in self.toDestroyQuestions) {
    //        [character removeFromParent];
    //    }
    //
    //    [self.toDestroyQuestions removeAllObjects];
    //    [self.toDestroyOptions removeAllObjects];
}

- (NSString *)indexStringWith:(NSInteger)index {
    CGChooseModel *model = self.myGameMgr.models[index];
    return model.indexStr;
}

- (NSInteger)currentTotalCount {
    return self.myGameMgr.models.count;
}

- (void)loadMore {
    if (self.myGameMgr.curGroupCount > 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [self loadGameDataFrom:self.myGameMgr.curGroupCount - 1
                         count:1000
                      Complete:^{
                          [SVProgressHUD dismiss];
                          [self expandIndexController];
                          //                                     self.curIndex++;
                      } failure:^(NSDictionary *info) {
                          [SVProgressHUD dismiss];
                      }];
    }
}

- (void)loadGameMgr {
    self.myGameMgr = [CGMgr sharedInstance];
}

- (void)reloadAllInterface {
    self.uikitContainer.hidden = NO;
    [self expandIndexController];
    [self addCharacters:0];
}

- (void)finishAll {
    [super finishAll];
}

- (void)gameOver {
    [super gameOver];
    
    [self playGameOverSound];
}

- (void)next {
    self.userInteractionEnabled = YES;
    self.curIndex++;
}

#pragma mark - Actions
- (void)clickBack:(id)sender {
    [self.myGameMgr.models removeAllObjects];
    
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
    if (index > self.myGameMgr.models.count - 1) {
        if (self.myGameMgr.curGroupCount > 0) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [self loadGameDataFrom:self.myGameMgr.curGroupCount - 1
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
            index = self.myGameMgr.models.count - 1;
        }
    }
    
    self.curIndex = index;
}

- (void)clickQuestion:(CGQuestion *)questionSp {
#ifdef EZLEARN_DEBUG
#else
    [self playSound:questionSp];
#endif
}

- (void)clickOption:(CGOption *)optionSp {
    self.gameMgr.clickCount++;
    
    if (optionSp.isAnswer) {
        [self chooseCorrect:optionSp];
    }
    else {
        [self chooseWrong:optionSp];
    }
}

#pragma mark - Loop
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    for (CGOption *ballon in self.optionCharacters) {
        [ballon updateWithTimeSinceLastUpdate:interval];
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
    else if ([node.name isEqualToString:kSoundButton]) {
        //        CGQuestion *question = self.questionCharacters.firstObject;
        //        [self playSound:question];
#ifdef EZLEARN_DEBUG
#else
        [self playSound:self.question];
#endif
    }
    else if ([node.name isEqualToString:kBackButton]) {
        [self clickBack:node];
    }
    else {
        for (NSInteger i = self.optionCharacters.count - 1; i >= 0; i--) {
            CGOption *op = self.optionCharacters[i];
            if ([op containsPoint:loc]) {
                if (op.isAnswer) {
                    op.label.hidden = YES;
#ifdef EZLEARN_DEBUG
#else
                    [op playBoomSound];
#endif
                    op.requestedAnimation = HSAnimationStateDeath;
                }
                else {
                    [self clickOption:op];
                }
                
                break;
            }
        }
    }
    
    [self setButtonSelectState:nil];
    
    [super touchesEnded:touches withEvent:event];
}

- (void)setMyGameMgr:(CGMgr *)myGameMgr {
    _myGameMgr = myGameMgr;
    self.gameMgr = myGameMgr;
}

@end
