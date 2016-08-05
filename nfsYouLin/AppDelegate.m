//
//  AppDelegate.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "AppDelegate.h"
#import "EMSDK.h"
#import <SMS_SDK/SMSSDK.h>
#import "Constants.h"
#import "AFNetworkReachabilityManager.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"
#import "ChatDemoHelper.h"


#define MobAppKey @"d3f836c7d14c"
#define MobAppSecret @"203b2509d7f89a3a97bb44ee489f5f38"

#define HXAppKey @"nfs-hlj#youlinapp"
#define HXApnsCertName @"chatCertName"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:HXAppKey apnsCertName:HXApnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];

    //    [ChatDemoHelper shareHelper];
    
    //监听服务器网络变化
    [self listenNetwork];

    // 短信验证初始化
    [SMSSDK registerApp:MobAppKey withSecret:MobAppSecret];
    
    NSLog(@"创建数据库");
    self.dbPath = [self dataFilePath];
    [self createTable];
    
   
    
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

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(_friendVC)
    {
        [_friendVC didReceiveLocalNotification:notification];

    }
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString* fromId = [userInfo valueForKey:@"f"];
    if(_friendVC)
    {
      
        [_friendVC jumpToChatList:fromId];
    }
}
//应用程序的沙盒路径
- (NSString *) dataFilePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    NSLog(@"%@",document);
    return [document stringByAppendingPathComponent:@"youLin-IOS.db"];
}

- (void)createTable
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.db = [FMDatabase databaseWithPath:myDelegate.dbPath];


//    NSLog(@"INSERT_USERS_TABLE =  %@",INSERT_USERS_TABLE);

    if (![fileManager fileExistsAtPath:myDelegate.dbPath]) {
        NSLog(@"还未创建数据库，现在正在创建数据库");
        if ([self.db open]) {
            /*创建新闻接收表*/
            [self.db executeUpdate:CREATE_TABLE_NEWS_RECEIVE];
            /*创建推送记录表*/
            [self.db executeUpdate:CREATE_INDEX_NEWS_RECEIVE_LA];
            /*创建接收新闻索引*/
            [self.db executeUpdate:CREATE_TABLE_PUSH_RECORD];
            /*创建推送记录索引*/
            [self.db executeUpdate:CREATE_INDEX_PUSH_LA];
            /*创建用户表*/
            [self.db executeUpdate:CREATE_TABLE_USERS];
            /*创建账户索引*/
            [self.db executeUpdate:CREATE_INDEX_USERS_LA];
            /*创建用户索引*/
            [self.db executeUpdate:CREATE_INDEX_USERS_LU];
            /*创建家庭信息表*/
            [self.db executeUpdate:CREATE_TABLE_ALL_FAMILY];
            /*创建门牌信息表*/
            [self.db executeUpdate:CREATE_DOORPLATE];
            /*创建门牌索引*/
            [self.db executeUpdate:CREATE_INDEX_DOOR_LA];
            /*创建家庭信息索引LA*/
            [self.db executeUpdate:CREATE_INDEX_ALL_FAMILY_LA];
            /*创建家庭信息索引LU*/
            [self.db executeUpdate:CREATE_INDEX_ALL_FAMILY_LU];
            /*创建邻居表*/
            [self.db executeUpdate:CREATE_TABLE_NEIGHBOR];
            /*创建邻居群组表*/
            [self.db executeUpdate:CREATE_TABLE_NEIGHBOR_GROUP];
            /*创建邻居群组索引LA*/
            [self.db executeUpdate:CREATE_INDEX_NEIGHBOR_GROUP_LA];
            /*创建邻居群组索引LU*/
            [self.db executeUpdate:CREATE_INDEX_NEIGHBOR_GROUP_LU];
            /*创建论坛主题表*/
            [self.db executeUpdate:CREATE_TABLE_FORUM_TOPIC];
            /*创建论坛主题表索引LA*/
            [self.db executeUpdate:CREATE_INDEX_FORUM_TOPIC_LA];
            /*创建论坛主题表索引LU*/
            [self.db executeUpdate:CREATE_INDEX_FORUM_TOPIC_LU];
            /*创建论坛主题表索引LC*/
            [self.db executeUpdate:CREATE_INDEX_FORUM_TOPIC_LC];
            /*创建论坛主题表触发器*/
            [self.db executeUpdate:CREATE_TRIGGER_FORUM_TOPIC];
            /*创建论坛中多媒体信息表*/
            [self.db executeUpdate:CREATE_TABLE_FORUM_MEDIA];
            /*创建论坛中多媒体索引LA*/
            [self.db executeUpdate:CREATE_INDEX_FORUM_MEDIA_LA];
            /*创建论坛评论表*/
            [self.db executeUpdate:CREATE_TABLE_FORUM_COMMENT];
            /*创建论坛评论表索引LA*/
            [self.db executeUpdate:CREATE_INDEX_FORUM_COMMENT_LA];
            /*创建全部NOTE表*/
            [self.db executeUpdate:CREATE_TABLE_ALL_NOTE];
            /*创建NOTE表索引LA*/
            [self.db executeUpdate:CREATE_INDEX_ALL_NOTE_LA];
            /*创建NOTE表索引LU*/
            [self.db executeUpdate:CREATE_INDEX_ALL_NOTE_LU];
            /*创建NOTE表索引LC*/
            [self.db executeUpdate:CREATE_INDEX_ALL_NOTE_LC];
            /*创建搜索历史表*/
            [self.db executeUpdate:CREATE_TABLE_SEARCH_HISTORY];
            /*创建搜索历史表索引LA*/
            [self.db executeUpdate:CREATE_INDEX_SEARCH_HISTORY_LA];
            [self.db close];
        }else{
            NSLog(@"database open error");
        }
    }
    NSLog(@"FMDatabase:---------%@",self.db);
}

//- (void) reachabilityChanged: (NSNotification *)note
//{
//    Reachability* curReach = [note object];
//    NetworkStatus status = [curReach currentReachabilityStatus];
//    NSLog(@"reachabilityChanged = %ld",status);
//    if(status == NotReachable)
//    {
////        [MBProgressHUBTool textToast:self Tip:@"网络连接异常"];
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"服务器网络连接异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//    }
//    
//}

- (void) listenNetwork
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                // 未知网络
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"网络连接异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
                // 手机自带网络
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [manager startMonitoring];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"walk----------device Token = %@---------walk",deviceToken);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

@end

