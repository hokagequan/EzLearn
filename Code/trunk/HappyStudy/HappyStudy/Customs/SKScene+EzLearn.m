//
//  SKScene+EzLearn.m
//  EasyLSP
//
//  Created by Q on 15/7/10.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "SKScene+EzLearn.h"

@implementation SKScene (EzLearn)

- (void)addStarZPosition:(NSInteger)zPosition {
    // 随即大小
    CGFloat standardSize = 20.;
    int minScale = 1.0 * standardSize;
    int maxScale = 2.0 * standardSize;
    int randomScale = (arc4random() % (maxScale - minScale)) + minScale;
    // 随即位置
    int minX = randomScale / 2;
    int maxX = self.size.width - randomScale / 2;
    int randomX = (arc4random() % (maxX - minX)) + minX;
    // 随即时间
    int minDuration = 3;
    int maxDuration = 6;
    int randomDuration = (arc4random() % (maxDuration - minDuration)) + minDuration;
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Environment"]];
    SKTexture *bubbleTexture = [atlas textureNamed:@"bubble"];
    SKSpriteNode *star = [SKSpriteNode spriteNodeWithTexture:bubbleTexture
                                                        size:CGSizeMake(randomScale, randomScale)];
    star.position = CGPointMake(randomX, -(randomScale + 50));
    star.zPosition = zPosition;
    [self addChild:star];
    
    SKAction *rotateOnceAction = [SKAction rotateByAngle:2 * M_PI duration:1.];
    SKAction *rotateAction = [SKAction repeatActionForever:rotateOnceAction];
    [star runAction:rotateAction];
    SKAction *moveAction = [SKAction moveByX:0. y:self.size.height + 50 + randomScale duration:randomDuration];
    SKAction *doneAction = [SKAction runBlock:^{
        [star removeFromParent];
    }];
    
    [star runAction:[SKAction sequence:@[moveAction, doneAction]]];
}

- (void)spawnStarsZPosition:(NSInteger)zPosition {
    SKAction *addAction = [SKAction runBlock:^{
        [self addStarZPosition:zPosition];
    }];
    SKAction *waitAction = [SKAction waitForDuration:1.5];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[addAction, waitAction]]]];
}

- (void)showCorrectCongratulations:(CGPoint)position completion:(void (^)())completion {
    NSArray *frames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"Environment"]
                                         baseFileName:@"congratulations_"
                                             frameNum:7];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:frames.firstObject];
    sprite.position = position;
    sprite.zPosition = 1000000;
    sprite.anchorPoint = CGPointMake(0.5, 0);
    
    [self addChild:sprite];
    
    SKAction *action = [SKAction animateWithTextures:frames timePerFrame:1.0f/5.0f];
    [sprite runAction:action completion:^{
        [sprite removeFromParent];
        
        if (completion) {
            completion();
        }
    }];
}

@end
