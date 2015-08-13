//
//  HSURLConnection.h
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSError.h"

typedef void(^HSHttpReqCompletion)(NSDictionary *info);
typedef void(^HSHttpReqFailure)(HSError *error);

@interface HSURLConnection : NSURLConnection

@property (strong, nonatomic) HSHttpReqCompletion completionCallback;
@property (strong, nonatomic) HSHttpReqFailure failureCallback;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSData *sendData;
@property (nonatomic) NSInteger tag;

@end
