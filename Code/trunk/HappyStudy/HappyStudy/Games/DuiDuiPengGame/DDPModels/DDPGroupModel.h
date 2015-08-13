//
//  DDPGroupModel.h
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDPGroupModel : NSObject

@property (nonatomic) NSInteger modelID;
@property (strong, nonatomic) NSString *indexStr;
@property (strong, nonatomic) NSMutableArray *pyModels;
@property (strong, nonatomic) NSMutableArray *hzModels;

@end
