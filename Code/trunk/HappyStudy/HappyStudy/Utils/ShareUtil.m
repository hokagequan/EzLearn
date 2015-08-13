//
//  ShareUtil.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ShareUtil.h"
#import "WXApiObject.h"

#import <Social/Social.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ShareUtil() {
    void(^shareCompletion)(BOOL success);
}

@end

@implementation ShareUtil

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        case EQQAPIQQNOTINSTALLED:
        case EQQAPIQQNOTSUPPORTAPI:
        case EQQAPISENDFAILD: {
            if (shareCompletion) {
                shareCompletion(NO);
            }
            
            break;
        }
        case EQQAPISENDSUCESS: {
            if (shareCompletion) {
                shareCompletion(YES);
            }
        }
            break;
        default:
        {
            break;
        }
    }
}

- (void)shareWithType:(ShareType)type text:(NSString *)text image:(UIImage *)image url:(NSURL *)url completeHandler:(void (^)(BOOL))completion {
    if (completion) {
        shareCompletion = completion;
    }
    
    if (type == ShareTypeTwitter) {
        [self systemShareWithServiceType:SLServiceTypeTwitter
                                    text:text
                                   image:image url:url];
    }
    else if (type == ShareTypeWeibo) {
        [self systemShareWithServiceType:SLServiceTypeSinaWeibo
                                    text:text
                                   image:image
                                     url:url];
    }
    else if (type == ShareTypeFacebook) {
        [self systemShareWithServiceType:SLServiceTypeFacebook
                                    text:text
                                   image:image
                                     url:url];
    }
    else if (type == ShareTypeWeixin) {
        [self shareToWeixin:text image:image url:url];
    }
    else if (type == ShareTypeQQ) {
        [self shareToQQ:text image:image url:url];
    }
}

- (void)systemShareWithServiceType:(NSString *)serviceType text:(NSString *)text image:(UIImage *)image url:(NSURL *)url {
    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    
    SLComposeViewControllerCompletionHandler completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultCancelled) {
            if (shareCompletion) {
                shareCompletion(NO);
            }
        }
        else if (result == SLComposeViewControllerResultDone) {
            if (shareCompletion) {
                shareCompletion(YES);
            }
        }
        
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    vc.completionHandler = completionHandler;
    
    if (text) {
        [vc setInitialText:text];
    }
    
    if (image) {
        [vc addImage:image];
    }
    
    if (url) {
        [vc addURL:url];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_GAME_PRESENT_VIEW_CONTROLLER
                                                        object:vc];
}

- (void)shareToWeixin:(NSString *)text image:(UIImage *)image url:(NSURL *)url {
    WXMediaMessage *wxmessage = [WXMediaMessage message];
    if (text) {
        wxmessage.description = text;
    }
    
    if (url) {
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = [url absoluteString];
        
        wxmessage.mediaObject = ext;
    }
    
    if (image) {
        WXImageObject *img = [WXImageObject object];
        img.imageData = UIImageJPEGRepresentation(image, 1.0);
        wxmessage.mediaObject = img;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = wxmessage;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)shareToQQ:(NSString *)text image:(UIImage *)image url:(NSURL *)url {
    SendMessageToQQReq* req = nil;
    
    if (image) {
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(image, 1)
                                                   previewImageData:UIImageJPEGRepresentation(image, 0.1)
                                                              title:@"Ez-Learn"
                                                        description:text ? text : @""];
        req = [SendMessageToQQReq reqWithContent:imgObj];
    }
    else if (url) {
        QQApiURLObject *urlObj = [QQApiURLObject objectWithURL:url
                                                         title:@"Ez-Learn"
                                                   description:text ? text : @""
                                               previewImageURL:nil
                                             targetContentType:QQApiURLTargetTypeNews];
        req = [SendMessageToQQReq reqWithContent:urlObj];
    }
    else if (text) {
        QQApiTextObject *textObj = [QQApiTextObject objectWithText:text];
        req = [SendMessageToQQReq reqWithContent:textObj];
    }
    
    if (req) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
    }
}

#pragma mark - Class Function
+ (instancetype)sharedInstance {
    static ShareUtil *_sharedShareUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedShareUtil = [[ShareUtil alloc] init];
    });
    
    return _sharedShareUtil;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp {
    switch (resp.errCode) {
        case 0: {
            if (shareCompletion) {
                shareCompletion(YES);
            }
        }
            break;
        case -2: {
            if (shareCompletion) {
                shareCompletion(NO);
            }
        }
            break;
        default:
            break;
    }
}

@end
