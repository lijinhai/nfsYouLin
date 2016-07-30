//
//  SqliteOperation.m
//  nfsYouLin
//
//  Created by Macx on 16/7/12.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "SqliteOperation.h"
#import "Constants.h"
#import "MBProgressHUBTool.h"

@implementation SqliteOperation

+ (BOOL) insertUsersSqlite: (NSMutableDictionary *) dict View:(UIView*) view
{
    if(!dict)
        return NO;
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    FMDatabase* db = app.db;
    if ([db open])
    {
        [db executeUpdate:INSERT_USERS_TABLE,
         dict[@"user_public_status"] ,
         dict[@"user_vocation"] ,
         dict[@"user_level"] ,
         dict[@"user_id"],
         dict[@"user_name"] ,
         dict[@"user_portrait"],
         dict[@"user_gender"] ,
         dict[@"user_phone_number"] ,
         dict[@"user_family_id"],
         dict[@"user_family_address"] ,
         dict[@"user_birthday"],
         dict[@"user_email"] ,
         dict[@"user_type"] ,
         dict[@"user_time"],
         dict[@"user_json"] ,
         dict[@"login_account"] ,
         dict[@"table_version"] ];
        //NSLog(@"USER_Family_id is %@",dict[@"user_family_id"]);
    }
    else
    {
        NSLog(@"数据库打开失败");
        [MBProgressHUBTool textToast:view Tip:@"数据库打开失败"];        [db close];
        return NO;
    }
    [db close];
    return YES;
}

+ (BOOL) insertFamilyInfoSqlite: (NSMutableDictionary *) dict View:(UIView*) view
{
    if(!dict)
    {
        NSLog(@"insertFamilyInfoSqlite return !!!");
        return NO;
    }
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    FMDatabase* db = app.db;
    if ([db open])
    {
        [db executeUpdate:INSERT_ALL_FAMILY_TABLE,
         dict[@"family_id"] ,
         dict[@"family_name"] ,
         dict[@"family_display_name"] ,
         dict[@"family_address"],
         dict[@"family_address_id"] ,
         dict[@"family_desc"],
         dict[@"family_portrait"] ,
         dict[@"family_background_color"] ,
         dict[@"family_city"],
         dict[@"family_city_id"] ,
         dict[@"family_city_code"],
         dict[@"family_block"] ,
         dict[@"family_block_id"] ,
         dict[@"family_community_id"],
         dict[@"family_community"] ,
         dict[@"family_community_nickname"] ,
         dict[@"family_building_num"] ,
         dict[@"family_building_id"] ,
         dict[@"family_apt_num"] ,
         dict[@"family_apt_id"] ,
         dict[@"is_family_member"] ,
         dict[@"is_attention"] ,
         dict[@"family_member_count"] ,
         dict[@"entity_type"] ,
         dict[@"ne_status"] ,
         dict[@"nem_status"] ,
         dict[@"primary_flag"] ,
         dict[@"belong_family_id"] ,
         dict[@"user_alias"] ,
         dict[@"user_avatar"] ,
         dict[@"login_account"] ,
         dict[@"table_version"]];
    }
    else
    {
        NSLog(@"数据库打开失败");
        [MBProgressHUBTool textToast:view Tip:@"数据库打开失败"];        [db close];
        return NO;
    }
    [db close];

    return YES;
}

+ (NSInteger) getNowCommunityId{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = delegate.db;
    
    if ( ![ db open ] )
    {
        NSLog(@"打开数据库失败");
    }
    // 查找表
    NSInteger comid=0;
    NSString *query = @"select table_all_family.family_community_id from table_users,table_all_family where table_users.user_family_id=table_all_family.family_id";
    FMResultSet* resultSet = [ db executeQuery:query];
    // 逐行读取数据
    while ( [ resultSet next ] )
    {
        // 对应字段来取数据
        comid=[ resultSet intForColumn: @"family_community_id" ];
    }
    [ db close ];
    return comid;
}

+ (long)getUserId
{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = delegate.db;
    long loginUserId=0;
    if([db open])
    {
        FMResultSet *result = [db executeQuery:@"SELECT user_id FROM table_users"];
        while ([result next]) {
            
            loginUserId = [result longForColumn:@"user_id"];
        }
        [db close];
        
        return loginUserId;
    }
    else
    {
        NSLog(@"iVC: db open error!");
        return 0;
    }
    
}
@end
