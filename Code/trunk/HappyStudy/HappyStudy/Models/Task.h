//
//  Task.h
//  EasyLSP
//
//  Created by Q on 15/6/4.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *picUrl;
@property (nonatomic) BOOL redeemable;

@end
