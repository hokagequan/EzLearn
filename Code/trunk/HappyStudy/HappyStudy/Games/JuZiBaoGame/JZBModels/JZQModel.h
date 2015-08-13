//
//  JZQModel.h
//  EasyLSP
//
//  Created by Q on 15/6/10.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZQModel : NSObject

@property (strong, nonatomic) NSString *modelID;
@property (strong, nonatomic) NSString *indexStr;
@property (strong, nonatomic) NSMutableArray *words;
@property (strong, nonatomic) NSString *sentence;

- (void)loadIndexWithSentence:(NSString *)sentence;

@end
