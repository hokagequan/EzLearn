//
//  PengPengDaCiScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "PengPengDaCiScene.h"
#import "DDPMgr.h"
#import "DDPCharacter.h"

@implementation PengPengDaCiScene

#pragma mark - Override
- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    DDPMgr *mgr = [DDPMgr sharedInstance];
    
    if (fromPos == 0) {
        [mgr loadPengPengDaCiServerGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *info) {
            if (failure) {
                failure(info);
            }
        }];
    }
    else {
        [mgr loadPengPengDaCiServerMoreGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *info) {
            if (failure) {
                failure(info);
            }
        }];
    }
}

- (void)checkMatch {
    if (self.selectCharacters.count < 2) {
        return;
    }
    
    DDPCharacter *character1 = self.selectCharacters[0];
    DDPCharacter *character2 = self.selectCharacters[1];
    if ([character1.matchKey isEqualToString:character2.matchKey]) {
        // Match
        [self playSoundCorrectCompletion:^{
            [GlobalUtil speakText:character1.matchKey];
        }];
        character1.requestedAnimation = HSAnimationStateDeath;
        character2.requestedAnimation = HSAnimationStateDeath;
        [self.selectCharacters removeAllObjects];
    }
    else {
        // Not match
        [self playSoundWrong];
        character1.selected = NO;
        character2.selected = NO;
        [self.selectCharacters removeAllObjects];
    }
}

@end
