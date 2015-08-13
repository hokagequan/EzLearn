//
//  DDSHoleTypeOne.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "DDSHoleTypeOne.h"

@implementation DDSHoleTypeOne

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"HoleOne"]
                                             baseFileName:@"ddshole_type_one_idle_"
                                                 frameNum:4];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"HoleOne"]];
    SKTexture *theTexture = [atlas textureNamed:@"ddshole_type_one_idle_0001"];
    
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
