//
//  CupScene.m
//  EasyLSP
//
//  Created by Q on 15/6/3.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "CupScene.h"
#import "CupCell.h"
#import "AccountMgr.h"
#import "UIImageView+WebCache.h"

typedef enum {
    SegTypeAwards = 0,
    SegTypeTasks,
}SegType;

@interface CupScene()<UITableViewDataSource, UITableViewDelegate, CupCellDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tabButtons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tabBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic) SegType segType;

@end

@implementation CupScene

- (void)awakeFromNib {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CupCell" bundle:nil]
         forCellReuseIdentifier:@"CupCell"];
    
    self.backgroundImageView.image = [UIImage imageNamed:@"common_alert_bg"];
    self.tabBackgroundImageView.image = [UIImage imageNamed:@"cup_tab"];
    [self.closeButton setImage:[UIImage imageNamed:@"about_close"]
                      forState:UIControlStateNormal];
    
    for (UIButton *button in self.tabButtons) {
        button.titleLabel.font = [UIFont fontWithName:FONT_NAME_HP
                                                 size:[UniversalUtil universalFontSize:25]];
    }
    
    [self segmentDidSelect:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)clickAwards {
    self.segType = SegTypeAwards;
}

- (void)clickTasks {
    self.segType = SegTypeTasks;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (BOOL)isShowing {
    return self.superview != nil;
}

- (void)reloadInfos {
    [self.tableView reloadData];
}

- (void)segmentDidSelect:(NSInteger)index {
    for (UIButton *button in self.tabButtons) {
        button.selected = button.tag == index;
    }
    
    switch (index) {
        case 0:
            [self clickAwards];
            break;
        case 1:
            [self clickTasks];
            break;
            
        default:
            break;
    }
}

- (void)showInView:(UIView *)view {
    self.frame = view.bounds;
    [view addSubview:self];
    [view bringSubviewToFront:self];
}

#pragma mark - Class Function
+ (instancetype)sceneFromNib {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CupScene" owner:nil options:nil];
    for (UIView *view in nibs) {
        if ([view isKindOfClass:[CupScene class]]) {
            return (CupScene *)view;
        }
    }
    
    return nil;
}

#pragma mark - Actions
- (IBAction)clickClose:(id)sender {
    [self dismiss];
}

- (IBAction)clickTab:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self segmentDidSelect:button.tag];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segType) {
        case SegTypeAwards:
            return [AccountMgr sharedInstance].awards.count;
        case SegTypeTasks:
            return [AccountMgr sharedInstance].tasks.count;
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *details;
    if (self.segType == SegTypeAwards) {
        details = [AccountMgr sharedInstance].awards;
    }
    else if (self.segType == SegTypeTasks) {
        details = [AccountMgr sharedInstance].tasks;
    }
    
    Task *task = details[indexPath.row];
    
    CupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CupCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:task.picUrl]];
    cell.titleLab.text = task.detail;
    
    return cell;
}

#pragma mark - CupCellDelegate
- (void)didClickExchange:(CupCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cupScene:didClickExchange:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Task *task = nil;
        if (self.segType == SegTypeAwards) {
            task = [AccountMgr sharedInstance].awards[indexPath.row];
        }
        else if (self.segType == SegTypeTasks) {
            task = [AccountMgr sharedInstance].tasks[indexPath.row];
        }
        
        [self.delegate cupScene:self didClickExchange:task];
    }
}

#pragma mark - Property
- (void)setSegType:(SegType)segType {
    _segType = segType;
    
    [self reloadInfos];
}

@end
