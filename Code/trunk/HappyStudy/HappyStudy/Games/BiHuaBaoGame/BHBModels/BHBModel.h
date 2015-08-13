//
//  DDSModel.h
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHBQuestion.h"
#import "BHBOption.h"

@interface BHBModel : NSObject

@property (strong, nonatomic) NSString *modelID;
@property (strong, nonatomic) BHBQuestion *question;
@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSString *indexStr;

@end
