//
//  AccountMgr.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "AccountMgr.h"
#import "HttpReqMgr.h"
#import "Award.h"
#import "Task.h"

#import <AdSupport/AdSupport.h>

@implementation AccountMgr

+ (instancetype)sharedInstance {
    static AccountMgr *_sharedAccountMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAccountMgr = [[self alloc] init];
    });
    
    return _sharedAccountMgr;
}

- (id)init {
    if (self = [super init]) {
        self.user = [[User alloc] init];
        self.identifier = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    
    return self;
}

- (void)getAwardsInfo {
    [HttpReqMgr requestGetAwards:self.user.name
                      completion:^(NSDictionary *info) {
                          [self.awards removeAllObjects];
                          if ([info isKindOfClass:[NSArray class]]) {
                              NSArray * array = (NSArray *)info;
                              for (int i = 0; i < array.count; i++) {
                                  NSArray *detail = array[i];
                                  Award *award = [[Award alloc] init];
                                  award.identifier = detail[0];
                                  award.detail = detail[1];
                                  award.picUrl = detail[2];
                                  award.credits = detail[3];
                                  award.redeemable = [detail[4] boolValue];
                                  [self.awards addObject:award];
                              }
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_REFRESH_CUP_INFO
                                                                                  object:nil];
                          }
                      } failure:^(HSError *error) {
                      }];
}

- (void)getTasksInfo {
    [HttpReqMgr requestGetTasks:self.user.name
                     completion:^(NSDictionary *info) {
                         [self.tasks removeAllObjects];
                         if ([info isKindOfClass:[NSArray class]]) {
                             NSArray * array = (NSArray *)info;
                             for (int i = 0; i < array.count; i++) {
                                 NSArray *detail = array[i];
                                 Task *task = [[Task alloc] init];
                                 task.identifier = detail[0];
                                 task.detail = detail[1];
                                 task.picUrl = detail[2];
                                 task.redeemable = [detail[3] boolValue];
                                 [self.tasks addObject:task];
                             }
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_REFRESH_CUP_INFO
                                                                                 object:nil];
                         }
                     } failure:^(HSError *error) {
                     }];
}

#pragma mark - Property
- (NSMutableArray *)awards {
    if (!_awards) {
        _awards = [NSMutableArray array];
    }
    
    return _awards;
}

- (NSMutableArray *)tasks {
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    
    return _tasks;
}

@end
