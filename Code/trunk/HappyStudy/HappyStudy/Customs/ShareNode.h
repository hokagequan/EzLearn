//
//  ShareNode.h
//  EasyLSP
//
//  Created by Q on 15/6/3.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ShareUtil.h"

@class ShareNode;

typedef void(^GetShareContent)(ShareType type);

@protocol ShareNodeDelegate <NSObject>

@optional
- (void)shareNode:(ShareNode *)shareNode didFinishShare:(BOOL)success;
- (void)didClickClose:(ShareNode *)shareNode;

@end

@interface ShareNode : SKSpriteNode

@property (strong, nonatomic) GetShareContent getShareContentBlock;

@property (nonatomic) ShareType type;

@property (weak, nonatomic) id<ShareNodeDelegate>delegate;

- (instancetype)initWithSize:(CGSize)size;

- (void)showInNode:(SKNode *)node;
- (void)hideShare;
- (void)doShareWithType:(ShareType)type text:(NSString *)text image:(UIImage *)image url:(NSURL *)url;
- (BOOL)handleNodeName:(NSString *)name;

@end
