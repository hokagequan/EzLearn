//
//  PinZiBaoGameScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "PinZiBaoGameScene.h"
#import "PZBMgr.h"
#import "CGQuestion.h"
#import "CGOption.h"
#import "SKNode+PlaySound.h"

@implementation PinZiBaoGameScene

- (void)showAnswer:(NSString *)character {
    SKLabelNode *answerLable = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    answerLable.text = character;
    answerLable.fontColor = [UIColor redColor];
    answerLable.fontName = FONT_NAME_HP;
    answerLable.fontSize = 100;
    answerLable.zPosition = 1000;
    answerLable.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addNode:answerLable atWorldLayer:HSSWorldLayerCharacter];
    
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *done = [SKAction runBlock:^{
        [answerLable removeFromParent];
    }];
    
    [answerLable runAction:[SKAction sequence:@[wait, done]]];
}

#pragma mark - Override
- (void)addCharacters:(NSInteger)index {
    if ([CGMgr sharedInstance].models.count == 0 ||
        index >= [CGMgr sharedInstance].models.count) {
        return;
    }
    
    CGChooseModel *chooseModel = [CGMgr sharedInstance].models[index];
    
    if (!self.question) {
        self.question = [[CGQuestion alloc] initWithString:chooseModel.question.title
                                                 soundName:chooseModel.question.soundName
                                                  position:CGPointMake(190, 459)];
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
        
        SKNode *layer = [self layerWith:HSSWorldLayerCharacter];
        [layer runAction:[SKAction sequence:@[wait]] withKey:@"ChangeQuestion"];
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
                                                                             position:CGPointMake(pos.x, pos.y)
                                                                             isAnswer:optionModel.isAnswer];
                ballon.requestedAnimation = HSAnimationStateIdle;
                [self addNode:ballon atWorldLayer:HSSWorldLayerCharacter];
                [self.optionCharacters addObject:ballon];
            }
        }];
        SKAction *wait = [SKAction waitForDuration:0.25];
        
        [layer runAction:[SKAction sequence:@[fadeOut, changeContent, fadeIn, wait]] withKey:@"ChangeQuestion"];
    }
}

- (void)chooseCorrect:(CGOption *)optionSp {
    [self playSound:self.question];
    
    CGChooseModel *chooseModel = [CGMgr sharedInstance].models[self.curIndex];
    [self showAnswer:chooseModel.question.word];
    
    [super chooseCorrect:optionSp];
}

- (void)loadGameMgr {
    self.myGameMgr = [PZBMgr sharedInstance];
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    CGMgr *mgr = [CGMgr sharedInstance];
    
    if (fromPos <= 0) {
        [mgr loadPinZiBaoServerGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *info) {
            if (failure) {
                failure(info);
            }
        }];
    }
    else {
        [mgr loadPinZiBaoServerMoreGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *info) {
            if (failure) {
                failure(info);
            }
        }];
    }
}

#pragma mark - UICollectionView
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGSize size = [super collectionView:collectionView
                                 layout:collectionViewLayout
                 sizeForItemAtIndexPath:indexPath];
    
    return CGSizeMake(size.width + [UniversalUtil universalDelta:30], size.height);
}

@end
