//
//  OptionLeaf.h
//  EasyLSP
//
//  Created by Q on 15/5/13.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "HSCharacter.h"

@interface OptionLeaf : HSCharacter

@property (nonatomic) CGPoint originalLocation;
@property (nonatomic) BOOL isAnswer;

+ (instancetype)optionLeafWithNode:(SKNode *)node;

@end
