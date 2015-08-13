//
//  AccountMgr.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface AccountMgr : NSObject

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *serverUrl;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSMutableArray *awards;
@property (strong, nonatomic) NSMutableArray *tasks;

+ (instancetype)sharedInstance;
- (void)getAwardsInfo;
- (void)getTasksInfo;

@end
