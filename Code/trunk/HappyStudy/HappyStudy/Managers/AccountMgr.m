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
                          // TODO: 完善获取Awards
//                          NSArray *details = info[@"Awards"];
//                          for (NSDictionary *subDetails in details) {
//                              Award *award = [[Award alloc] init];
//                              award.identifier = subDetails[@"AwardID"];
//                              award.detail = subDetails[@"AwardDetail"];
//                              award.picUrl = subDetails[@"Pic"];
//                              award.credits = subDetails[@"Credits"];
//                              award.redeemable = [subDetails[@"Redeemable"] boolValue];
//                              [self.awards addObject:award];
//                          }
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_REFRESH_CUP_INFO
                                                                              object:nil];
                      } failure:^(HSError *error) {
                      }];
}

- (void)getTasksInfo {
    [HttpReqMgr requestGetTasks:self.user.name
                     completion:^(NSDictionary *info) {
                         [self.tasks removeAllObjects];
                         // TODO: 完善Tasks
//                         NSArray *details = info[@"Tasks"];
//                         for (NSDictionary *subDetails in details) {
//                             Task *task = [[Task alloc] init];
//                             task.identifier = subDetails[@"TaskID"];
//                             task.detail = subDetails[@"TaskDetail"];
//                             task.picUrl = subDetails[@"Pic"];
//                             task.redeemable = [subDetails[@"Redeemable"] boolValue];
//                             [self.tasks addObject:task];
//                         }
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_REFRESH_CUP_INFO
                                                                             object:nil];
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
