//
//  CGAnswer.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "CGOption.h"
#import "SKLabelNode+HitTest.h"
#import "GlobalUtil.h"

@implementation CGOption

- (id)initWithTexture:(SKTexture *)texture string:(NSString *)string position:(CGPoint)position isAnswer:(BOOL)isAnswer {
    if (self = [super initWithTexture:texture title:string]) {
        self.position = position;
        self.name = @"Ballon";
        self.label.fontName = FONT_NAME_HP;
        self.isAnswer = isAnswer;
        self.idleAnimationDuration = 3.;
    }
    
    return self;
}

- (id)initWithString:(NSString *)string position:(CGPoint)position isAnswer:(BOOL)isAnswer {
    if (self = [super initWithTexture:nil title:string]) {
    }
    
    return self;
}

- (void)animationWrong {
    SKAction *zoomOut = [SKAction scaleTo:1.25 duration:0.2];
    SKAction *warnning = [SKAction runBlock:^{
        self.label.fontColor = [UIColor redColor];
    }];
    SKAction *zoomIn = [SKAction scaleTo:1.0 duration:0.2];
    SKAction *done = [SKAction runBlock:^{
        self.label.fontColor = [UIColor whiteColor];
    }];
    SKAction *wait = [SKAction waitForDuration:0.3];
    
    SKAction *groupWarnning = [SKAction group:@[zoomOut, warnning]];
    SKAction *groupDone = [SKAction group:@[zoomIn, done]];
    [self.label runAction:[SKAction sequence:@[groupWarnning, wait, groupDone]]];
}

- (ChooseGameScene *)characterScene {
    ChooseGameScene *scene = (id)[self scene];
    if ([scene isKindOfClass:[ChooseGameScene class]]) {
        return scene;
    }
    else {
        return nil;
    }
}

- (void)playBoomSound {
    [self runAction:[SKAction playSoundFileNamed:@"ballon_boom.mp3" waitForCompletion:YES]];
}

#pragma mark - Override
- (void)animationIdle {
    SKAction *upAction = [SKAction moveToY:[UniversalUtil universalDelta:454]
                                 duration:self.idleAnimationDuration];
    SKAction *downAction = [SKAction moveToY:[UniversalUtil universalDelta:230]
                                   duration:self.idleAnimationDuration];
    [self runAction:[SKAction sequence:@[upAction, downAction]]
            withKey:[self animationKeyWith:HSAnimationStateIdle]];
}

- (void)animationDeath {
    [self fireAnimationWithTextures:[self deathAnimationFrames]
                            withKey:[self animationKeyWith:HSAnimationStateDeath]];
}

- (void)animationDidComplete:(HSAnimationState)animation {
    ChooseGameScene *scene = [self characterScene];
    if (!scene) {
        return;
    }
    
    switch (animation) {
        case HSAnimationStateDeath:
            self.requestedAnimation = HSAnimationStateNon;
            [scene clickOption:self];
            
            break;
            
        default:
            break;
    }
}

- (NSArray *)deathAnimationFrames {
    return nil;
}

@end
