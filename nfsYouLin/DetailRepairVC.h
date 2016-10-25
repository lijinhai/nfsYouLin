//
//  DetailRepairVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/10/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeighborData.h"
#import "residenterRinfo.h"

@interface DetailRepairVC : UIViewController

@property(nonatomic,strong)NSMutableArray *userADAry;
@property (nonatomic, strong) NeighborData* neighborData;
// 头像
@property (strong, nonatomic)UIImageView *iconView;

// 用户信息标题
@property (strong, nonatomic)UILabel *accountInfoLabel;

// 发表时间
@property (strong, nonatomic)UILabel *timeLabel;


// 帖子标题
@property (strong, nonatomic)UILabel *titleLabel;

// 帖子内容
@property (strong, nonatomic)UILabel *contentLabel;

// 发表的图片
@property (strong,nonatomic)NSMutableArray *picturesView;

// 定位图片
@property (strong, nonatomic)UIImageView *dingweiView;

// 楼栋门牌
@property (strong, nonatomic)UILabel *floorNumLab;

// 维修状态
@property (strong,nonatomic)NSString *repairF;

@end
