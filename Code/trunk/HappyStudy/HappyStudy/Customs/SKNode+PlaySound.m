//
//  SKNode+PlaySound.m
//  EasyLSP
//
//  Created by Quan on 15/6/16.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "SKNode+PlaySound.h"
#import "GlobalUtil.h"

@implementation SKNode (PlaySound)

- (void)playSound:(NSString *)soundName completion:(void (^)())completion {
#ifdef EZLEARN_DEBUG
#else
    if (!soundName || ![GlobalUtil soundFileExist:soundName]) {
        return;
    }
    
    SKAction *playSoundAction = [SKAction playSoundFileNamed:soundName waitForCompletion:NO];
    SKAction *doneAction = [SKAction runBlock:^{
        if (completion) {
            completion();
        }
    }];
    [self runAction:[SKAction sequence:@[playSoundAction, doneAction]] withKey:@"PlaySound"];
#endif
}

- (void)playCorrectMaleSound {
#ifdef EZLEARN_DEBUG
#else
    NSInteger index = arc4random() % 5;
    NSString *soundName = [NSString stringWithFormat:@"correct_male%@.mp3", @(index)];
    
    [self runAction:[SKAction playSoundFileNamed:soundName waitForCompletion:NO]];
#endif
}

- (void)playCorrectMaleSoundCompletion:(void (^)())completion {
#ifdef EZLEARN_DEBUG
#else
    NSInteger index = arc4random() % 5;
    NSString *soundName = [NSString stringWithFormat:@"correct_male%@.mp3", @(index)];
    
    [self runAction:[SKAction playSoundFileNamed:soundName waitForCompletion:NO] completion:^{
        if (completion) {
            completion();
        }
    }];
#endif
}

- (void)playCorrectFemaleSound {
#ifdef EZLEARN_DEBUG
#else
    NSInteger index = arc4random() % 11;
    NSString *soundName = [NSString stringWithFormat:@"correct_female%@.mp3", @(index)];
    
    [self runAction:[SKAction playSoundFileNamed:soundName waitForCompletion:NO]];
#endif
}

- (void)playCorrectFemaleSoundCompletion:(void (^)())completion {
#ifdef EZLEARN_DEBUG
#else
    NSInteger index = arc4random() % 11;
    NSString *soundName = [NSString stringWithFormat:@"correct_female%@.mp3", @(index)];
    
    [self runAction:[SKAction playSoundFileNamed:soundName waitForCompletion:NO] completion:^{
        if (completion) {
            completion();
        }
    }];
#endif
}

- (void)playWrongSound {
#ifdef EZLEARN_DEBUG
#else
//    [self runAction:[SKAction playSoundFileNamed:@"wrong_common.mp3" waitForCompletion:NO]];
    [self runAction:[SKAction playSoundFileNamed:@"answer_wrong.wav" waitForCompletion:NO]];
#endif
}

- (void)playBallonWrongSound {
#ifdef EZLEARN_DEBUG
#else
    [self runAction:[SKAction playSoundFileNamed:@"answer_wrong.wav" waitForCompletion:NO]];
#endif
}

- (void)playGameOverSound {
#ifdef EZLEARN_DEBUG
#else
    [self runAction:[SKAction playSoundFileNamed:@"gameover.wav" waitForCompletion:NO]];
#endif
}

@end
