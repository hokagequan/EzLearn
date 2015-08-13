//
//  DDSModel.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "JZBModel.h"

@implementation JZBModel

- (NSString *)combineSentence {
    NSString *answerString = @"";
    for (JZBOption *option in self.options) {
        if (option.isAnswer) {
            answerString = option.title;
            
            break;
        }
    }
    
    NSString *relStr = @"";
    NSUInteger j = 0;
    for (int i = 0; i < self.question.titles.count + 1; i++) {
        if (i == self.question.questionIndex) {
            relStr = [relStr stringByAppendingString:answerString];
            
            continue;
        }
        
        NSString *character = self.question.titles[j];
        relStr = [relStr stringByAppendingString:character];
        j++;
    }
    
    return relStr;
}

#pragma mark - Property
- (NSMutableArray *)options {
    if (!_options) {
        _options = [NSMutableArray arrayWithCapacity:4];
    }
    
    return _options;
}

@end
