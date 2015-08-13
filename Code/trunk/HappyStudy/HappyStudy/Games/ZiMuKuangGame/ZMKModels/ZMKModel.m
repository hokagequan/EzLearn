//
//  DDSModel.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ZMKModel.h"
#import "ZMKOption.h"
#import "GlobalUtil.h"

@implementation ZMKModel

- (void)reloadOptions {
    if (self.options.count > 0) {
        [self.options removeAllObjects];
    }
    
    NSMutableArray *totalPinYin = [NSMutableArray arrayWithArray:[GlobalUtil allShengMu]];
    [totalPinYin addObjectsFromArray:[GlobalUtil allYunMu]];
    [totalPinYin addObjectsFromArray:[GlobalUtil allZhengTi]];
    
    while (self.options.count < 3) {
        NSInteger count = totalPinYin.count;
        NSUInteger random = [GlobalUtil randomIntegerWithMax:count];
        NSString *character = totalPinYin[random][@"title"];
        if ([character isEqualToString:self.question.title]) {
            continue;
        }
        ZMKOption *option = [[ZMKOption alloc] init];
        option.title = character;
        [self.options addObject:option];
    }
    
    ZMKOption *option = [[ZMKOption alloc] init];
    option.title = self.question.title;
    [self.options addObject:option];
    [GlobalUtil randomArray:self.options];
}

#pragma mark - Property
- (NSMutableArray *)options {
    if (!_options) {
        _options = [NSMutableArray arrayWithCapacity:3];
    }
    
    return _options;
}

@end
