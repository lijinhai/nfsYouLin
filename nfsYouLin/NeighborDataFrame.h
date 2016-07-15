//
//  NeighborDataFrame.h
//  Neighbor2
//
//  Created by Macx on 16/5/30.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NeighborData.h"
#import "HeaderFile.h"

@interface NeighborDataFrame : NSObject
//@property (strong, nonatomic) NSArray* picturesArray;    // 发表图片
@property (nonatomic, assign) CGRect iconFrame;             // 头像位置大小
@property (nonatomic, assign) CGRect titleFrame;            // 帖子名称位置大小
@property (nonatomic, assign) CGRect accountInfoFrame;      // 账户信息位置大小
@property (nonatomic, assign) CGRect timeFrame;             // 发表时间位置大小

@property (nonatomic, assign) CGRect intervalFrame;   // 时间间隔位置大小

@property (nonatomic, assign) CGRect hiFrame;   // 打招呼隔位置大小

@property (nonatomic, assign) CGRect textFrame;             // 帖子内容位置大小
@property (nonatomic, assign) NSInteger textCount;          // 帖子行数
@property (nonatomic, assign) CGRect readFrame;             // 查看全文位置大小
@property (nonatomic, strong) NSMutableArray* picturesFrame; // 图片位置大小集合
@property (nonatomic, assign) CGFloat cellHeight;           // 表格高度

@property (nonatomic, strong) NeighborData* neighborData;

@end
