//
//  EnvironmentCrab.m
//  EasyLSP
//
//  Created by Q on 15/5/27.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "EnvironmentCrab.h"

@implementation EnvironmentCrab

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"BHBECrab"]
                                             baseFileName:@"bhbecrab_"
                                                 frameNum:3];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"BHBECrab"]];
    SKTexture *theTexture = [atlas textureNamed:@"bhbecrab_0001"];
    
    return [super initWithTexture:theTexture];
}

- (void)animationIdle {
    [self fireAnimationWithTextures:[self idleAnimationFrames]
                            withKey:[self animationKeyWith:self.requestedAnimation]];
}

static NSArray *idleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return idleAnimationFrames;
}

@end
