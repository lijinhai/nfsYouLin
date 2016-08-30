//
//  FirstTabBarController.m
//  nfsYouLin
//
//  Created by Macx on 16/6/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FirstTabBarController.h"
#import "CreateTopicVC.h"
#import "BackgroundView.h"
#import "ListTableView.h"
#import "ChatDemoHelper.h"
#import "AppDelegate.h"
#import "NeighborTVC.h"
#import "DiscoveryTVC.h"
#import "ITVC.h"
#import "PersonModel.h"
#import "AFHTTPSessionManager.h"
#import "JPUSHService.h"
#import "CreateActivityVC.h"

@implementation FirstTabBarController
{
    ListTableView* _listTableView;
    BackgroundView* _backGroundView;
    DiscoveryTVC* _discoveryVC;
    NeighborTVC* _neighborVC;
    ITVC* _iVC;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidLoad
{
//    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
//    statusView.backgroundColor = [UIColor blackColor];
//    [self.navigationController.navigationBar addSubview:statusView];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = self;
    
    // 环信登录
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSLog(@"userid = %@",userId);
//    EMOptions *options = [EMOptions optionsWithAppkey:@"nfs-hlj#youlinapp"];
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
//    EMError *error = [[EMClient sharedClient] loginWithUsername:userId password:userId];
    
    
    [[EMClient sharedClient] asyncLoginWithUsername:userId password:userId success:^{
        NSLog(@"环信登陆成功");
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* nick = [defaults stringForKey:@"nick"];
        NSLog(@"环信nick = %@",nick);
        //设置环信推送设置
        [[EMClient sharedClient] setApnsNickname:nick];
        
        EMPushOptions *options = [[EMClient sharedClient] pushOptions];
        options.displayStyle = EMPushDisplayStyleMessageSummary;
        [[EMClient sharedClient] updatePushOptionsToServer];

    } failure:^(EMError *aError) {
        NSLog(@"环信登录失败 aError:%@",aError);
    }];
    
    // 设置极光推送设置
    [JPUSHService setTags:nil
                    alias:@"youlin_alias_10000"
         callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                   target:self];
    [self JGPushSetNet];
    
    [self setupSubviews];
    [ChatDemoHelper shareHelper].discoveryVC = _discoveryVC;
    [ChatDemoHelper shareHelper].neighborVC = _neighborVC;
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    if(!app.friendVC)
    {
        app.friendVC = [[FriendsVC alloc] init];
        
    }

    [ChatDemoHelper shareHelper];
    [[ChatDemoHelper shareHelper] asyncPushOptions];
    [ChatDemoHelper shareHelper].friendVC = app.friendVC;
    [ChatDemoHelper shareHelper].mainVC = self;
    UIViewController* controller = self;
    _listTableView = [[ListTableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 150, CGRectGetMaxY(self.navigationController.navigationBar.frame), 150, 200)];
    
    _backGroundView = [[BackgroundView alloc] initWithFrame:self.parentViewController.view.frame view:_listTableView];
    BackgroundView* backGroundView = _backGroundView;
    NSArray* nameArray = @[@"新建话题", @"发起活动", @"闲品会", @"邀请"];
    NSArray* imageArray = @[@"huati", @"huodong", @"change", @"nav_yaoqinghaoyou"];

    [_listTableView setListTableView:nameArray image:imageArray block:^(NSString* string){
        NSLog(@"string = %@",string);
        [backGroundView removeFromSuperview];
        if([string isEqualToString:@"新建话题"])
        {
            NSLog(@"开始新建话题~~");
            CreateTopicVC* topicVC = [[CreateTopicVC alloc] init];
            [controller.navigationController pushViewController:topicVC animated:YES];
        }
        else if([string isEqualToString:@"发起活动"])
        {
            CreateActivityVC* activityVC = [[CreateActivityVC alloc] init];
            [controller.navigationController pushViewController:activityVC animated:YES];

        }
        
    }];
       // 去掉tableview 顶部空白区域
//    self.automaticallyAdjustsScrollViewInsets = false;
    
    
}

- (IBAction)addBar:(id)sender {
    NSLog(@"addBar");
    [self.parentViewController.view addSubview:_backGroundView];
    [self.parentViewController.view addSubview:_listTableView];
}


- (IBAction)noticeBar:(id)sender {
    NSLog(@"notice");

}

- (void)setupSubviews
{
    
    UIColor *fontColor= [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    
    _neighborVC = [[NeighborTVC alloc] init];
    _neighborVC.tabBarItem.title = @"邻居圈";
    _neighborVC.tabBarItem.image = [UIImage imageNamed:@"btn_linjuquan_b"];
    _neighborVC.tabBarItem.selectedImage = [UIImage imageNamed:@"btn_linjuquan_a"];
    UIImage *neighborImage = [UIImage imageNamed:@"btn_linjuquan_a"];
    neighborImage = [neighborImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _neighborVC.tabBarItem.selectedImage = neighborImage;
    [_neighborVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : fontColor
                                                      } forState:UIControlStateSelected];

    
    _discoveryVC = [[DiscoveryTVC alloc] init];
    _discoveryVC.tabBarItem.title = @"发现";
    _discoveryVC.tabBarItem.image = [UIImage imageNamed:@"btn_faxian_b"];
    UIImage *discoveryImage = [UIImage imageNamed:@"btn_faxian_a.png"];
    discoveryImage = [discoveryImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _discoveryVC.tabBarItem.selectedImage = discoveryImage;
    [_discoveryVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : fontColor
                                                      } forState:UIControlStateSelected];
    [_discoveryVC setRefreshIsMessage];
    
    _iVC = [[ITVC alloc] init];
    _iVC.tabBarItem.title = @"我";
    _iVC.tabBarItem.image = [UIImage imageNamed:@"btn_wo_b"];
    UIImage *iImage = [UIImage imageNamed:@"btn_wo_a.png"];
    iImage = [iImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _iVC.tabBarItem.selectedImage = iImage;
    [_iVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : fontColor
                                                      } forState:UIControlStateSelected];
    
    self.viewControllers = @[_neighborVC, _discoveryVC,_iVC];
    
}

// 极光推送设置网络请求
- (void) JGPushSetNet
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    
//    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%ldimei%@",phoneNum,userId,identifierNumber]];
//    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
   
    
    NSDictionary* parameter = @{@"access" : @"9527",
                                @"push_alias" : @"10000",
                                @"apitype" : @"jpush",
                                @"push_type" : @"msg",
                                @"tag" : @"test",
                                };
//    NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
//                                @"user_id" : [NSString stringWithFormat:@"%ld",userId],
//                                @"imei" : identifierNumber,
//                                @"apitype" : @"users",
//                                @"tag" : @"upload",
//                                @"salt" : @"1",
//                                @"hash" : hashString,
//                                @"keyset" : @"user_phone_number:user_id:imei:",
//                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"极光推送网络请求:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"极光推送网络请求失败:%@", error.description);
        return;
    }];

}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
    [self logSet:tags], alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (NSString *)logSet:(NSSet *)dic {
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

@end
