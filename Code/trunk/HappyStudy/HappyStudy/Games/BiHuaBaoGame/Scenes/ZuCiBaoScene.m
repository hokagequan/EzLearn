//
//  ZuCiBaoScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ZuCiBaoScene.h"
#import "ZCBMgr.h"
#import "BHBModel.h"
#import "SKNode+PlaySound.h"

@interface ZuCiBaoScene()<AVSpeechSynthesizerDelegate>

@end

@implementation ZuCiBaoScene

#pragma mark - Override

- (void)addCharacters:(NSInteger)index {
    [super addCharacters:index];
    
    BHBModel *model = self.myGameMgr.models[index];
    BHBQuestion *question = model.question;
    self.questionSprite.label.text = [NSString stringWithFormat:@"%@", question.title];
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    [self.myGameMgr loadZuCiBaoServerGameDataCompletion:complete
                                              failure:failure];
}

- (void)loadMore {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.myGameMgr loadZuCiBaoServerMoreGameDataCompletion:^{
        [SVProgressHUD dismiss];
        [self expandIndexController];
    } failure:^(NSDictionary *errorInfo) {
        [SVProgressHUD dismiss];
    }];
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
    
    AVSpeechSynthesizer *synth = [GlobalUtil speakText:string];
    synth.delegate = self;
}

- (void)speechSynthesizer:(nonnull AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(nonnull AVSpeechUtterance *)utterance {
    [self playCorrectMaleSound];
}

@end
