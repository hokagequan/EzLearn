//
//  ShareUtil.h
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

typedef enum {
    ShareTypeTwitter = 0,
    ShareTypeWeibo,
    ShareTypeFacebook,
    ShareTypeWeixin,
    ShareTypeQQ
}ShareType;

@interface ShareUtil : NSObject<WXApiDelegate>

+ (instancetype)sharedInstance;

- (void)shareWithType:(ShareType)type text:(NSString *)text image:(UIImage *)image url:(NSURL *)url completeHandler:(void (^)(BOOL))completion;

@end
