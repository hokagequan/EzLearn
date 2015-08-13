//
//  OptionLeaf.m
//  EasyLSP
//
//  Created by Q on 15/5/13.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "OptionLeaf.h"

@implementation OptionLeaf

+ (instancetype)optionLeafWithNode:(SKNode *)node {
    if ([node isKindOfClass:[OptionLeaf class]]) {
        return (OptionLeaf *)node;
    }
    
    return (OptionLeaf *)[node parent];
}

@end
