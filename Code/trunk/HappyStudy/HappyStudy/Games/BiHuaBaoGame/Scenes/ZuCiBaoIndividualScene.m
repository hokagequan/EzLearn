//
//  ZuCiBaoIndividualScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ZuCiBaoIndividualScene.h"
#import "ZCBMgr.h"
#import "BHBModel.h"

@implementation ZuCiBaoIndividualScene

#pragma mark - Override
- (void)addCharacters:(NSInteger)index {
    [super addCharacters:index];
    
    BHBModel *model = self.myGameMgr.models[index];
    BHBQuestion *question = model.question;
    self.questionSprite.label.text = [NSString stringWithFormat:@"%@", question.title];
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (![GlobalUtil isNetworkConnection]) {
        [self.myGameMgr loadZuCiBaoLocalGameData];
        if (complete) {
            complete();
        }
        
        return;
    }

    if (fromPos <= 0) {
        [self.myGameMgr loadZuCiBaoIndividualServerGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *errorInfo) {
            if (failure) {
                failure(errorInfo);
            }
        }];
    }
    else {
        [self.myGameMgr loadZuCiBaoIndividualServerMoreGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *errorInfo) {
            if (failure) {
                failure(errorInfo);
            }
        }];
    }
}

- (void)loadGameMgr {
    self.myGameMgr = [[ZCBMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (void)speakWithOptionIndex:(NSInteger)index {
    BHBModel *model = self.myGameMgr.models[self.curIndex];
    BHBOption *option = model.options[index];
    
    NSString *string = @"";
    for (int i = 0; i < 2; i++) {
        if (i == option.order) {
            string = [string stringByAppendingString:option.title];
        }
        else {
            string = [string stringByAppendingString:model.question.title];
        }
    }
    
    [GlobalUtil speakText:string];
}

@end
