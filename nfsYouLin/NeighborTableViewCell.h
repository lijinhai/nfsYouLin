//
//  NeighborTableViewCell.h
//  Neighbor2
//
//  Created by Macx on 16/5/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderFile.h"
#import "NeighborDataFrame.h"
#import "NeighborData.h"
#import "NCellDelegate.h"


@interface NeighborTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic ,assign) NSInteger rowNum;
@property (nonatomic ,assign) NSInteger sectionNum;
// 标题选择栏
@property (strong, nonatomic) UIScrollView* scrollView;

// 回复
@property(strong, nonatomic) UIControl* replyView;
@property(strong, nonatomic) UILabel* replyLabel;
@property(nonatomic, assign) NSInteger replyCount;

// 点赞
@property(strong, nonatomic) UIControl* praiseView;
@property(strong, nonatomic) UILabel* praiseLabel;
@property(strong, nonatomic) UIImageView* praiseImageView;
@property(nonatomic, assign) NSInteger praiseCount;

// 查看
@property(strong, nonatomic) UIControl* watchView;
@property(strong, nonatomic) UILabel* watchLabel;
@property(nonatomic, assign) NSInteger watchCount;

// 帖子
@property (nonatomic, strong)NeighborDataFrame *neighborDataFrame;

@property (weak, nonatomic)UIImageView *iconView;        // 头像
@property (weak, nonatomic)UILabel *titleLabel;          // 帖子标题
@property (weak, nonatomic)UILabel *accountInfoLabel;    // 用户信息标题
@property (weak, nonatomic)UILabel *timeInterval;        // 时间间隔

@property (strong, nonatomic)UIButton *hiBtn;       // 打招呼按钮


@property (weak, nonatomic)UILabel *contentLabel;        // 帖子内容
@property (strong, nonatomic)UIButton* readButton;       // 查看全文按钮
@property (strong,nonatomic)NSMutableArray *picturesView;   // 发表的图片

@property (nonatomic,assign) id<cellDelegate> delegate;

@end
