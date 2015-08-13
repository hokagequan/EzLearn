//
//  CrabCard.m
//  EasyLSP
//
//  Created by Q on 15/5/12.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "CrabCard.h"

@implementation CrabCard

#pragma mark - Override
+ (void)loadAssets {
    idleAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"BHBCrab"]
                                             baseFileName:@"bhbcrab_"
                                                 frameNum:3];
}

- (id)initWithTexture:(SKTexture *)texture {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"BHBCrab"]];
    SKTexture *theTexture = [atlas textureNamed:@"bhbcrab_0001"];
    
    return [super initWithTexture:theTexture];
}

static NSArray *idleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return idleAnimationFrames;
}

@end
