//
//  JZQMgr.h
//  EasyLSP
//
//  Created by Q on 15/6/10.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "SubGameMgr.h"

@class JuZiQiaoScene;

typedef NS_ENUM(NSUInteger, JZQGameStat) {
    JZQGameStatNon = 1,
    JZQGameStatStart = 1 << 1,
    JZQGameStatPrepareCheck = 1 << 2,
    JZQGameStatCheck = 1 << 3,
};

@interface JZQMgr : SubGameMgr

@property (weak, nonatomic) JuZiQiaoScene *gameScene;

@property (strong, nonatomic) NSMutableArray *currentAnswers;
@property (nonatomic) JZQGameStat stat;

// 句子桥
- (void)loadJuZiQiaoServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadJuZiQiaoServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;

- (void)loadAnswerWithIndex:(NSInteger)index add:(BOOL)add;
- (void)resetAnswers;

@end
