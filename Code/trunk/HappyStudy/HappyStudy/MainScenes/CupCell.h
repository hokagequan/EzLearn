//
//  CupCell.h
//  EasyLSP
//
//  Created by Q on 15/6/4.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CupCell;

@protocol CupCellDelegate <NSObject>

- (void)didClickExchange:(CupCell *)cell;

@end

@interface CupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (weak, nonatomic) IBOutlet UIView *border;

@property (weak, nonatomic) id<CupCellDelegate>delegate;

@end
