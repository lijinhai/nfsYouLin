//
//  PDetailTableViewCell.h
//  nfsYouLin
//
//  Created by jinhai on 16/8/26.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPostsData.h"
#import "NCellDelegate.h"
#import "HeaderFile.h"
#import "ApplyDetailView.h"

@interface PDetailTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, strong) MyPostsData* myPostsData;
@property (nonatomic,assign) id<cellDelegate> delegate;
// 第一行表格控件

// 头像
@property (weak, nonatomic)UIImageView *iconView;

// 用户信息标题
@property (weak, nonatomic)UILabel *accountInfoLabel;

// 发表时间
@property (weak, nonatomic)UILabel *timeLabel;


// 第二行表格控件
// 帖子标题
@property (weak, nonatomic)UILabel *titleLabel;

// 帖子内容
@property (weak, nonatomic)UILabel *contentLabel;

// 发表的图片
@property (strong,nonatomic)NSMutableArray *picturesView;

// 删除按钮
@property (strong,nonatomic)UIButton *deleteButton;


// 第三行表格控件

// 回复
@property(strong, nonatomic) UIView* replyView;
@property(strong, nonatomic) UILabel* replyLabel;
@property(nonatomic, assign) NSInteger replyCount;

// 点赞
@property(strong, nonatomic) UIControl* praiseView;
@property(strong, nonatomic) UILabel* praiseLabel;
@property(strong, nonatomic) UIImageView* praiseImageView;

// 其他表格行控件
// 回复人头像
@property (strong, nonatomic) UIImageView* personView;
// 回复人信息
@property (strong, nonatomic) UILabel* personLable;
// 回复时间
@property (strong, nonatomic) UILabel* replyTimeLabel;
// 回复内容
@property (strong, nonatomic) UILabel* repleyText;
// 回复文本大小
@property (nonatomic, assign) CGSize replySize;
// 回复文本内容
@property (nonatomic, assign) NSString* replyString;
// 回复或删除按钮
@property (strong, nonatomic) UIButton* otherButton;

// 报名详情
@property (strong, nonatomic)ApplyDetailView* applyView;


@end
