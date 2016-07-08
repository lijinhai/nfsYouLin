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

@end
