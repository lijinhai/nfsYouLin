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
    NoticeMessageView* noticeView;
    UIPageControl* noticePControl;
    UIView* noticeBgV;
    
    NSMutableArray *dataArray;

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
    
    [self initNoticeView];
    
    // 环信登录
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
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
       // 去掉tableview 顶部空白区域
//    self.automaticallyAdjustsScrollViewInsets = false;
    
    
}

#pragma mark -初始化消息视图
- (void) initNoticeView
{
    //状态栏高度
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusH = statusRect.size.height;
    
    dataArray = [[NSMutableArray alloc] initWithObjects:@"哈哈哈-1",@"哈哈哈-2",@"哈哈哈-3",@"哈哈哈-4",@"哈哈哈-5",
                                                        @"哈哈哈-6",@"哈哈哈-7",@"哈哈哈-8",@"哈哈哈-9",@"哈哈哈-10",
                                                        @"哈哈哈-11",@"哈哈哈-12",@"哈哈哈-13",@"哈哈哈-14",@"哈哈哈-15",
                                                        @"哈哈哈-16",@"哈哈哈-17",@"哈哈哈-18",@"哈哈哈-19",@"哈哈哈-20",nil];
    
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
}

#pragma mark -加号点击视图
- (IBAction)addBar:(id)sender {
    NSLog(@"addBar");
    [self.parentViewController.view addSubview:_backGroundView];
    [self.parentViewController.view addSubview:_listTableView];
}

#pragma mark -加载消息视图
- (IBAction)noticeBar:(id)sender {
    [noticeView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.frame) , 0,
                                               CGRectGetWidth(self.view.frame),
                                               CGRectGetHeight(self.view.frame)) animated:NO];
    noticeBgV.frame  = CGRectMake(CGRectGetWidth(self.view.frame), 20,0,CGRectGetHeight(self.view.frame));
    [self.parentViewController.view addSubview:noticeBgV];
    [self.parentViewController.view addSubview:noticeView];
    noticeView.alpha = 0.0;
    [UIView transitionWithView:noticeView duration:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        noticeView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
    
    noticeTView.frame = CGRectMake(CGRectGetMaxX(self.view.frame) * 2 - 100, 20, 0, CGRectGetHeight(self.view.frame) - 10);
    [UIView transitionWithView:noticeTView duration:0.3	 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        noticeView.alpha = 0.5;
        noticeTView.frame = CGRectMake(CGRectGetMaxX(self.view.frame), 20, CGRectGetWidth(self.view.frame) - 100, CGRectGetHeight(self.view.frame) - 10);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"identifier"];
    }
    
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataArray removeObjectAtIndex:indexPath.row];
        [noticeTView deleteRowsAtIndexPaths:
                [NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
    
    }
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

@end
