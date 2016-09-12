//
//  NewsVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/12.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NewsVC.h"
#import "MJRefresh.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"
#import "StringMD5.h"
#import "NewsSettingVC.h"


@interface NewsVC ()

@end

@implementation NewsVC
{
    UIScrollView* _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton* rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"newsuser.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = BackgroundColor;
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upDate)];
    _scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downDate)];
    [self.view addSubview:_scrollView];
    [self newsListNet];
}

#pragma mark- 上拉刷新upDate
- (void)upDate
{
    [_scrollView.mj_header beginRefreshing];
}

#pragma mark- 下拉刷新downDate
-(void) downDate
{
    [_scrollView.mj_footer beginRefreshing];
}

#pragma mark -右标题栏
- (void)rightAction
{
    NewsSettingVC* newsSettingVC = [[NewsSettingVC alloc] init];
    [self.navigationController pushViewController:newsSettingVC animated:YES];
}

#pragma mark- 获取新闻列表网络请求
- (void) newsListNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"community_id" : communityId,
                                @"apitype" : @"comsrv",
                                @"salt" : @"1",
                                @"tag" : @"getnews",
                                @"hash" : hashString,
                                @"keyset" : @"community_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取新闻列表网络请求:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
