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
    
    for (JZQWord *word in self.words) {
        NSRange range = [sentence rangeOfString:word.word];
        word.index = range.location;
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
