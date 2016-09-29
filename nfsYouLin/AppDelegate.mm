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
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"


// shareSDK
#define ShareAppKey @"cb8c74d24313"

// 微信
#define WXAppKey @"wx38036faf60feca57"
#define WXSecret @"8a5c6564f70db435954f3c45b1e61122"

// QQ 十六进制41DE8D71
#define QQAppId @"1105104241"
#define QQAppKey @"wK2WD08ddCM2ZIrt"

// Mob
#define MobAppKey @"d3f836c7d14c"
#define MobAppSecret @"203b2509d7f89a3a97bb44ee489f5f38"

// 环信
#define HXAppKey @"nfs-hlj#youlinapp"
#define HXApnsCertName @"production"

// 极光
#define JGAppKey @"64de302e0f10c70af07b0ed4"
static NSString *channel = @"Publish channel";
static BOOL isProduction = true;

// 百度地图Key
#define BMAP_KEY @"BDiQ7UU9TW9vUv81GUh1Ej2WlRyUXM6n"
@interface AppDelegate ()

@end

@implementation AppDelegate
{
    BMKMapManager* _mapManager;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 百度地图，启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BMAP_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图manager start failed!");
    }
    else
    {
        NSLog(@"百度地图manager start success!");
    }

    
    // 环信初始化
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:HXAppKey apnsCertName:HXApnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];

    // 极光初始化
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JGAppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // shareSDK 初始化
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:ShareAppKey
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeTencentWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                              redirectUri:@"http://www.sharesdk.cn"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeTencentWeibo:
                      //设置腾讯微博应用信息
                      [appInfo SSDKSetupTencentWeiboByAppKey:@"801307650"
                                                   appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                                 redirectUri:@"http://www.sharesdk.cn"];
                      break;
                  case SSDKPlatformTypeFacebook:
                      //设置Facebook应用信息，其中authType设置为只用Web形式授权
//                      [appInfo SSDKSetupFacebookByApiKey:@"107704292745179"
//                                               appSecret:@"38053202e1a5fe26c80c753071f0b573"
//                                                authType:SSDKAuthTypeWeb];
                      break;
                  case SSDKPlatformTypeTwitter:
                      //设置Twitter应用信息
//                      [appInfo SSDKSetupTwitterByConsumerKey:@"LRBM0H75rWrU9gNHvlEAA2aOy"
//                                              consumerSecret:@"gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G"
//                                                 redirectUri:@"http://mob.com"];
                      break;
                  case SSDKPlatformTypeWechat:
                      //设置微信应用信息
                      [appInfo SSDKSetupWeChatByAppId:WXAppKey
                                            appSecret:WXSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:QQAppId
                                           appKey:QQAppKey
                                         authType:SSDKAuthTypeSSO];
                      break;
                  default:
                      break;
              }
          }];

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
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];

    if(_friendVC)
    {
        [_friendVC didReceiveLocalNotification:notification];

    }
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"收到推送消息"
                              message:userInfo[@"aps"][@"alert"]
                              delegate:nil
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    completionHandler(UIBackgroundFetchResultNewData);

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
    [fileManager removeItemAtPath:self.dbPath error:nil];

    
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
    // 环信
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
    // 极光
    [JPUSHService registerDeviceToken:deviceToken];

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


// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    
    
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"收到xx推送消息"
                          message:content
                          delegate:nil
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定",nil];
    [alert show];

    
    NSLog(@"content = %@",content);
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
}


@end





@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end


