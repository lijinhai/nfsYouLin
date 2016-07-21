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



@end
