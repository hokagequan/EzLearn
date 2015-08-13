//
//  DDSHoleTypeTwo.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "DDSHoleTypeTwo.h"

@implementation DDSHoleTypeTwo

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"HoleTwo"]
                                             baseFileName:@"ddshole_type_two_idle_"
                                                 frameNum:3];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"HoleTwo"]];
    SKTexture *theTexture = [atlas textureNamed:@"ddshole_type_two_idle_0001"];
    
    return [super initWithTexture:theTexture];
}

static NSArray *idleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return idleAnimationFrames;
}

#pragma mark - Override
- (void)animationIdle {
    [self fireAnimationWithTextures:idleAnimationFrames
                            withKey:[self animationKeyWith:self.requestedAnimation]];
}

@end
