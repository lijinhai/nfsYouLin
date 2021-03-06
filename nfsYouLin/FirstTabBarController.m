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
#import "ExchangeVC.h"
#import "InviteVC.h"
#import "SqliteOperation.h"
#import "PopChangeAddress.h"
#import "LewPopupViewController.h"
#import "NoticeMessageView.h"
#import "PushNoticeCell.h"
#import "JSONKit.h"
#import "StringMD5.h"
#import "NeighborDetailTVC.h"
#import "ErrorVC.h"
#import "SystemVC.h"

@implementation FirstTabBarController
{
    ListTableView* _listTableView;
    BackgroundView* _backGroundView;
    DiscoveryTVC* _discoveryVC;
    NeighborTVC* _neighborVC;
    ITVC* _iVC;
    NSInteger flagV;
    NSString* nowAddressStr;
    
    UITableView* noticeTView;
    UIView* noMessageView;
    NoticeMessageView* noticeView;
    UIPageControl* noticePControl;
    UIView* noticeBgV;
    
    NSMutableArray *dataArray;
    
    UIButton* noticeBtn;
    UIView* badge;
    
    UIView* loadingView;
    UIViewController* rootVC;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     
//    nowAddressStr=[SqliteOperation getUserNowAddressSqlite];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    nowAddressStr = [defaults stringForKey:@"familyAddress"];
    
    if([nowAddressStr isEqualToString:@""])
    {
      
      [_nowAddressBtn setTitle:@"未设置" forState:UIControlStateNormal];
      UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 17)];
      statusView.backgroundColor = [UIColor purpleColor];
      statusView.alpha=0.5;
        UILabel *tiplab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 17)];
        tiplab.text=@"您还没有设置地址";
        tiplab.textColor=[UIColor whiteColor];
        tiplab.textAlignment=NSTextAlignmentCenter;
        tiplab.font=[UIFont systemFontOfSize:11.0];
        [statusView addSubview:tiplab];
        statusView.tag=1988;
      [self.navigationController.navigationBar addSubview:statusView];
        
    }else{
      
        if((UIView *)[self.view viewWithTag:1988])
        {
            
            [(UIView *)[self.view viewWithTag:1988] removeFromSuperview];
        }
      [_nowAddressBtn setTitle:nowAddressStr forState:UIControlStateNormal];
    }
    [_nowAddressBtn addTarget:self
                action:@selector(popupAddressSettingTable:)
      forControlEvents:UIControlEventTouchUpInside
     ];
    //NSLog(@"nowAddressBtn text is %@",_nowAddressBtn.titleLabel.text);
    
    [self refreshData];
}

-(void)popupAddressSettingTable:(id)sender{

    PopChangeAddress *view = [PopChangeAddress defaultPopupView:nowAddressStr tFrame:CGRectMake(0, 0, screenWidth-40, 280)];
    view.parentVC = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
        
//        nowAddressStr=[SqliteOperation getUserNowAddressSqlite];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        nowAddressStr = [defaults stringForKey:@"familyAddress"];
        if([nowAddressStr isEqualToString:@""])
        {
            
            [_nowAddressBtn setTitle:@"未设置" forState:UIControlStateNormal];
        }else{
            if((UIView *)[self.view viewWithTag:1988])
            {
                
                [(UIView *)[self.view viewWithTag:1988] removeFromSuperview];
            }
            [_nowAddressBtn setTitle:nowAddressStr forState:UIControlStateNormal];
        }
         NSLog(@"动画结束");
    }];
}
- (void) viewDidLoad
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = self;
    rootVC = window.rootViewController.navigationController;
    
    noticeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [noticeBtn setImage:[UIImage imageNamed:@"title_icon_new_msg.png"] forState:UIControlStateNormal];
    [noticeBtn addTarget:self action:@selector(noticeBar:) forControlEvents:UIControlEventTouchUpInside];
    
    badge = [[UIView alloc] initWithFrame:CGRectMake(16, -4, 6, 6)];
    badge.backgroundColor = [UIColor redColor];
    badge.layer.cornerRadius = 3;
    badge.layer.masksToBounds = YES;
    self.noticeItem.customView = noticeBtn;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSInteger type = [[defaults stringForKey:@"type"] integerValue];
    NSString* nick = [defaults stringForKey:@"nick"];
    
    [self initViewBar];
    [self initNoticeView];
    [self initListView];
    [self initLoadingView];
    [self huanXinLogin:userId name:nick];
    [self jpushInit:userId community:communityId type:type];
    [self initGlobalController];
    
}

#pragma mark -环信登录
- (void) huanXinLogin:(NSString*) userId name:(NSString*)nick
{
    // 环信登录
    [[EMClient sharedClient] asyncLoginWithUsername:userId password:userId success:^{
        NSLog(@"环信登陆成功");
        //设置环信推送设置
        [[EMClient sharedClient] setApnsNickname:nick];
        
        EMPushOptions *options = [[EMClient sharedClient] pushOptions];
        options.displayStyle = EMPushDisplayStyleMessageSummary;
        [[EMClient sharedClient] updatePushOptionsToServer];
        
    } failure:^(EMError *aError) {
        NSLog(@"环信登录失败 aError:%@",aError.errorDescription);
    }];

}

#pragma mark -设置极光推送
- (void) jpushInit:(NSString *)userId community:(NSString *)communityId type:(NSInteger)type
{
    // 设置极光推送设置
    NSString* jpushAlias = [NSString stringWithFormat:@"youlin_tag_%@",userId];
    NSMutableSet* jpushTag = [[NSMutableSet alloc] initWithObjects: [NSString stringWithFormat:@"community_topic_%@",communityId],
                              [NSString stringWithFormat:@"push_news_%@",communityId],nil];
    
    if(type == 4)
    {
        [jpushTag addObject:@"property_notice_1"];
    }
    
    [JPUSHService setTags:jpushTag alias:jpushAlias
    fetchCompletionHandle:
     ^(int iResCode, NSSet *iTags, NSString *iAlias) {
         NSLog(@"-----++++-------JPUSHService setTag code = %d",iResCode);
     }];

}

#pragma mark -初始化全局控制器
- (void) initGlobalController
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(!app.friendVC)
    {
        app.friendVC = [[FriendsVC alloc] init];
    }
    
    [ChatDemoHelper shareHelper].discoveryVC = _discoveryVC;
    [ChatDemoHelper shareHelper].neighborVC = _neighborVC;
    [ChatDemoHelper shareHelper];
    [[ChatDemoHelper shareHelper] asyncPushOptions];
    [ChatDemoHelper shareHelper].friendVC = app.friendVC;
    [ChatDemoHelper shareHelper].mainVC = self;
}

#pragma mark -初始化下拉视图
-(void) initListView
{
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
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"create",@"option",
                                         nil];
            [topicVC setTopicInfo:dict];
            [controller.navigationController pushViewController:topicVC animated:YES];
        }
        else if([string isEqualToString:@"发起活动"])
        {
            CreateActivityVC* activityVC = [[CreateActivityVC alloc] init];
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"create",@"option",
                                         nil];
            [activityVC setTopicInfo:dict];
            [controller.navigationController pushViewController:activityVC animated:YES];
            
        }
        else if([string isEqualToString:@"闲品会"])
        {
            ExchangeVC* exchangeVC = [[ExchangeVC alloc] init];
            [controller.navigationController pushViewController:exchangeVC animated:YES];
            
        }
        else if([string isEqualToString:@"邀请"])
        {
            InviteVC* inviteVC = [[InviteVC alloc] init];
            
            UIBarButtonItem* backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"邀请好友" style:UIBarButtonItemStylePlain target:nil action:nil];
            [controller.navigationItem setBackBarButtonItem:backItemTitle];
            [controller.navigationController pushViewController:inviteVC animated:YES];
            
        }
        
    }];

}


#pragma mark -初始化消息视图
- (void) initNoticeView
{
    //状态栏高度
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusH = statusRect.size.height;
    
    /* dataArray = [[NSMutableArray alloc] initWithObjects:@"哈哈哈-1",@"哈哈哈-2",@"哈哈哈-3",@"哈哈哈-4",@"哈哈哈-5",
                                                        @"哈哈哈-6",@"哈哈哈-7",@"哈哈哈-8",@"哈哈哈-9",@"哈哈哈-10",
                                                        @"哈哈哈-11",@"哈哈哈-12",@"哈哈哈-13",@"哈哈哈-14",@"哈哈哈-15",
                                                        @"哈哈哈-16",@"哈哈哈-17",@"哈哈哈-18",@"哈哈哈-19",@"哈哈哈-20",nil];
    */
    dataArray = [NSMutableArray array];
    [self selectDataSql];
    noticeView = [[NoticeMessageView alloc ] initWithFrame:self.view.bounds];
    noticeView.backgroundColor = [UIColor blackColor];
    noticeView.alpha = 0;
    noticeView.directionalLockEnabled = YES;
    noticeView.bounces = NO;
    noticeView.pagingEnabled = YES;
    noticeView.showsVerticalScrollIndicator = NO;
    noticeView.showsHorizontalScrollIndicator = NO;
    noticeView.delegate = self;
    noticeView.contentSize = CGSizeMake(self.view.frame.size.width * 2 - 100,  self.view.frame.size.height);
    
    noticeBgV = [[UIView alloc] init];
    noticeBgV.backgroundColor = [UIColor whiteColor];
    noticeBgV.alpha = 1;
    
    noticeView.bgView = noticeBgV;
    
    noticeTView = [[UITableView alloc] initWithFrame:
                   CGRectMake(CGRectGetMaxX(self.view.frame) * 2 - 100, 20, 0,
                              CGRectGetHeight(self.view.frame) - 10) style:UITableViewStyleGrouped];
    noticeTView.backgroundColor = [UIColor whiteColor];
    noticeTView.alpha = 1.0;
    noticeTView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 100, 0.5)];
    noticeTView.bounces = NO;
    noticeTView.delegate = self;
    noticeTView.dataSource = self;
    if ([noticeTView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [noticeTView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([noticeTView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [noticeTView setLayoutMargins:UIEdgeInsetsZero];
    }

    
    [noticeView addSubview:noticeTView];
    
    noticePControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 401, self.view.frame.size.width, 80)];
    noticePControl.hidesForSinglePage = YES;
    noticePControl.userInteractionEnabled = NO;
    noticePControl.backgroundColor = [UIColor blackColor];
    [self.view addSubview:noticePControl];
    
    noMessageView = [[UIView alloc] init];
    noMessageView.backgroundColor = [UIColor whiteColor];
    
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.2 + 20, 40, 80, 80)];
    iv.layer.masksToBounds = YES;
    iv.layer.cornerRadius = 40;
    iv.image = [UIImage imageNamed:@"wutongzhi.png"];
    [noMessageView addSubview:iv];
    
    UILabel* l1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame) + 20, screenWidth - 110, 20)];
    l1.text = @"暂无任何通知";
    l1.textAlignment = NSTextAlignmentCenter;
    l1.font = [UIFont systemFontOfSize:18];
    l1.enabled = NO;
    [noMessageView addSubview:l1];
    
    UILabel* l2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(l1.frame) + 40, screenWidth - 120,80)];
    l2.text = @"在这里您可以看到地址的审核信息，物业的推送信息(公告、报修、建议)，新闻的推送信息.点击后可以跳转到对应的界面.";
    l2.numberOfLines = 0;
    l2.font = [UIFont systemFontOfSize:13];
    [noMessageView addSubview:l2];
}

#pragma mark -加号点击视图
- (IBAction)addBar:(id)sender {
    NSLog(@"addBar");
    [self.parentViewController.view addSubview:_backGroundView];
    [self.parentViewController.view addSubview:_listTableView];
}

#pragma mark -加载消息视图
- (IBAction)noticeBar:(id)sender {
    
    if([dataArray count] == 0)
    {
        [noticeTView addSubview:noMessageView];
    }
    else
    {
        [noMessageView removeFromSuperview];
    }
    
    [noticeView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.frame) , 0,
                                               CGRectGetWidth(self.view.frame),
                                               CGRectGetHeight(self.view.frame)) animated:NO];
    noticeBgV.frame  = CGRectMake(CGRectGetWidth(self.view.frame), 20,0,CGRectGetHeight(self.view.frame));
    [self.parentViewController.view addSubview:noticeBgV];
    [self.parentViewController.view addSubview:noticeView];
    noticeView.alpha = 0.0;
    [UIView transitionWithView:noticeView duration:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        noticeView.alpha = 0.8;
    } completion:^(BOOL finished) {
        
    }];
    
    noticeTView.frame = CGRectMake(CGRectGetMaxX(self.view.frame) * 2 - 100, 20, 0, CGRectGetHeight(self.view.frame) - 10);
    noMessageView.frame = noticeTView.bounds;
    [UIView transitionWithView:noticeTView duration:0.3	 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        noticeView.alpha = 0.8;
        noticeTView.frame = CGRectMake(CGRectGetMaxX(self.view.frame), 20, CGRectGetWidth(self.view.frame) - 100, CGRectGetHeight(self.view.frame) - 10);
        noMessageView.frame = noticeTView.bounds;
        noticeBgV.frame = CGRectMake(100, 20, CGRectGetWidth(self.view.frame) - 100,
                                     CGRectGetHeight(self.view.frame));
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView transitionWithView:noticeBgV duration:0.3 options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
            noticeBgV.frame = CGRectMake(100, 20, CGRectGetWidth(self.view.frame) - 100,
                                                     CGRectGetHeight(self.view.frame));
    } completion:nil];

}

#pragma -mark 结束加载和取消消息视图
- (void) finishNoticeBar
{
    [UIView transitionWithView:noticeView duration:0.2 options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        noticeView.alpha = 0.0;
                        noticeBgV.frame = CGRectMake(CGRectGetWidth(self.view.frame), 20,0,CGRectGetHeight(self.view.frame));
                    } completion:^(BOOL finished) {
                        [loadingView removeFromSuperview];
                        [noticeView removeFromSuperview];
                        [noticeBgV removeFromSuperview];
                    }];
}


#pragma mark 设置页面标签
- (void)initViewBar
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

#pragma mark -noticeTView UITableViewDelegate,UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString* contentStr = [[dataArray objectAtIndex:row] valueForKey:@"content"];
    NSDictionary* content =  (NSDictionary*)[contentStr objectFromJSONString];
    NSInteger pushType = [[content valueForKey:@"pushType"] integerValue];
    switch (pushType) {
        case 2:
        {
            [self intoNoticeDetailViewController:content row:row key:@"content"];
            break;
        }
        case 3:
        {
            NSString* title = [content valueForKey:@"pTitle"];
            if([title isEqualToString:@"物业公告"])
            {
                NSInteger topicId = [[content valueForKey:@"topicId"] integerValue];
                NeighborData* neighborData = [[ChatDemoHelper shareHelper].neighborVC readInformation:topicId];
                [rootVC.view addSubview:loadingView];
                [self updateDataSqlAndArr:row];
                [self intoReplyViewNet:neighborData];
            }
            else
            {
                
            }
            
            break;
        }
        case 5:
        {
            
            [self intoNoticeDetailViewController:content row:row key:@"message"];
            break;
        }
            
        case 6:
        {
            NSInteger topicId = [[content valueForKey:@"topicId"] integerValue];
            NeighborData* neighborData = [[ChatDemoHelper shareHelper].neighborVC readInformation:topicId];
            [rootVC.view addSubview:loadingView];
            [self updateDataSqlAndArr:row];
            [self intoReplyViewNet:neighborData];
            break;
        }
        default:
            break;
    }
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView :(UITableView *)tableView cellForRowAtIndexPath :( NSIndexPath*)indexPath
{
    PushNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil)
    {
        cell = [[PushNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"identifier"];
    }
    
    //cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    NSDictionary* dict = [dataArray objectAtIndex:indexPath.row];
    cell.noticeDict = dict;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary* dict = [dataArray objectAtIndex:indexPath.row];
        [self deleteDataSql:[[dict valueForKey:@"recordId"] integerValue]];
        NSLog(@"xx222[dataArray count] = %ld",[dataArray count]);
        [dataArray removeObjectAtIndex:indexPath.row];
        [noticeTView deleteRowsAtIndexPaths:
                [NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if([dataArray count] == 0)
        {
            [self finishNoticeBar];
            [self cancelRedPoint];
        }
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
    
    }
}

#pragma mark -进入消息
- (void) intoNoticeDetailViewController:(NSDictionary*) content row:(NSInteger)row key:(NSString*)key
{
    SystemVC* systemVC = [[SystemVC alloc] init];
    NSInteger internal = [[content valueForKey:@"pushTime"] integerValue];
    NSString* title = [content valueForKey:@"title"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日 hh:mm";
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:internal / 1000];
    NSString *dateStr = [formatter stringFromDate:date];
    systemVC.dateStr = dateStr;
    systemVC.message = [content valueForKey:key];
    [self updateDataSqlAndArr:row];
    [self finishNoticeBar];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:item];
    [self.navigationController pushViewController:systemVC animated:YES];
}

#pragma mark -noticeView UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }

    noticeTView.scrollEnabled = YES;
    int index = fabs(scrollView.contentOffset.x) / (scrollView.frame.size.width - 100);
    if(index == 0)
    {
        [noticeView removeFromSuperview];
        [noticeBgV removeFromSuperview];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    noticeTView.scrollEnabled = NO;
    CGRect rect = noticeBgV.frame;
    CGFloat X = CGRectGetWidth(self.view.frame) -  scrollView.contentOffset.x;
    CGFloat Y = rect.origin.y;
    CGFloat W = rect.size.width;
    CGFloat H = rect.size.height;
    
    noticeBgV.frame = CGRectMake(X, Y, W, H);
}

#pragma mark -数据修改
- (void) updateDataSqlAndArr:(NSInteger) num
{
    
    NSDictionary* content = [dataArray objectAtIndex:num];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:content];
    dict[@"type"] = @"0";
    [dataArray replaceObjectAtIndex:num withObject:dict];
    NSInteger recordId = [[dict valueForKey:@"recordId"] integerValue];
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = app.db;
    if([db open])
    {
        NSString* updateSql = [NSString stringWithFormat:@"update table_push_record SET type = '0' where record_id = %ld",recordId];
        BOOL isSuccess = [db executeUpdate:updateSql];
        if(isSuccess)
        {
            NSLog(@"db: type update success!");
        }
        else{
            NSLog(@"db: type update failed!");
        }
    }
    [db close];
}


#pragma mark -数据删除
- (void) deleteDataSql:(NSInteger) recordId
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = app.db;
    if([db open])
    {
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from table_push_record where record_id = '%ld'",
                               recordId];
        BOOL res = [db executeUpdate:deleteSql];
        if (!res) {
            NSLog(@"error when delete db table_push_record");
        } else {
            NSLog(@"success to delete db table_push_record");
        }
    }

}

#pragma mark -刷新消息列表
- (void)refreshData
{
    [self selectDataSql];
}

#pragma mark -数据获取
- (void) selectDataSql
{
    BOOL point = true;
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = app.db;
    [dataArray removeAllObjects];
    if([db open])
    {
        FMResultSet *set = [db executeQuery:@"select * from table_push_record"];
        while ([set next]) {
            NSString *content =  [set stringForColumn:@"content"];
            NSString *commnityId = [set stringForColumn:@"community_id"];
            NSString *type = [set stringForColumn:@"type"];
            NSString* recordId = [set stringForColumn:@"record_id"];
        
            if([type integerValue]== 1)
            {
                point = false;
            }
            
                        
            NSDictionary* dict = [NSDictionary
                                  dictionaryWithObjectsAndKeys:
                                  content, @"content",
                                  commnityId, @"commnityId",
                                  type, @"type",
                                  recordId, @"recordId",
                                  nil];
            [dataArray insertObject:dict atIndex:0];
        }
    }
    
    if(point)
    {
        [self cancelRedPoint];
    }
    else
    {
        [self addRedPoint];
    }
    [noticeTView reloadData];
}

#pragma mark -消息添加红点
- (void)addRedPoint
{
    [noticeBtn addSubview:badge];
}

#pragma mark -消息取消红点
- (void) cancelRedPoint
{
    [badge removeFromSuperview];
}

#pragma mark -创建加载页面
- (void) initLoadingView
{
    loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha = 0.2;
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 20, screenHeight / 2, 40, 40)];
    [loadingView addSubview:indicator];
    indicator.hidesWhenStopped = YES;
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.color = [UIColor yellowColor];
    [indicator startAnimating];
    
    UILabel* loadL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(indicator.frame), screenWidth, 20)];
    loadL.text = @"加载中...";
    loadL.textColor = [UIColor yellowColor];
    loadL.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:loadL];
    
}

#pragma mark -network进入回复页面
- (void)intoReplyViewNet:(NeighborData*) neighborData
{
    NSLog(@"进入回复页面");
    NSInteger topicId = [[neighborData valueForKey:@"topicId"] integerValue];
    NSInteger senderId = [[neighborData valueForKey:@"senderId"] integerValue];
    NSInteger num = [neighborData.viewCount integerValue] + 1;
    neighborData.viewCount = [NSString stringWithFormat:@"%ld",num];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    // 获取帖子状态网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%ldsender_id%ld",userId,communityId,topicId,senderId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"sender_id" : [NSNumber numberWithInteger:senderId],
                                @"apitype" : @"comm",
                                @"tag" : @"delstatus",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:sender_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取帖子状态网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            NeighborDetailTVC* neighborDetailVC = [[NeighborDetailTVC alloc] init];
            UIBarButtonItem* detailItem = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.parentViewController.navigationItem setBackBarButtonItem:detailItem];
            neighborDetailVC.neighborData = neighborData;
            [neighborDetailVC getReplyNet];
            [self finishNoticeBar];
            [self.navigationController pushViewController:neighborDetailVC animated:YES];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"帖子信息" message:@"此贴已不可见" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [loadingView removeFromSuperview];
            return;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        [self finishNoticeBar];
        NSData* data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        ErrorVC* errorVC = [[ErrorVC alloc] init];
        errorVC.error = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.navigationController pushViewController:errorVC animated:YES];
        return;
    }];    
}



@end
