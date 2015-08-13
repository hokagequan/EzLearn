//
//  SKNode+PlaySound.h
//  EasyLSP
//
//  Created by Quan on 15/6/16.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (PlaySound)

- (void)playSound:(NSString *)soundName completion:(void (^)())completion;
- (void)playCorrectMaleSound;
- (void)playCorrectFemaleSound;
- (void)playWrongSound;
- (void)playGameOverSound;

@end
