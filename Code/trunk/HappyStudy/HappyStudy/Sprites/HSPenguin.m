//
//  HSPenguin.m
//  HappyStudy
//
//  Created by Q on 14/10/30.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSPenguin.h"

@implementation HSPenguin

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"Penguin_Idle"]
                                             baseFileName:@"penguin_idle_"
                                                 frameNum:2];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Penguin_Idle"]];
    SKTexture *theTexture = [atlas textureNamed:@"penguin_idle_0001"];
    
    return [super initWithTexture:theTexture];
}

static NSArray *idleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return idleAnimationFrames;
}

@end
