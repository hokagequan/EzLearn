//
//  Defines.h
//  HappyStudy
//
//  Created by Q on 14-10-11.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#ifndef HappyStudy_Defines_h
#define HappyStudy_Defines_h

typedef enum {
    StudyGameNon = 0,
    StudyGameZiMuBao,
    StudyGameZiMuKuang,
    StudyGameZiMuChui,
    StudyGameTingYinShiZi,
    StudyGamePengPengShiZi,
    StudyGameShiZiChui,
    StudyGameBiHuaBao,
    StudyGamePinZiBao,
    StudyGamePinZiChui,
    StudyGamePinZiKuang,
    StudyGameZuCiBao,
    StudyGamePengPengDaCi,
    StudyGameJuZiBao,
    StudyGameJuZiQiao,
    StudyGameMax
}StudyGame;

typedef enum {
    GroupIndividual = 0,
    GroupSchool
}Group;

#define colorRGB(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]

#define kNOTIFICATION_LOADING_COMPLETE @"NOTIFICATION_LOADING_COMPLETE"
#define kNOTIFICATION_GAME_PRESENT_VIEW_CONTROLLER @"NOTIFICATION_GAME_PRESENT_VIEW_CONTROLLER"
#define kNOTIFICATION_REFRESH_CUP_INFO @"NOTIFICATION_REFRESH_CUP_INFO"

#define kPROPERTY_USER_INFO @"PROPERTY_USER_INFO"
#define kPROPERTY_PLAY_TIME @"PROPERTY_PLAY_TIME"

// Server 1
//#define HSURL @"http://54.169.15.85/EzDev/"

// Server 2
//#define HSURL @"http://54.169.15.85/KEG/"

// Server 3
#define HSURL @"http://52.74.225.18/app/interface.php?schoolid=kudospark&method="

#define WEIXIN_APP_KEY @""
#define QQ_APP_ID @""

#define FONT_NAME_CUTOON @"FZKaTong-M19S"
#define FONT_NAME_HP @"FZHuPo-M04S"
#define FONT_NAME_C @"calibri"
#define FONT_NAME_JCY @"迷你简超圆"
#define FONT_NAME_AM @"ArialMT"

#define GAME_NUM 10
#define GAME_INTERVAL 1

#define EZLEARN_DEBUG

#endif
