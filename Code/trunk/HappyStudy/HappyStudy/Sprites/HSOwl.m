//
//  HSOwl.m
//  HappyStudy
//
//  Created by Q on 14/10/30.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSOwl.h"

@implementation HSOwl

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"Owl_Idle"]
                                             baseFileName:@"Owl_idle_"
                                                 frameNum:6];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Owl_Idle"]];
    SKTexture *theTexture = [atlas textureNamed:@"Owl_idle_0001"];
    
    return [super initWithTexture:theTexture];
}

static NSArray *idleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return idleAnimationFrames;
}

@end
