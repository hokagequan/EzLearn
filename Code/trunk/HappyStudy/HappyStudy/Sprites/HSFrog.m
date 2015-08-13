//
//  HSFrog.m
//  HappyStudy
//
//  Created by Q on 14/10/30.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSFrog.h"

@implementation HSFrog

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"Frog_Idle"]
                                             baseFileName:@"frog_idle_"
                                                 frameNum:3];
    happyAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"Frog_Happy"]
                                              baseFileName:@"frog_happy_" frameNum:5];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Frog_Idle"]];
    SKTexture *theTexture = [atlas textureNamed:@"frog_idle_0001"];
    
    return [super initWithTexture:theTexture];
}

static NSArray *idleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return idleAnimationFrames;
}

static NSArray *happyAnimationFrames = nil;
- (NSArray *)happyAnimationFrames {
    return happyAnimationFrames;
}

@end
