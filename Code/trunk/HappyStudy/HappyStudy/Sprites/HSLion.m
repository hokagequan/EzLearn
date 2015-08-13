//
//  HSLion.m
//  HappyStudy
//
//  Created by Quan on 14/10/26.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSLion.h"

@implementation HSLion

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"Lion_Idle"]
                                             baseFileName:@"lion_idle_"
                                                 frameNum:4];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Lion_Idle"]];
    SKTexture *theTexture = [atlas textureNamed:@"lion_idle_0001"];
    
    return [super initWithTexture:theTexture];
}

static NSArray *idleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return idleAnimationFrames;
}

@end
