//
//  SqlDictionary.m
//  nfsYouLin
//
//  Created by Macx on 16/7/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "SqlDictionary.h"

@implementation SqlDictionary


- (NSMutableDictionary *) getInitUserDictionary
{
    
        /*@ "id integer primary key autoincrement, ",@"user_public_status integer default 0, ",@"user_vocation text, ",@"user_level text, ",@"user_id bigint, ",@"user_name text, ",@"user_portrait text, ",@"user_gender integer default 3, ",@"user_phone_number text, ",@"user_family_id bigint, ",@"user_family_address text, ",@"user_birthday integer default 0, ",@"user_email text, ",@"user_type integer default 0, ",@"user_time bigint default 0, ",@"user_json text, ",@"login_account bigint, ",@"table_version integer */

    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInteger:0], @"user_public_status",
        @"", @"user_vocation",
        @"", @"user_level",
        [NSNumber numberWithLong:0], @"user_id",
        @"", @"user_name",
        @"", @"user_portrait",
        [NSNumber numberWithInteger:3], @"user_gender",
        @"", @"user_phone_number",
        [NSNumber numberWithLong:0], @"user_family_id",
        @"" ,@"user_family_address",
        [NSNumber numberWithInteger:0], @"user_birthday",
        @"", @"user_email",
        [NSNumber numberWithInteger:0], @"user_type",
        [NSNumber numberWithLong:0], @"user_time",
        @"", @"user_json",
        [NSNumber numberWithLong:0], @"login_account",
        [NSNumber numberWithInteger:0], @"table_version", nil];
    
    return dic;
}

- (NSMutableDictionary *)getInitFamilyInfoDic
{
   /*   @"family_id bigint" ,
        @"family_name  text" ,
        @"family_display_name text" ,
        @"family_address  text" ,
        @"family_address_id bigint" ,
        @"family_desc text" ,
        @"family_portrait text" ,
        @"family_background_color  integer default 0"
        @"family_city  text" ,
        @"family_city_id bigint" ,
        @"family_city_code text" ,
        @"family_block text" ,
        @"family_block_id bigint" ,
        @"family_community_id bigint" ,
        @"family_community text" ,
        @"family_community_nickname text" ,
        @"family_building_num text" ,
        @"family_building_id bigint" ,
        @"family_apt_num text" ,
        @"family_apt_id bigint ",
        @"is_family_member integer default 0" ,
        @"is_attention integer default 0" ,
        @"family_member_count integer default 0" ,
        @"entity_type integer" ,
        @"ne_status integer" ,
        @"nem_status integer" ,
        @"primary_flag integer default 0" ,
        @"belong_family_id bigint default 0" ,
        @"user_alias text" ,
        @"user_avatar text" ,
        @"login_account bigint" ,
        @"table_version integer" */
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithLong:0] , @"family_id",
        @"", @"family_name" ,
        @"", @"family_display_name" ,
        @"", @"family_address" ,
        [NSNumber numberWithLong:0],@"family_address_id" ,
        @"", @"family_desc" ,
        @"", @"family_portrait" ,
        [NSNumber numberWithInteger:0], @"family_background_color",
        @"", @"family_city",
        [NSNumber numberWithLong:0], @"family_city_id",
        @"", @"family_city_code" ,
        @"", @"family_block" ,
        [NSNumber numberWithLong:0], @"family_block_id",
        [NSNumber numberWithLong:0], @"family_community_id" ,
        @"", @"family_community" ,
        @"", @"family_community_nickname" ,
        @"", @"family_building_num" ,
        [NSNumber numberWithLong:0],@"family_building_id" ,
        @"", @"family_apt_num" ,
        [NSNumber numberWithLong:0], @"family_apt_id",
        [NSNumber numberWithInteger:0], @"is_family_member" ,
        [NSNumber numberWithInteger:0], @"is_attention" ,
        [NSNumber numberWithInteger:0], @"family_member_count" ,
        [NSNumber numberWithInteger:0], @"entity_type" ,
        [NSNumber numberWithInteger:0], @"ne_status" ,
        [NSNumber numberWithInteger:0], @"nem_status" ,
        [NSNumber numberWithInteger:0], @"primary_flag" ,
        [NSNumber numberWithLong:0], @"belong_family_id" ,
        @"", @"user_alias text" ,
        @"", @"user_avatar text" ,
        [NSNumber numberWithLong:0], @"login_account" ,
        [NSNumber numberWithInteger:0], @"table_version",
        nil];
    
    return dict;
}

@end
