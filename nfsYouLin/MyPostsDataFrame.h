//
//  MyPostsDataFrame.h
//  nfsYouLin
//
//  Created by jinhai on 16/8/26.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPostsData.h"
@interface MyPostsDataFrame : NSObject

// 头像位置大小
@property (nonatomic, assign) CGRect iconFrame;

// 帖子名称位置大小
@property (nonatomic, assign) CGRect titleFrame;

// 账户信息位置大小
@property (nonatomic, assign) CGRect accountInfoFrame;

// 发表时间位置大小
@property (nonatomic, assign) CGRect timeFrame;

// 时间间隔位置大小
@property (nonatomic, assign) CGRect intervalFrame;

// 打招呼隔位置大小
@property (nonatomic, assign) CGRect hiFrame;

// 活动过期图片位置
@property (nonatomic, assign) CGRect pastIVFrame;


// 帖子内容位置大小
@property (nonatomic, assign) CGRect textFrame;


// 帖子行数
@property (nonatomic, assign) NSInteger textCount;

// 查看全文位置大小
@property (nonatomic, assign) CGRect readFrame;

// 报名详情
@property (nonatomic, assign) CGPoint applyPoint;

// 删除位置大小
@property (nonatomic, assign) CGRect deleteFrame;

// 图片位置大小集合
@property (nonatomic, strong) NSMutableArray* picturesFrame;

// 表格高度
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) MyPostsData * myPostsData;
@end
