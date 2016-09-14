//
//  Constants.h
//  nfsYouLin
//
//  Created by jinhai on 16/6/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
#pragma clang diagnostic ignored "-Wextern-initializer"
static const int DB_VERSION = 1;
/*定义表名*/
static NSString * const TABLE_NAME_USERS          = @"table_users";
static NSString * const TABLE_ALL_FAMILY          = @"table_all_family";
static NSString * const TABLE_NAME_NEIGHBOR       = @"table_neighbor";
static NSString * const TABLE_NAME_NEIGHBOR_GROUP = @"table_neighbor_group";
static NSString * const TABLE_NAME_FORUM_TOPIC    = @"table_forum_topic";
static NSString * const TABLE_NAME_FORUM_COMMENT  = @"table_forum_comment";
static NSString * const TABLE_NAME_FORUM_MEDIA    = @"table_forum_media" ;
static NSString * const TABLE_NAME_ALL_NOTE       = @"table_all_note";
static NSString * const TABLE_NAME_SEARCH_HISTORY = @"table_search_history";
static NSString * const TABLE_DOOR_PLATE          = @"tabel_doorplate";
static NSString * const TABLE_PUSH_RECORD         = @"table_push_record";
static NSString * const TABLE_NEWS_RECEIVE         = @"table_news_receive";




/*创建表-宏定义*/



#define CREATE_TABLE_NEWS_RECEIVE [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ",TABLE_NEWS_RECEIVE,@" (",@"_id integer primary key autoincrement, ",@"news_first integer, ",@"news_title text, ",@"news_pic text, ",@"news_url text, ",@"news_belongs integer, ",@"news_id integer, ",@"news_send_time integer, ",@"news_push_time integer, ",@"news_others text, ",@"table_version integer)"]

#define CREATE_INDEX_NEWS_RECEIVE_LA  [NSString stringWithFormat:@"%@%@%@",@"CREATE INDEX news_belongs_index on ", TABLE_NEWS_RECEIVE,@"(news_belongs)"]

#define CREATE_TABLE_PUSH_RECORD [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ", TABLE_PUSH_RECORD,@" (",@"_id integer primary key autoincrement, ",@"user_id bigint, ",@"type integer, ",@"content_type integer, ",@"record_id bigint, ",@"content text, ",@"click_url text, ",@"push_time bigint, ",@"login_account bigint, ",@"community_id bigint, ",@"table_version integer)"]

#define CREATE_INDEX_PUSH_LA [NSString stringWithFormat:@"%@%@%@",@"CREATE INDEX push_record_index on ",TABLE_PUSH_RECORD,@"(login_account)"]

#define CREATE_TABLE_USERS [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ",TABLE_NAME_USERS,@" (",@"id integer primary key autoincrement, ",@"user_public_status integer default 0, ",@"user_vocation text, ",@"user_level text, ",@"user_id bigint, ",@"user_name text, ",@"user_portrait text, ",@"user_gender integer default 3, ",@"user_phone_number text, ",@"user_family_id bigint, ",@"user_family_address text, ",@"user_birthday integer default 0, ",@"user_email text, ",@"user_type integer default 0, ",@"user_time bigint default 0, ",@"user_json text, ",@"login_account bigint, ",@"table_version integer)"]

#define CREATE_INDEX_USERS_LA [NSString stringWithFormat:@"%@%@%@",@"CREATE INDEX account_index on ",TABLE_NAME_USERS,@"(login_account)"]

#define CREATE_INDEX_USERS_LU [NSString stringWithFormat:@"%@%@%@",@"CREATE INDEX user_index on ",TABLE_NAME_USERS,@"(login_account, user_id)"]

#define CREATE_TABLE_ALL_FAMILY [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ",TABLE_ALL_FAMILY,@" (",@"_id integer primary key autoincrement, ",@"family_id bigint, ",@"family_name  text, ",@"family_display_name text, ",@"family_address  text, ",@"family_address_id bigint, ",@"family_desc text, ",@"family_portrait text , ",@"family_background_color  integer default 0, ",@"family_city  text,",@"family_city_id bigint, ",@"family_city_code text, ",@"family_block text, ",@"family_block_id bigint, ",@"family_community_id bigint, ",@"family_community text, ",@"family_community_nickname text, ",@"family_building_num text, ",@"family_building_id bigint, ",@"family_apt_num text, ",@"family_apt_id bigint, ",@"is_family_member integer default 0, ",@"is_attention integer default 0, ",@"family_member_count integer default 0, ",@"entity_type integer, ",@"ne_status integer, ",@"nem_status integer, ",@"primary_flag integer default 0, ",@"belong_family_id bigint default 0, ",@"user_alias text, ",@"user_avatar text, ",@"login_account bigint, ",@"table_version integer) "]

#define CREATE_DOORPLATE [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ",TABLE_DOOR_PLATE,@" (",@"_id integer primary key autoincrement, ",@"doorplate_id bigint, ",@"apt_number intger, ",@"displayname text, ",@"avatarpath text, ",@"user_count intger, ",@"livingStatus intger, ",@"belong_community_id bigint, ",@"login_account bigint, ",@"table_version integer) "]

#define CREATE_INDEX_DOOR_LA [NSString stringWithFormat:@"%@%@%@",@"CREATE INDEX door_community_index on ",TABLE_DOOR_PLATE,@" (belong_community_id)"]

#define CREATE_INDEX_ALL_FAMILY_LA [NSString stringWithFormat:@"%@%@%@",@"CREATE INDEX family_account_index on ",TABLE_ALL_FAMILY,@"(login_account)"]

#define CREATE_INDEX_ALL_FAMILY_LU [NSString stringWithFormat:@"%@%@%@",@"CREATE INDEX family_index on ",TABLE_ALL_FAMILY,@"(login_account, belong_family_id)"]

#define CREATE_TABLE_NEIGHBOR [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ",TABLE_NAME_NEIGHBOR,@" (",@"_id integer primary key autoincrement, ",@"user_id bigint, ",@"user_name text, ",@"user_family_id bigint, ",@"user_portrait text, ",@"user_phone_number text, ",@"distance integer, ",@"briefdesc text, ",@"profession text, ",@"addrstatus text, ",@"building_num text, ",@"aptnum text, ",@"belong_family_id bigint default 0, ",@"data_type int, ",@"user_type int, ",@"login_account bigint, ",@"table_version integer)"]

#define CREATE_TABLE_NEIGHBOR_GROUP [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ",TABLE_NAME_NEIGHBOR_GROUP,@" (",@"_id integer primary key autoincrement, ",@"neighbor_group_id bigint, ",@"neighbor_group_name text, ",@"neighbor_group_avatar text, ",@"neighbor_group_creater_id bigint, ",@"neighbor_group_creater_family_id bigint, ",@"neighbor_group_type integer default 1, ",@"neighbor_group_description text, ",@"neighbor_group_member_count integer, ",@"neighbor_group_private_flag integer default 1, ",@"neighbor_group_add_type integer default 0, ",@"neighbor_group_display_mode integer default 0, ",@"neighbor_group_follow_flag integer default 0, ",@"neighbor_group_shield_flag integer default 0, ",@"neighbor_group_bg_color integer default 0, ",@"neighbor_group_create_time bigint, ",@"community_id bigint default 0, ",@"postPrivilege integer default 0, ",@"deleteable integer default 1, ",@"belong_family_id bigint default 0, ",@"user_display_name text, ",@"ne_display_name text, ",@"subscribed_status integer default 0, ",@"key_words text, ",@"visible_scope integer default 0, ",@"category_name text, ",@"category_id integer, ",@"manager_flag integer default 0, ",@"login_account bigint, ",@"table_version integer)"]

#define CREATE_INDEX_NEIGHBOR_GROUP_LA [NSString stringWithFormat:@"%@%@%@",@"CREATE INDEX neighbor_account_index on ",TABLE_NAME_NEIGHBOR_GROUP,@"(login_account)"]

#define CREATE_INDEX_NEIGHBOR_GROUP_LU [NSString stringWithFormat:@"%@%@%@",@"CREATE INDEX neighbor_belong_family_index on ",TABLE_NAME_NEIGHBOR_GROUP,@"(login_account, belong_family_id)"]

#define CREATE_TABLE_FORUM_TOPIC [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ",TABLE_NAME_FORUM_TOPIC,@" (",@"_id integer primary key autoincrement, ",@"cache_key integer, ",@"topic_id bigint UNIQUE, ",@"forum_id bigint, ",@"forum_name text, ",@"circle_type integer, ",@"sender_nc_role integer, ",@"sender_id bigint, ",@"sender_community_id bigint, ",@"sender_name text, ",@"sender_lever text, ",@"sender_portrait text, ",@"sender_family_id bigint, ",@"sender_family_address text, ",@"display_name text, ",@"topic_time bigint, ",@"topic_title text, ",@"topic_content text, ",@"topic_category_type integer, ",@"comment_num integer default 0, ",@"like_num integer default 0, ",@"send_status integer default 0, ",@"like_status integer default 0, ",@"visiable_type integer, ",@"login_account bigint, ",@"topic_url text, ",@"forward_path text, ",@"forward_refer_id integer default 0, ",@"object_type integer default 0, ",@"object_data text, ",@"hot_flag text, ",@"view_num integer, ",@"media_files_json text, ",@"comments_summary text, ",@"table_version integer)"]

#define CREATE_INDEX_FORUM_TOPIC_LA [NSString stringWithFormat:@"%@%@%@", @"CREATE INDEX forum_account_index on ",TABLE_NAME_FORUM_TOPIC,@"(login_account)"]

#define CREATE_INDEX_FORUM_TOPIC_LU [NSString stringWithFormat:@"%@%@%@", @"CREATE INDEX forum_index on ",TABLE_NAME_FORUM_TOPIC,@"(login_account, forum_id)"]

#define CREATE_INDEX_FORUM_TOPIC_LC [NSString stringWithFormat:@"%@%@%@", @"CREATE INDEX forum_cache_index on ",TABLE_NAME_FORUM_TOPIC,@"(login_account, cache_key)"]

#define CREATE_TRIGGER_FORUM_TOPIC [NSString stringWithFormat:@"%@%@%@%@%@%@%@", @" CREATE TRIGGER trigger_delete_topic DELETE ON ",TABLE_NAME_FORUM_TOPIC,@" BEGIN DELETE FROM ",TABLE_NAME_FORUM_COMMENT,@" WHERE login_account = old.login_account AND cache_key = old.cache_key AND topic_id = old.topic_id; DELETE FROM ",TABLE_NAME_FORUM_MEDIA,@" WHERE login_account = old.login_account AND object_id = old._id; END"]

#define CREATE_TABLE_FORUM_MEDIA [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ",TABLE_NAME_FORUM_MEDIA,@" (",@"_id integer primary key autoincrement, ",@"cache_key integer, ",@"object_id bigint, ",@"object_main_id integer, ",@"object_type integer, ",@"media_type integer default 0, ",@"media_url text, ",@"media_file_key text, ",@"title text, ",@"description text, ",@"link text, ",@"send_status integer default 0, ",@"login_account bigint, ",@"table_version integer)"]

#define CREATE_INDEX_FORUM_MEDIA_LA [NSString stringWithFormat:@"%@%@%@", @"CREATE INDEX media_account_index on ",TABLE_NAME_FORUM_MEDIA,@"(login_account)"]

#define CREATE_TABLE_FORUM_COMMENT [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", @"CREATE TABLE if not exists ",TABLE_NAME_FORUM_COMMENT,@" (",@"_id integer primary key autoincrement, ",@"cache_key integer, ",@"comment_id bigint, ",@"topic_id bigint, ",@"sender_nc_role_id integer, ",@"sender_id bigint, ",@"sender_name text, ",@"sender_portrait text, ",@"sender_family_id bigint, ",@"sender_family_address text, ",@"sender_level text, ",@"display_name text, ",@"comment_content text, ",@"comment_time bigint, ",@"comment_image_url text, ",@"comment_content_type integer default 0, ",@"send_status integer default 0, ",@"read_status integer default 0, ",@"login_account bigint, ",@"media_type integer default 0, ",@"media_url text, ",@"table_version integer)"]

#define CREATE_INDEX_FORUM_COMMENT_LA [NSString stringWithFormat:@"%@%@%@", @"CREATE INDEX comment_account_index on ",TABLE_NAME_FORUM_COMMENT,@"(login_account)"]

#define CREATE_TABLE_ALL_NOTE [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", @"CREATE TABLE if not exists ",TABLE_NAME_ALL_NOTE,@" (",@"note_id bigint, ",@"note_content_type integer default 0, ",@"note_content text, ",@"note_time timestamp, ",@"note_res_send_type integer default 0, ",@"note_send_status integer default 1, ",@"note_read_status integer default 0, ",@"note_is_local integer default 0, ",@"note_object_type integer, ",@"note_object_id bigint, ",@"note_sender_family_id integer, ",@"note_sender_id integer, ",@"belong_family_id bigint default 0, ",@"login_account bigint, ",@"table_version integer)"]

#define CREATE_INDEX_ALL_NOTE_LA [NSString stringWithFormat:@"%@%@%@", @"CREATE INDEX note_account_index on ",TABLE_NAME_ALL_NOTE,@"(login_account)"]

#define CREATE_INDEX_ALL_NOTE_LU [NSString stringWithFormat:@"%@%@%@", @"CREATE INDEX note_belong_family_index on ",TABLE_NAME_ALL_NOTE,@"(login_account, belong_family_id)"]

#define CREATE_INDEX_ALL_NOTE_LC [NSString stringWithFormat:@"%@%@%@", @"CREATE INDEX note_index on ",TABLE_NAME_ALL_NOTE,@"(login_account, belong_family_id, note_object_type, note_object_id)"]

#define CREATE_TABLE_SEARCH_HISTORY [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",@"CREATE TABLE if not exists ",TABLE_NAME_SEARCH_HISTORY,@" (",@"_id integer primary key autoincrement, ",@"search_type integer, ",@"search_object_id bigint, ",@"search_word text, ",@"search_time bigint, ",@"login_account bigint, ",@"table_version integer)"]

#define CREATE_INDEX_SEARCH_HISTORY_LA [NSString stringWithFormat:@"%@%@%@", @"CREATE INDEX search_history_index on ",TABLE_NAME_SEARCH_HISTORY,@"(login_account)"]

// 用户表插入
#define INSERT_USERS_TABLE [NSString stringWithFormat:@"INSERT INTO %@ (user_public_status, user_vocation, user_level, user_id, user_name, user_portrait, user_gender, user_phone_number, user_family_id, user_family_address, user_birthday, user_email, user_type, user_time, user_json, login_account, table_version) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",TABLE_NAME_USERS]


// 新闻表插入
#define INSERT_NEWS_TABLE [NSString stringWithFormat:@"INSERT INTO %@ (news_first, news_title, news_pic, news_url, news_belongs, news_id, news_send_time, news_push_time, news_others, table_version) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",TABLE_NEWS_RECEIVE]


// 家庭信息表插入
#define INSERT_ALL_FAMILY_TABLE [NSString stringWithFormat:@"INSERT INTO %@ (family_id, family_name, family_display_name, family_address, family_address_id, family_desc, family_portrait, family_background_color, family_city, family_city_id, family_city_code, family_block, family_block_id, family_community_id, family_community, family_community_nickname, family_building_num, family_building_id, family_apt_num, family_apt_id, is_family_member, is_attention, family_member_count, entity_type, ne_status, nem_status, primary_flag, belong_family_id, user_alias, user_avatar, login_account, table_version) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",TABLE_ALL_FAMILY]



#endif /* Constants_h */
