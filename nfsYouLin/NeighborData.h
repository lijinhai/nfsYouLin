//
//  NeighborData.h
//  Neighbor2
//
//  Created by Macx on 16/5/27.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeighborData : NSObject

// 头像图片名字
@property (strong, nonatomic) NSString* iconName;

// 帖子标题
@property (strong, nonatomic) NSString* titleName;

// 账户昵称
@property (strong, nonatomic) NSString* accountName;

// 帖子发表时间
@property (strong, nonatomic) NSString* topicTime;

// 系统时间
@property (strong, nonatomic) NSString* systemTime;

// 发布帖子内容
@property (strong, nonatomic) NSString* publishText;

// 活动开始时间
@property (strong, nonatomic) NSString* activityStart;

// 活动结束时间
@property (strong, nonatomic) NSString* activityEnd;

// 发表图片
@property (strong, nonatomic) NSArray* picturesArray;

// 欢迎帖子或userID
@property (strong, nonatomic) NSString* senderId;
- (id) initWithDict: (NSDictionary*) dict;
@end
