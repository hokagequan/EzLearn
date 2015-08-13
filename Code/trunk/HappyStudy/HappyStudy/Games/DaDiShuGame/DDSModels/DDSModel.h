//
//  DDSModel.h
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSQuestion.h"
#import "DDSOption.h"

@interface DDSModel : NSObject

@property (strong, nonatomic) NSString *modelID;
@property (strong, nonatomic) NSString *indexStr;
@property (strong, nonatomic) DDSQuestion *question;
@property (strong, nonatomic) NSMutableArray *options;

@end
