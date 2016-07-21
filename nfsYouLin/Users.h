//
//  Users.h
//  nfsYouLin
//
//  Created by Macx on 16/7/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Users : NSObject
/*@ "id integer primary key autoincrement, ",@"user_public_status integer default 0, ",@"user_vocation text, ",@"user_level text, ",@"user_id bigint, ",@"user_name text, ",@"user_portrait text, ",@"user_gender integer default 3, ",@"user_phone_number text, ",@"user_family_id bigint, ",@"user_family_address text, ",@"user_birthday integer default 0, ",@"user_email text, ",@"user_type integer default 0, ",@"user_time bigint default 0, ",@"user_json text, ",@"login_account bigint, ",@"table_version integer */


@property(nonatomic, assign) NSInteger publicStatus;
@property(nonatomic, copy) NSString* vocation;
@property(nonatomic, copy) NSString* level;
@property(nonatomic, assign) long userId;
@property(nonatomic, copy) NSString* userName;
@property(nonatomic, copy) NSString* userPortrait;
@property(nonatomic, assign) NSInteger userGender;
@property(nonatomic, copy) NSString* phoneNum;
@property(nonatomic, assign) long familyId;
@property(nonatomic, copy) NSString* familyAddress;
@property(nonatomic, assign) NSInteger userBirthday;
@property(nonatomic, copy) NSString* userEmail;
@property(nonatomic, assign) NSInteger userType;
@property(nonatomic, assign) long userTime;
@property(nonatomic, copy) NSString* userJson;
@property(nonatomic, assign) long loginAccount;
@property(nonatomic, assign) NSInteger tableVersion;
@end
