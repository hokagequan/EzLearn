//
//  DDSModel.h
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBQuestion.h"
#import "JZBOption.h"

@interface JZBModel : NSObject

@property (strong, nonatomic) NSString *modelID;
@property (strong, nonatomic) JZBQuestion *question;
@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSString *indexStr;

- (NSString *)combineSentence;

@end
