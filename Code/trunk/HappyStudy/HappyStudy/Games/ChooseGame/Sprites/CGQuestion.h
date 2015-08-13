//
//  CGQuestion.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSCharacter.h"

@interface CGQuestion : HSCharacter

@property (strong, nonatomic) NSString *soundName;

- (id)initWithString:(NSString *)string soundName:(NSString *)soundName position:(CGPoint)position;
- (void)playSound;

@end
