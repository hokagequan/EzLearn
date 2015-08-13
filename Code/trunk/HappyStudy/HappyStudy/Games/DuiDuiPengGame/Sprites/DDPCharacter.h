//
//  DDPCharacter.h
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSCharacter.h"
#import "DuiDuiPengGameScene.h"

@interface DDPCharacter : HSCharacter

@property (strong, nonatomic) NSString *matchKey;

- (DuiDuiPengGameScene *)characterScene;
- (void)playSound:(NSString *)soundName;

- (UIColor *)normalColor;
- (UIColor *)selectedColor;

@end
