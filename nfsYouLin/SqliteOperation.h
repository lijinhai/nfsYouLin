//
//  SqliteOperation.h
//  nfsYouLin
//
//  Created by Macx on 16/7/12.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface SqliteOperation : NSObject

// 用户表插入
+ (BOOL) insertUsersSqlite: (NSMutableDictionary *) dict View:(UIView*) view;

// 家庭信息表插入
+ (BOOL) insertFamilyInfoSqlite: (NSMutableDictionary *) dict View:(UIView*) view;

// 查询用户所在社区的ID
+ (NSInteger) getNowCommunityId;

// 获取用户ID
+ (long)getUserId;
@end
