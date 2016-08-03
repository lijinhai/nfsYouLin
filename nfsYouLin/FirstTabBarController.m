//
//  FirstTabBarController.m
//  nfsYouLin
//
//  Created by Macx on 16/6/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FirstTabBarController.h"
#import "NewTopicViewController.h"
#import "BackgroundView.h"
#import "ListTableView.h"
#import "ChatDemoHelper.h"
#import "AppDelegate.h"
#import "NeighborTVC.h"
#import "DiscoveryTVC.h"
#import "ITVC.h"

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

//    EMOptions *options = [EMOptions optionsWithAppkey:@"nfs-hlj#youlinapp"];
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
    EMError *error = [[EMClient sharedClient] loginWithUsername:userId password:userId];
    
    if (!error)
    {
        NSLog(@"环信登陆成功");
    }

    [self setupSubviews];
    [ChatDemoHelper shareHelper].discoveryVC = _discoveryVC;
    
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    if(!app.friendVC)
    {
        app.friendVC = [[FriendsVC alloc] init];
        
    }

    [ChatDemoHelper shareHelper];
    [ChatDemoHelper shareHelper].friendVC = app.friendVC;
    [ChatDemoHelper shareHelper].mainVC = self;
    UINavigationController* navigationController = self.navigationController;
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
            NewTopicViewController* newTopicViewController = [[NewTopicViewController alloc] initWithTitle:string];
            [navigationController pushViewController:newTopicViewController animated:YES];
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

@end
