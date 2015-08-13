//
//  HSError.h
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRspErrorUtil.h"

@interface HSError : NSObject

@property (strong, nonatomic) NSString *message;
@property (nonatomic) HSHttpErrorCode code;

+ (HSError *)errorWith:(HSHttpErrorCode)code;
+ (HSError *)errorWithError:(NSError *)error;

@end
