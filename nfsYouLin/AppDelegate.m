//
//  AppDelegate.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "AppDelegate.h"
#import "EMSDK.h"
#import "FMDB.h"
#import "Constants.h"
#import <SMS_SDK/SMSSDK.h>

#define appKey @"d3f836c7d14c"
#define appSecret @"203b2509d7f89a3a97bb44ee489f5f38"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 环信初始化
    EMOptions *options = [EMOptions optionsWithAppkey:@"walk#test"];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    EMError *error = [[EMClient sharedClient] loginWithUsername:@"test2" password:@"123456"];
    if (!error)
    {
        NSLog(@"环信登陆成功");
    }
    
    // 短信验证初始化
    [SMSSDK registerApp:appKey withSecret:appSecret];

    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (NSString *) dataFilePath//应用程序的沙盒路径
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    NSLog(@"%@",document);
    return [document stringByAppendingPathComponent:@"neighbors.db"];
}

- (void)createTable
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    NSLog(@"CREATE_TABLE_NEWS_RECEIVE id %@",CREATE_TABLE_NEWS_RECEIVE);

    if (![fileManager fileExistsAtPath:myDelegate.dbPath]) {
        NSLog(@"还未创建数据库，现在正在创建数据库");
        if ([db open]) {
            /*创建新闻接收表*/
            [db executeUpdate:CREATE_TABLE_NEWS_RECEIVE];
            /*创建推送记录表*/
            [db executeUpdate:CREATE_INDEX_NEWS_RECEIVE_LA];
            /*创建接收新闻索引*/
            [db executeUpdate:CREATE_TABLE_PUSH_RECORD];
            /*创建推送记录索引*/
            [db executeUpdate:CREATE_INDEX_PUSH_LA];
            /*创建用户表*/
            [db executeUpdate:CREATE_TABLE_USERS];
            /*创建账户索引*/
            [db executeUpdate:CREATE_INDEX_USERS_LA];
            /*创建用户索引*/
            [db executeUpdate:CREATE_INDEX_USERS_LU];
            /*创建家庭信息表*/
            [db executeUpdate:CREATE_TABLE_ALL_FAMILY];
            /*创建门牌信息表*/
            [db executeUpdate:CREATE_DOORPLATE];
            /*创建门牌索引*/
            [db executeUpdate:CREATE_INDEX_DOOR_LA];
            /*创建家庭信息索引LA*/
            [db executeUpdate:CREATE_INDEX_ALL_FAMILY_LA];
            /*创建家庭信息索引LU*/
            [db executeUpdate:CREATE_INDEX_ALL_FAMILY_LU];
            /*创建邻居表*/
            [db executeUpdate:CREATE_TABLE_NEIGHBOR];
            /*创建邻居群组表*/
            [db executeUpdate:CREATE_TABLE_NEIGHBOR_GROUP];
            /*创建邻居群组索引LA*/
            [db executeUpdate:CREATE_INDEX_NEIGHBOR_GROUP_LA];
            /*创建邻居群组索引LU*/
            [db executeUpdate:CREATE_INDEX_NEIGHBOR_GROUP_LU];
            /*创建论坛主题表*/
            [db executeUpdate:CREATE_TABLE_FORUM_TOPIC];
            /*创建论坛主题表索引LA*/
            [db executeUpdate:CREATE_INDEX_FORUM_TOPIC_LA];
            /*创建论坛主题表索引LU*/
            [db executeUpdate:CREATE_INDEX_FORUM_TOPIC_LU];
            /*创建论坛主题表索引LC*/
            [db executeUpdate:CREATE_INDEX_FORUM_TOPIC_LC];
            /*创建论坛主题表触发器*/
            [db executeUpdate:CREATE_TRIGGER_FORUM_TOPIC];
            /*创建论坛中多媒体信息表*/
            [db executeUpdate:CREATE_TABLE_FORUM_MEDIA];
            /*创建论坛中多媒体索引LA*/
            [db executeUpdate:CREATE_INDEX_FORUM_MEDIA_LA];
            /*创建论坛评论表*/
            [db executeUpdate:CREATE_TABLE_FORUM_COMMENT];
            /*创建论坛评论表索引LA*/
            [db executeUpdate:CREATE_INDEX_FORUM_COMMENT_LA];
            /*创建全部NOTE表*/
            [db executeUpdate:CREATE_TABLE_ALL_NOTE];
            /*创建NOTE表索引LA*/
            [db executeUpdate:CREATE_INDEX_ALL_NOTE_LA];
            /*创建NOTE表索引LU*/
            [db executeUpdate:CREATE_INDEX_ALL_NOTE_LU];
            /*创建NOTE表索引LC*/
            [db executeUpdate:CREATE_INDEX_ALL_NOTE_LC];
            /*创建搜索历史表*/
            [db executeUpdate:CREATE_TABLE_SEARCH_HISTORY];
            /*创建搜索历史表索引LA*/
            [db executeUpdate:CREATE_INDEX_SEARCH_HISTORY_LA];
            
            [db close];
        }else{
            NSLog(@"database open error");
        }
    }
    NSLog(@"FMDatabase:---------%@",db);
}


@end

