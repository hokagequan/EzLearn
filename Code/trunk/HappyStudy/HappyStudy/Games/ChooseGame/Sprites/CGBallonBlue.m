//
//  CGBallonBlue.m
//  HappyStudy
//
//  Created by Q on 14/10/27.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "CGBallonBlue.h"

@implementation CGBallonBlue

#pragma mark - Override
- (id)initWithString:(NSString *)string position:(CGPoint)position isAnswer:(BOOL)isAnswer {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"CGBallonBlue_Death"]];
    SKTexture *theTexture = [atlas textureNamed:@"cgballon_blue_death_0001"];
    if (self = [super initWithTexture:theTexture string:string position:position isAnswer:isAnswer]) {
        self.label.position = CGPointMake(self.label.position.x, self.label.position.y + [UniversalUtil universalDelta:35]);
    }
    
    return self;
}

+ (void)loadAssets {
    deathAnimationFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"CGBallonBlue_Death"]
                                              baseFileName:@"cgballon_blue_death_"
                                                  frameNum:10];
}

+ (void)releaseAssets {
    deathAnimationFrames = nil;
}

static NSArray *deathAnimationFrames = nil;
- (NSArray *)deathAnimationFrames {
    return deathAnimationFrames;
}

@end
