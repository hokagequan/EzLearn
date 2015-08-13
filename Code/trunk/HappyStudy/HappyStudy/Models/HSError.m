//
//  HSError.m
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSError.h"

@implementation HSError

+ (HSError *)errorWith:(HSHttpErrorCode)code {
    HSError *hsError = [[HSError alloc] init];
    hsError.code = code;
    hsError.message = [HttpRspErrorUtil messageWith:hsError.code];
    
    return hsError;
}

+ (HSError *)errorWithError:(NSError *)error {
    if (!error) {
        return nil;
    }
    
    if (error.code == -1001) {
        return [HSError errorWith:HSHttpErrorCodeTimeOut];
    }
    
    HSError *hsError = [[HSError alloc] init];
    hsError.code = (int)error.code;
    hsError.message = error.localizedDescription;
    
    return hsError;
}

@end
