//
//  HSDeer.m
//  HappyStudy
//
//  Created by Q on 14/10/30.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSDeer.h"

@implementation HSDeer

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"Deer_Idle"]
                                             baseFileName:@"deer_idle_"
                                                 frameNum:3];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Deer_Idle"]];
    SKTexture *theTexture = [atlas textureNamed:@"deer_idle_0001"];
    
    return [super initWithTexture:theTexture];
}

static NSArray *idleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return idleAnimationFrames;
}

@end
