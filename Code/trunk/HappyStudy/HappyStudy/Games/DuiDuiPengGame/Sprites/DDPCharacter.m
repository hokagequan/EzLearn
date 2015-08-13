//
//  DDPCharacter.m
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "DDPCharacter.h"
#import "GlobalUtil.h"

@interface DDPCharacter ()

@end

@implementation DDPCharacter

- (instancetype)initWithTitle:(NSString *)title norTexture:(SKTexture *)norTexture selTexture:(SKTexture *)selTexture {
    if (self = [super initWithTitle:title norTexture:norTexture selTexture:selTexture]) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (DuiDuiPengGameScene *)characterScene {
    DuiDuiPengGameScene *scene = (id)[self scene];
    if ([scene isKindOfClass:[DuiDuiPengGameScene class]]) {
        return scene;
    }
    
    return nil;
}

- (void)playSound:(NSString *)soundName {
    if (!soundName || ![GlobalUtil soundFileExist:soundName]) {
        return;
    }
    
    [self runAction:[SKAction playSoundFileNamed:soundName waitForCompletion:YES]];
}

- (UIColor *)normalColor {
    // 子类继承
    
    return [UIColor whiteColor];
}

- (UIColor *)selectedColor {
    // 子类继承
    
    return [UIColor whiteColor];
}

#pragma mark - Override
- (void)animationDeath {
    SKAction *rotate = [SKAction repeatActionForever:[SKAction rotateByAngle:2 * M_PI duration:0.2]];
    SKAction *zoomIn = [SKAction scaleTo:0. duration:0.5];
    SKAction *done = [SKAction runBlock:^{
        DuiDuiPengGameScene *scene = [self characterScene];
        if (scene) {
            [scene removeCharacter:self];
        }
        [self removeFromParent];
    }];
    SKAction *main = [SKAction sequence:@[zoomIn, done]];
    [self runAction:[SKAction group:@[rotate, main]]
            withKey:[self animationKeyWith:HSAnimationStateDeath]];
}

@end
