//
//  HSOctopus.m
//  HappyStudy
//
//  Created by Q on 14/10/30.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSOctopus.h"

@implementation HSOctopus

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"Octopus_Idle"]
                                             baseFileName:@"octopus_idle_"
                                                 frameNum:3];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Octopus_Idle"]];
    SKTexture *theTexture = [atlas textureNamed:@"octopus_idle_0001"];
    
    return [super initWithTexture:theTexture];
}

static NSArray *idleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return idleAnimationFrames;
}

@end
