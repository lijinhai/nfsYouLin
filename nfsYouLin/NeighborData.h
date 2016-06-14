//
//  NeighborData.h
//  Neighbor2
//
//  Created by Macx on 16/5/27.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeighborData : NSObject

@property (strong, nonatomic) NSString* titleCategory;  // 帖子类别
@property (strong, nonatomic) NSString* iconName;       // 头像图片名字
@property (strong, nonatomic) NSString* titleName;      // 帖子名称
@property (strong, nonatomic) NSString* accountName;    // 账户昵称
@property (strong, nonatomic) NSString* addressInfo;    // 地址信息
@property (strong, nonatomic) NSString* publishTime;     // 发表时间
@property (strong, nonatomic) NSString* dateTime;       // 发表日期时间
@property (strong, nonatomic) NSString* publishText;     // 发表内容
@property (strong, nonatomic) NSString* activityStart;  // 活动开始时间
@property (strong, nonatomic) NSString* activityEnd;    // 活动结束时间


@property (strong, nonatomic) NSArray* picturesArray;    // 发表图片
- (id) initWithDict: (NSDictionary*) dict;
@end
