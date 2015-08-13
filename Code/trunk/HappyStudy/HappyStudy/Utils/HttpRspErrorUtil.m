//
//  HttpRspErrorUtil.m
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HttpRspErrorUtil.h"

@implementation HttpRspErrorUtil

+ (NSString *)messageWith:(HSHttpErrorCode)errorCode {
    switch (errorCode) {
        case HSHttpErrorCodeUserName:
            return @"Wrong User Name";
        case HSHttpErrorCodeServer:
            return @"Connection Error";
        case HSHttpErrorCodeNoData:
            return @"No Game";
        case HSHttpErrorCodeTimeOut:
            return @"Link to server time out， please check your internet connection";
            
        default:
            break;
    }
    
    return nil;
}

@end
