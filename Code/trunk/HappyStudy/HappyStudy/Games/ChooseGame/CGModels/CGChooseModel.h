//
//  CGChooseModel.h
//  HappyStudy
//
//  Created by Q on 14-10-15.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGQuestionModel.h"
#import "CGOptionModel.h"

@interface CGChooseModel : NSObject

@property (nonatomic) NSInteger modelID;
@property (strong, nonatomic) NSString *indexStr;
@property (strong, nonatomic) CGQuestionModel *question;
@property (strong, nonatomic) NSMutableArray *options;

@end
