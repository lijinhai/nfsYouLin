//
//  ResidentRTVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/10/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "residenterRinfo.h"
@interface ResidentRTVC : UITableViewCell

// 住户头像图片
@property(strong, nonatomic) UIImageView* headIV;

// 住户昵称标签
@property(strong, nonatomic) UILabel* nickNL;

// 报修详情标签
@property(strong, nonatomic) UILabel* repairDL;

// 报修时间标签
@property(strong, nonatomic) UILabel* repairTL;

// 审核状态标签
@property(strong, nonatomic) UILabel* repairSL;

// 住户报修列表数据
@property(strong, nonatomic) NSMutableArray* repairArray;

@property(strong, nonatomic) residenterRinfo* residenterRepairData;

//- (id)initWithFrame:(CGRect)frame;

@end
