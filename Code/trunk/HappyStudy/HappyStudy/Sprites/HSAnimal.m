//
//  HSAnimal.m
//  HappyStudy
//
//  Created by Quan on 14/10/26.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSAnimal.h"

@implementation HSAnimal

- (void)animationIdle {
    [self fireAnimationWithTextures:[self idleAnimationFrames]
                            withKey:[self animationKeyWith:self.requestedAnimation]];
}

- (NSArray *)idleAnimationFrames {
    return nil;
}

@end
