//
//  HSCharacter.m
//  HappyStudy
//
//  Created by Quan on 14/10/26.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSCharacter.h"

@implementation HSCharacter

- (id)initWithTexture:(SKTexture *)texture {
    if (self = [super initWithTexture:texture]) {
        self.animationSpeed = 1.0f/5.0f;
    }
    
    return self;
}

- (id)initWithTexture:(SKTexture *)texture title:(NSString *)title {
    if (self = [super initWithTexture:texture title:title]) {
        self.animationSpeed = 1.0f/5.0f;
    }
    
    return self;
}

- (NSString *)animationKeyWith:(HSAnimationState)animation {
    switch (animation) {
        case HSAnimationStateIdle:
            return @"anim-idle";
        case HSAnimationStateMove:
            return @"anim-move";
        case HSAnimationStateDeath:
            return @"anim-death";
            
        default:
            break;
    }
    
    return nil;
}

- (void)fireAnimationWithTextures:(NSArray *)frames withKey:(NSString *)key {
    if (frames.count <= 1) {
        return;
    }
    
    [self runAction:[SKAction sequence:@[[SKAction animateWithTextures:frames timePerFrame:self.animationSpeed resize:NO restore:NO],
                                         [SKAction runBlock:^{
        [self animationDidComplete:self.requestedAnimation];
    }]]]
            withKey:key];
}

#pragma mark - Class Function
+ (void)loadAssets {
    // 子类继承
}

+ (void)releaseAssets {
    // 子类继承
}

#pragma mark - Loop
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    NSString *animationKey = [self animationKeyWith:self.requestedAnimation];
    SKAction *animAction = [self actionForKey:animationKey];
    if (animAction) {
        return;
    }
    
    if ([self actionForKey:self.activeAnimationKey]) {
        [self removeActionForKey:self.activeAnimationKey];
    }
    self.activeAnimationKey = animationKey;
    
    switch (self.requestedAnimation) {
        case HSAnimationStateIdle:
            [self animationIdle];
            break;
        case HSAnimationStateMove:
            [self animationMove];
            break;
        case HSAnimationStateDeath:
            [self animationDeath];
            break;
            
        default:
            break;
    }
}

#pragma mark - Animation
- (void)animationIdle {
    // 子类继承
}

- (void)animationMove {
    // 子类继承
}

- (void)animationDeath {
    // 子类继承
}

- (void)animationDidComplete:(HSAnimationState)animation {
    // 子类继承
}

@end
