//
//  JZQModel.m
//  EasyLSP
//
//  Created by Q on 15/6/10.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "JZQModel.h"
#import "JZQWord.h"

@implementation JZQModel

- (void)loadIndexWithSentence:(NSString *)sentence {
    if (self.words.count == 0) {
        return;
    }
    
    NSMutableArray *locations = [NSMutableArray array];
    for (JZQWord *word in self.words) {
        NSRange range = [sentence rangeOfString:word.word];
        word.index = range.location;
        [locations addObject:@(range.location)];
    }
    
    [locations sortedArrayUsingComparator:^NSComparisonResult(id  __nonnull obj1, id  __nonnull obj2) {
        NSNumber *number1 = (NSNumber *)obj1;
        NSNumber *number2 = (NSNumber *)obj2;
        return [number1 compare:number2] == NSOrderedDescending;
    }];
    
    for (JZQWord *word in self.words) {
        NSInteger idx = [locations indexOfObject:@(word.index)];
        word.index = idx;
    }
}

#pragma mark - Property
- (NSMutableArray *)words {
    if (!_words) {
        _words = [NSMutableArray array];
    }
    
    return _words;
}

@end
