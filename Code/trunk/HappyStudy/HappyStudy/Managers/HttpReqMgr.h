//
//  HttpReqMgr.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSURLConnection.h"
#import "HSError.h"

@interface HttpReqMgr : NSObject

+ (instancetype)sharedInstance;

+ (void)requestCheckUser:(NSString *)userName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestSubmit:(NSString *)userName game:(StudyGame)game theID:(NSString *)theID spendTime:(NSInteger)second clickNum:(NSInteger)clickNum clickArray:(NSArray *)clickArray isCorrect:(BOOL)isCorrect individual:(BOOL)isIndividual completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestSubMitTotalGame:(NSString *)userName game:(StudyGame)game spendTime:(NSInteger)second totalQuestions:(NSInteger)totalCount TotalCorrectQuestions:(NSInteger)totalCorrectCount individual:(BOOL)isIndividual completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestGetGameData:(NSString *)userName from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestGetServerUrl:(NSString *)schoolID IPAdress:(NSString *)ipAddr completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestIndividualLoginWith:(NSString *)gameCenterID name:(NSString *)gameCenterName identifier:(NSString *)identifier completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestGetGameData:(NSString *)userName gameID:(StudyGame)gameID from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestIndividualGetGameData:(NSString *)userName gameID:(StudyGame)gameID level:(NSInteger)level from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestGetShareContent:(NSString *)userName gameID:(StudyGame)gameID completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestGetAppShareContent:(NSString *)userName score:(NSInteger)score playTime:(NSTimeInterval)playtime completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

// type -> 0:Awards 1:Tasks
+ (void)requestGetCupShareContent:(NSString *)userName identifier:(NSString *)identifier shareID:(NSString *)shareID type:(NSInteger)type completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

// type -> 0:Awards 1:Tasks
+ (void)requestRedeemCup:(NSString *)userName identifier:(NSString *)identifier shareID:(NSString *)shareID type:(NSInteger)type completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestGetAwards:(NSString *)userName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestGetTasks:(NSString *)userName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

+ (void)requestSubmitSchoolInfo:(NSString *)userName schoolName:(NSString *)schoolName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

- (void)requestWithMethod:(NSString *)method params:(NSDictionary *)params completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

@end
