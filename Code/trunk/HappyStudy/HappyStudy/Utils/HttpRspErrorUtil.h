//
//  HttpRspErrorUtil.h
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum uint8_t {
    HSHttpErrorCodeUserName = 1000,
    HSHttpErrorCodeServer,
    HSHttpErrorCodeNoData,
    HSHttpErrorCodeTimeOut,
    HSHttpErrorCodeLoginFailed,
}HSHttpErrorCode;

@interface HttpRspErrorUtil : NSObject

+ (NSString *)messageWith:(HSHttpErrorCode)errorCode;

@end
