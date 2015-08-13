//
//  DDSModel.h
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMKQuestion.h"

@interface ZMKModel : NSObject

@property (strong, nonatomic) NSString *modelID;
@property (strong, nonatomic) NSString *indexStr;
@property (strong, nonatomic) ZMKQuestion *question;
@property (strong, nonatomic) NSMutableArray *options;

- (void)reloadOptions;

@end
