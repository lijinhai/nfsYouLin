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
#import "ApplyDetailView.h"

@interface NeighborTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic ,assign) NSInteger rowNum;
@property (nonatomic ,assign) NSInteger sectionNum;
// 标题选择栏
@property (strong, nonatomic) UIScrollView* scrollView;

// 回复
@property(strong, nonatomic) UIControl* replyView;
@property(strong, nonatomic) UILabel* replyLabel;

// 点赞
@property(strong, nonatomic) UIControl* praiseView;
@property(strong, nonatomic) UILabel* praiseLabel;
@property(strong, nonatomic) UIImageView* praiseImageView;

// 查看
@property(strong, nonatomic) UIControl* watchView;
@property(strong, nonatomic) UILabel* watchLabel;


// 帖子数据
@property (nonatomic, strong)NeighborDataFrame *neighborDataFrame;

// 评论数据
@property (nonatomic, strong)NeighborData *replyData;

// 头像
@property (weak, nonatomic)UIImageView *iconView;

// 帖子标题
@property (weak, nonatomic)UILabel *titleLabel;

// 用户信息标题
@property (weak, nonatomic)UILabel *accountInfoLabel;

// 时间间隔
@property (weak, nonatomic)UILabel *timeInterval;

// 打招呼按钮
@property (strong, nonatomic)UIButton *hiBtn;

// 报名详情
@property (strong, nonatomic)ApplyDetailView* applyView;


// 帖子内容
@property (weak, nonatomic)UILabel *contentLabel;


// 查看全文按钮
//@property (strong, nonatomic)UIButton* readButton;
@property (strong, nonatomic)UIButton* readButton;


// 删除按钮
@property (strong, nonatomic)UIButton* deleteButton;

// 发表的图片
@property (strong,nonatomic)NSMutableArray *picturesView;

// 活动过期图片
@property (strong, nonatomic)UIImageView *pastImageView;

// 新闻
@property (strong, nonatomic)UIControl* newsView;
@property (strong, nonatomic)UIImageView* newsIV;
@property (strong, nonatomic)UILabel* newsTitleL;


// 私信
@property(strong, nonatomic) UIControl* letterView;
@property(strong, nonatomic) UILabel* letterLabel;
@property (strong, nonatomic)UIImageView* letterIV;

// 进度
@property(strong, nonatomic) UIControl* scheduleView;
@property(strong, nonatomic) UILabel* scheduleLabel;
@property (strong, nonatomic)UIImageView* scheduleIV;

@property (nonatomic,assign) id<cellDelegate> delegate;

@end
