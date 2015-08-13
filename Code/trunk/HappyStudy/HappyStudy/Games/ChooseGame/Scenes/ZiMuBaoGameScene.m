//
//  ZiMuBaoGameScene.m
//  EasyLSP
//
//  Created by Quan on 15/5/4.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ZiMuBaoGameScene.h"
#import "HSButtonSprite.h"
#import "HSAnimal.h"
#import "HSOwl.h"
#import "CGMgr.h"
#import "CGQuestion.h"

typedef NS_ENUM(NSInteger, ButtonName) {
    ButtonNameShengMu = 1,
    ButtonNameYunMu,
    ButtonNameZhengTi,
    ButtonNameClose
};

@interface ZiMuBaoGameScene()

@property (strong, nonatomic) SKSpriteNode *selectionNode;
@property (strong, nonatomic) UIView *maskView;
//@property (strong, nonatomic) SKSpriteNode *selectionCharacterNode;
//@property (strong, nonatomic) HSButtonSprite *selectionShengMuBtn;
//@property (strong, nonatomic) HSButtonSprite *selectionYunMuBtn;
//@property (strong, nonatomic) HSButtonSprite *selectionZhengTiBtn;
//@property (strong, nonatomic) HSButtonSprite *selectionCloseBtn;

@end

@implementation ZiMuBaoGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self buildSelection];
    [self buildMask];
}

- (void)buildMask {
//    self.maskView = [[UIView alloc] initWithFrame:self.uikitContainer.bounds];
//    self.maskView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.7];
//    [self.uikitContainer addSubview:self.maskView];
    self.uikitContainer.hidden = YES;
}

- (void)buildSelection {
    self.selectionNode = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:0.0 alpha:0.7]
                                                      size:self.size];
    self.selectionNode.position = CGPointZero;
    self.selectionNode.anchorPoint = CGPointZero;
    self.selectionNode.zPosition = 1000;
    [self addChild:self.selectionNode];
    
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"about_bg"];
    backgroundSp.position = CGPointMake(self.selectionNode.size.width / 2 - backgroundSp.size.width / 2,
                                        self.selectionNode.size.height / 2 - backgroundSp.size.height / 2);
    backgroundSp.anchorPoint = CGPointZero;
    [self.selectionNode addChild:backgroundSp];
    
    // Buttons
    HSButtonSprite *shengmuBtn = [[HSButtonSprite alloc] initWithTitle:@""
                                                              norImage:@"shengmu"
                                                              selImage:@"shengmu"];
    shengmuBtn.name = [GlobalUtil stringWithNumber:ButtonNameShengMu];
    shengmuBtn.position = CGPointMake(backgroundSp.size.width / 2 - [UniversalUtil universalDelta:159], backgroundSp.size.height / 2 + [UniversalUtil universalDelta:40]);
    [backgroundSp addChild:shengmuBtn];
    
    SKLabelNode *shengmuLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    shengmuLab.text = @"声母";
    shengmuLab.position = CGPointMake(shengmuBtn.position.x,
                                      shengmuBtn.position.y - [UniversalUtil universalDelta:90]);
    shengmuLab.fontSize = [UniversalUtil universalFontSize:25];
    shengmuLab.fontName = FONT_NAME_HP;
    shengmuLab.fontColor = colorRGB(191, 98, 35, 1);
    [backgroundSp addChild:shengmuLab];
    
    HSButtonSprite *yunmuBtn = [[HSButtonSprite alloc] initWithTitle:@""
                                                            norImage:@"yunmu"
                                                            selImage:@"yunmu"];
    yunmuBtn.name = [GlobalUtil stringWithNumber:ButtonNameYunMu];
    yunmuBtn.position = CGPointMake(backgroundSp.size.width / 2, shengmuBtn.position.y);
    [backgroundSp addChild:yunmuBtn];
    
    SKLabelNode *yunmuLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    yunmuLab.text = @"韵母";
    yunmuLab.fontSize = [UniversalUtil universalFontSize:25];
    yunmuLab.fontName = FONT_NAME_HP;
    yunmuLab.fontColor = colorRGB(191, 98, 35, 1);
    yunmuLab.position = CGPointMake(yunmuBtn.position.x,
                                    shengmuLab.position.y);
    [backgroundSp addChild:yunmuLab];
    
    HSButtonSprite *zhengtiBtn = [[HSButtonSprite alloc] initWithTitle:@""
                                                              norImage:@"zhengtirendu"
                                                              selImage:@"zhengtirendu"];
    zhengtiBtn.name = [GlobalUtil stringWithNumber:ButtonNameZhengTi];
    zhengtiBtn.position = CGPointMake(backgroundSp.size.width / 2 + [UniversalUtil universalDelta:166], shengmuBtn.position.y);
    [backgroundSp addChild:zhengtiBtn];
    
    SKLabelNode *zhengtiLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    zhengtiLab.text = @"整体认读";
    zhengtiLab.fontSize = [UniversalUtil universalFontSize:25];
    zhengtiLab.fontName = FONT_NAME_HP;
    zhengtiLab.fontColor = colorRGB(191, 98, 35, 1);
    zhengtiLab.position = CGPointMake(zhengtiBtn.position.x,
                                      shengmuLab.position.y);
    [backgroundSp addChild:zhengtiLab];
    
    HSButtonSprite *closeBtn = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"about_close.png"
                                                            selImage:@"about_close.png"];
    closeBtn.name = [GlobalUtil stringWithNumber:ButtonNameClose];
    closeBtn.zPosition = 100;
    closeBtn.position = CGPointMake(backgroundSp.size.width - [UniversalUtil universalDelta:6],
                                    backgroundSp.size.height - [UniversalUtil universalDelta:20]);
    [backgroundSp addChild:closeBtn];
    
    // Character
    HSAnimal *owl = [[HSOwl alloc] initWithTexture:nil];
    [HSOwl loadAssets];
//    owl.zRotation = -M_PI / 12;
    owl.zPosition = 10;
    owl.position = CGPointMake(backgroundSp.size.width / 2,
                               backgroundSp.size.height - [UniversalUtil universalDelta:20]);
    [backgroundSp addChild:owl];
    SKAction *idleAction = [SKAction animateWithTextures:[owl idleAnimationFrames]
                                            timePerFrame:1 / 5.];
    [owl runAction:[SKAction repeatActionForever:idleAction]];
}

- (BOOL)handleSelectionButton:(SKNode *)node {
    if (!self.selectionNode.parent) {
        return NO;
    }
    
    if ([node.name integerValue] == ButtonNameShengMu) {
        // 声母
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [CGMgr loadLocalGameDataZiMuBaoShengMu];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                [self reloadAllInterface];
            });
        });
        
        [self.selectionNode removeFromParent];
        
        return YES;
    }
    else if ([node.name integerValue] == ButtonNameYunMu) {
        // 韵母
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [CGMgr loadLocalGameDataZiMuBaoYunMu];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                [self reloadAllInterface];
            });
        });
        
        [self.selectionNode removeFromParent];
        
        return YES;
    }
    else if ([node.name integerValue] == ButtonNameZhengTi) {
        // 整体
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [CGMgr loadLocalGameDataZiMuBaoZhengTi];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                [self reloadAllInterface];
            });
        });
        
        [self.selectionNode removeFromParent];
        
        return YES;
    }
    else if ([node.name integerValue] == ButtonNameClose) {
        [self clickBack:node];
    }
    
    return NO;
}

#pragma mark - Override
- (void)buildWorld {
    [super buildWorld];
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (complete) {
        complete();
    }
}

#pragma mark - Touches
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self.selectionNode];
    SKNode *node = [self.selectionNode nodeAtPoint:loc];
    
    if ([self handleSelectionButton:node]) {
        return;
    }
    
    [super touchesEnded:touches withEvent:event];
}

@end
