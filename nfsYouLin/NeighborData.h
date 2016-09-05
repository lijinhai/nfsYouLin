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

// 帖子类别
@property (strong, nonatomic) NSString* topicCategory;


// 活动开始时间
@property (strong, nonatomic) NSString* activityStart;

// 活动结束时间
@property (strong, nonatomic) NSString* activityEnd;

// 帖子信息(例:活动开始时间和结束时间等)
@property(strong, nonatomic) NSMutableArray* infoArray;

// 发表图片
@property (strong, nonatomic) NSArray* picturesArray;

// 欢迎帖子或userID
@property (strong, nonatomic) NSString* senderId;

// 欢迎帖子是否为·userID
@property (strong, nonatomic) NSString* cacheKey;

// 欢迎帖子ID
@property (strong, nonatomic) NSString* topicId;

// 回复个数
@property (strong, nonatomic) NSString* replyCount;

// 点赞个数
@property (strong, nonatomic) NSString* praiseCount;

// 点赞状态
@property (strong, nonatomic) NSString* praiseType;

// 浏览次数
@property (strong, nonatomic) NSString* viewCount;

// 收藏状态
@property(strong, nonatomic) NSString* collectStatus;

// 帖子类型
@property(strong, nonatomic) NSString* objectType;
// 发布范围
@property(strong, nonatomic) NSString* forumName;


@property(strong, nonatomic) NSString* topicCategoryType;

@property(strong, nonatomic)NSArray* objectData;

- (id) initWithDict: (NSDictionary*) dict;
- (id) setWithDict:(NSDictionary*) dict;

@end
