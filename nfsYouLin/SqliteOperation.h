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

// 新闻表插入
+ (BOOL) insertNewsSqlite: (NSMutableDictionary *) dict View:(UIView*) view;


// 查询用户所在社区的ID
+ (NSInteger) getNowCommunityId;

// 获取用户ID
+ (long)getUserId;

// 更新用户的职业信息
+(void)updateUserWorkInfo:(long)userId userVocation:(NSString*)uv publicStatus:(NSInteger) ps;

// 更新用户头像信息
+(void)updateUserPhotoInfo:(long)userId photoUrl:(NSString*)url;

// 更新用户昵称
+(void)updateUserNickInfo:(long)userId nickName:(NSString*)name;

+(void)showMyTopicInfo;
// 插入新用户信息
+(BOOL)insertNewFamilyInfoSqlite: (NSMutableDictionary *) dict;
// 更新用户地址信息
+(BOOL)updateChangeFamilyInfoSqlite:(NSMutableDictionary *) dict famliyId:(NSString*)fid;

// 查找building_num_id
+(NSInteger)selectBuildingNumIdSqlite:(long)addressId;

// 判断当前地址是否通过审核
+(BOOL)checkAudiAddressResult;

// 获取用户当前地址
+(NSString*)getUserNowAddressSqlite;
@end
