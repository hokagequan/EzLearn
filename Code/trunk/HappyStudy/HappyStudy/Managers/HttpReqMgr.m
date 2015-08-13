//
//  HttpReqMgr.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "HSURLConnection.h"
#import "HttpRspErrorUtil.h"
#import "NSDate+HSCustom.h"

@interface HttpReqMgr ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@end

@implementation HttpReqMgr

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)requestWithMethod:(NSString *)method params:(NSDictionary *)params completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    if (!method) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", HSURL, method]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HSURL, method]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:25];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSData *data = nil;
        if (params) {
            data = [NSJSONSerialization dataWithJSONObject:params
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
            [request setHTTPBody:data];
        }
        
        HSURLConnection *connection = [[HSURLConnection alloc] initWithRequest:request delegate:self];
        connection.completionCallback = completion;
        connection.failureCallback = failure;
        connection.sendData = data;
        [connection start];
    });
}

#pragma mark - Class Function
+ (instancetype)sharedInstance {
    static HttpReqMgr *_sharedHttpReqMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHttpReqMgr = [[self alloc] init];
    });
    
    return _sharedHttpReqMgr;
}

+ (void)requestCheckUser:(NSString *)userName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    [[HttpReqMgr sharedInstance] requestWithMethod:@"checkuser"
                                            params:@{@"StudentID": userName}
                                        completion:^(NSDictionary *info) {
                                            BOOL success = [info[@"IsSuccess"] boolValue];
                                            if (success) {
                                                [AccountMgr sharedInstance].user.score = 0;
                                                if (completion) {
                                                    completion(nil);
                                                }
                                            }
                                            else {
                                                HSError *error = [HSError errorWith:HSHttpErrorCodeUserName];
                                                if (failure) {
                                                    failure(error);
                                                }
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestSubmit:(NSString *)userName game:(StudyGame)game theID:(NSString *)theID spendTime:(NSInteger)second clickNum:(NSInteger)clickNum clickArray:(NSArray *)clickArray isCorrect:(BOOL)isCorrect individual:(BOOL)isIndividual completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"GameID"] = [NSString stringWithFormat:@"%@", @(game - 1)];
    params[@"QuizID"] = theID;
    params[@"SpentTime"] = [NSString stringWithFormat:@"%@", @(second)];
    
    NSInteger year, month, day, hour, min, sec;
    [[NSDate date] year:&year
                  month:&month
                    day:&day
                   hour:&hour
                    min:&min
                 second:&sec];
    params[@"SubmitDate"] = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld", (long)year, (long)month, (long)day, (long)hour, (long)min, (long)sec];
    params[@"ClickNo"] = [NSString stringWithFormat:@"%@", @(clickNum)];
    params[@"ClickArray"] = clickArray;
    params[@"IsCorrect"] = [NSString stringWithFormat:@"%@", @(isCorrect)];
    
    NSString *method = @"ind_submitlogs";
    
    if (!isIndividual) {
        method = @"submitlogs";
    }
    
    [[HttpReqMgr sharedInstance] requestWithMethod:method
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestSubMitTotalGame:(NSString *)userName game:(StudyGame)game spendTime:(NSInteger)second totalQuestions:(NSInteger)totalCount TotalCorrectQuestions:(NSInteger)totalCorrectCount individual:(BOOL)isIndividual completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    if (!isIndividual) {
        if (completion) {
            completion(nil);
        }
        
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"GameID"] = [NSString stringWithFormat:@"%@", @(game - 1)];
    params[@"SpentTime"] = [NSString stringWithFormat:@"%@", @(second)];
    
    NSInteger year, month, day, hour, min, sec;
    [[NSDate date] year:&year
                  month:&month
                    day:&day
                   hour:&hour
                    min:&min
                 second:&sec];
    params[@"SubmitDate"] = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld", (long)year, (long)month, (long)day, (long)hour, (long)min, (long)sec];
    params[@"TotalQuestions"] = [NSString stringWithFormat:@"%@", @(totalCount)];
    params[@"TotalCorrectQuestions"] = @(totalCorrectCount);
    
    [[HttpReqMgr sharedInstance] requestWithMethod:@"ind_submittotallogs"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestGetServerUrl:(NSString *)schoolID IPAdress:(NSString *)ipAddr completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"SchoolID"] = schoolID;
    params[@"IPAddress"] = ipAddr;
    [[HttpReqMgr sharedInstance] requestWithMethod:@"getserverurl"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            [AccountMgr sharedInstance].serverUrl = info[@"URL"];
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestIndividualLoginWith:(NSString *)gameCenterID name:(NSString *)gameCenterName identifier:(NSString *)identifier completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginID"] = gameCenterID ? gameCenterID : @"";
    params[@"loginName"] = gameCenterName ? gameCenterName : @"";
    params[@"loginMachine"] = identifier ? identifier : @"";
    [[HttpReqMgr sharedInstance] requestWithMethod:@"ind_getstudentid"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if ([info[@"IsSuccess"] integerValue] == 1) {
                                                [AccountMgr sharedInstance].user.name = info[@"StudentID"];
                                                if (completion) {
                                                    completion(info);
                                                }
                                            }
                                            else {
                                                HSError *error = [[HSError alloc] init];
                                                error.message = @"登录失败";
                                                error.code = HSHttpErrorCodeLoginFailed;
                                                if (failure) {
                                                    failure(error);
                                                }
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestGetGameData:(NSString *)userName gameID:(StudyGame)gameID from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"GameID"] = [NSString stringWithFormat:@"%@", @(gameID - 1)];
    params[@"QuestionPos"] = [NSString stringWithFormat:@"%@", @(fromPos)];
    params[@"QuestionNumber"] = [NSString stringWithFormat:@"%@", @(count)];
    params[@"QuestionOrder"] = @"1";
    [[HttpReqMgr sharedInstance] requestWithMethod:@"getquestions"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestIndividualGetGameData:(NSString *)userName gameID:(StudyGame)gameID level:(NSInteger)level from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"GameID"] = [NSString stringWithFormat:@"%@", @(gameID - 1)];
    params[@"QuestionPos"] = [NSString stringWithFormat:@"%@", @(fromPos)];
    params[@"QuestionNumber"] = [NSString stringWithFormat:@"%@", @(count)];
    params[@"DifficultLevel"] = [NSString stringWithFormat:@"%ld", (long)level];
    [[HttpReqMgr sharedInstance] requestWithMethod:@"ind_getquestions"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestGetShareContent:(NSString *)userName gameID:(StudyGame)gameID completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"GameID"] = [NSString stringWithFormat:@"%@", @(gameID - 1)];
    [[HttpReqMgr sharedInstance] requestWithMethod:@"ind_getgameshareinfo"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestGetAppShareContent:(NSString *)userName score:(NSInteger)score playTime:(NSTimeInterval)playtime completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"HeartNumber"] = [NSString stringWithFormat:@"%@", @(score)];
    params[@"TotalTime"] = [NSString stringWithFormat:@"%@", @(playtime / 60)];
    [[HttpReqMgr sharedInstance] requestWithMethod:@"ind_getappshareinfo"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestGetCupShareContent:(NSString *)userName identifier:(NSString *)identifier shareID:(NSString *)shareID type:(NSInteger)type completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSString *method = @"ind_getawardshareinfo";
    if (type == 1) {
        method = @"ind_gettaskshareinfo";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"AwardID"] = identifier;
    params[@"TaskID"] = identifier;
    params[@"shareID"] = shareID;
    [[HttpReqMgr sharedInstance] requestWithMethod:method
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestGetAwards:(NSString *)userName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    [[HttpReqMgr sharedInstance] requestWithMethod:@"ind_getawards"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestGetTasks:(NSString *)userName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    [[HttpReqMgr sharedInstance] requestWithMethod:@"ind_gettasks"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestRedeemCup:(NSString *)userName identifier:(NSString *)identifier shareID:(NSString *)shareID type:(NSInteger)type completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSString *method = @"ind_redeemawards";
    if (type == 1) {
        method = @"ind_redeemtasks";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"AwardID"] = identifier;
    params[@"TaskID"] = identifier;
    params[@"shareID"] = shareID;
    [[HttpReqMgr sharedInstance] requestWithMethod:method
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestSubmitSchoolInfo:(NSString *)userName schoolName:(NSString *)schoolName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"SchoolName"] = schoolName;
    [[HttpReqMgr sharedInstance] requestWithMethod:@"ind_submitschoolinfo"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestGetGameData:(NSString *)userName from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    // 子类继承
}

#pragma mark - NSURLConnection
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
//    if (![connection isKindOfClass:[HSURLConnection class]]) {
//        return request;
//    }
//
//    HSURLConnection *hsConnection = (HSURLConnection *)connection;
//
//    NSMutableURLRequest *newReq = [request mutableCopy];
//    [newReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [newReq setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [newReq setHTTPMethod:@"POST"];
//    [newReq setHTTPBody:hsConnection.sendData];
//
//    NSLog(@"*****req: %@", [newReq allHTTPHeaderFields]);
//    NSLog(@"*****rsp: %@", response);
//
//    return newReq;
//}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    NSLog(@"%@", [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse *)response).statusCode]);
//    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (![connection isKindOfClass:[HSURLConnection class]]) {
        return;
    }
    
    HSURLConnection *hsConnection = (HSURLConnection *)connection;
    [hsConnection.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (![connection isKindOfClass:[HSURLConnection class]]) {
        return;
    }
    
    HSURLConnection *hsConnection = (HSURLConnection *)connection;
    HSError *hsError = [HSError errorWithError:error];
    if (hsConnection.failureCallback) {
        hsConnection.failureCallback(hsError);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (![connection isKindOfClass:[HSURLConnection class]]) {
        return;
    }
    
    HSURLConnection *hsConnection = (HSURLConnection *)connection;
    NSLog(@"%@", [[NSString alloc] initWithData:hsConnection.receivedData encoding:NSUTF8StringEncoding]);
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hsConnection.receivedData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    if (hsConnection.completionCallback) {
        hsConnection.completionCallback(dict);
    }
}

@end
