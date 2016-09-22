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
#import "StringMD5.h"
#import "NewsSettingVC.h"
#import "NewsCell.h"
#import "NewsDetailVC.h"
#import "SqlDictionary.h"
#import "SqliteOperation.h"

@interface NewsVC ()

@end


@implementation NewsVC
{
    UIScrollView* _scrollView;
    NSMutableArray* _newInfo;
    NSInteger upTime;
    NSInteger downTime;
    CGFloat Y;
    CGFloat originalY;
    
    UIView* backgroundV;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton* rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"newsuser.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = BackgroundColor;
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downDate)];
    _scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upDate)];
    [self.view addSubview:_scrollView];
    _newInfo = [[NSMutableArray alloc] init];
    upTime = 0;
    downTime = 0;
    originalY = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10;
    Y = originalY;
    
    backgroundV = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundV.backgroundColor = BackgroundColor;
    UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 - 25, 70, 50, 50)];
    indicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    [indicatorView startAnimating];
    indicatorView.hidden = NO;
    [backgroundV addSubview:indicatorView];
    
    UIImageView* newIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 - 30, CGRectGetMaxY(indicatorView.frame) + 30, 60, 60)];
    newIV.image = [UIImage imageNamed:@"tubiao.png"];
    [backgroundV addSubview:newIV];
    
    [self.view addSubview:backgroundV];
    
    [self newsListNet];
}

#pragma mark- 上拉刷新upDate
// 服务器参数为down 与服务器参数相反
- (void)upDate
{
    [_scrollView.mj_footer beginRefreshing];
    [self downNewsListNet];


}

#pragma mark- 下拉刷新downDate
// 服务器参数为up 与服务器参数相反
-(void) downDate
{
    [_scrollView.mj_header beginRefreshing];
    [self upNewsListNet];
}

#pragma mark -右标题栏
- (void)rightAction
{
    NewsSettingVC* newsSettingVC = [[NewsSettingVC alloc] init];
    [self.navigationController pushViewController:newsSettingVC animated:YES];
}

#pragma mark -UITableDelegate UITableDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* newsDict = [_newInfo objectAtIndex:tableView.tag];
    NSArray* newsArr = [newsDict valueForKey:@"otherNew"];
    return [newsArr count] + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if(row == 0)
    {
        return 150;
    }
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* titleId = @"titleId";
    static NSString* otherId = @"otherId";
    NSInteger row = indexPath.row;
    NewsCell* cell;
    
    NSDictionary* infoNew = [_newInfo objectAtIndex:tableView.tag];

    if(row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:titleId];
        if(cell == nil)
        {
            cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleId];
        }
        cell.titleNew = infoNew;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:otherId];
        if(cell == nil)
        {
            cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherId];
        }
        NSArray* infoArr = [infoNew valueForKey:@"otherNew"];
        NSDictionary* singleNew = [infoArr objectAtIndex:row - 1];
        cell.newsInfo = singleNew;

    }
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSDictionary* newsDict = [_newInfo objectAtIndex:tableView.tag];
    NSArray* newsArr = [newsDict valueForKey:@"otherNew"];
    NSString* itemStr = [newsDict valueForKey:@"subName"];
    NewsDetailVC *newsDetailVC = [[NewsDetailVC alloc] init];
    if(row == 0)
    {
        newsDetailVC.newsUrl = [newsDict valueForKey:@"new_url"];
        newsDetailVC.newsTitle = [newsDict valueForKey:@"new_title"];
        newsDetailVC.newsImage = [newsDict valueForKey:@"new_small_pic"];
        newsDetailVC.newsId = [[newsDict valueForKey:@"new_id"] integerValue];
    }
    else
    {
        NSDictionary* subDict = [newsArr objectAtIndex:row - 1];
        newsDetailVC.newsUrl = [subDict valueForKey:@"new_url"];
        newsDetailVC.newsTitle = [subDict valueForKey:@"new_title"];
        newsDetailVC.newsImage = [subDict valueForKey:@"new_small_pic"];
        newsDetailVC.newsId = [[subDict valueForKey:@"new_id"] integerValue];
    }
    
    UIBarButtonItem* newsItem = [[UIBarButtonItem alloc] initWithTitle:itemStr style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newsItem];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
    
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
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for(NSInteger i = 0; i < [responseObject count] ; i++)
            {
                NSDictionary* newsDict = [responseObject objectAtIndex:i];
                [_newInfo addObject:newsDict];
                if(i == [responseObject count] - 1)
                {
                    upTime = [[[responseObject objectAtIndex:i] valueForKey:@"push_time"] integerValue];
                }
                else if (i == 0)
                {
                    downTime = [[[responseObject objectAtIndex:i] valueForKey:@"push_time"] integerValue];
                }
                
                SqlDictionary* sqlDict = [[SqlDictionary alloc] init];
                NSMutableDictionary* newsInfoDic = [sqlDict getInitNewsDictionary];
                /**
                 dict[@"news_first"] ,
                 dict[@"news_title"] ,
                 dict[@"news_pic"] ,
                 dict[@"news_url"],
                 dict[@"news_belongs"] ,
                 dict[@"news_id"],
                 dict[@"news_send_time"] ,
                 dict[@"news_push_time"] ,
                 dict[@"news_others"],
                 dict[@"table_version"];
                 */
                newsInfoDic[@"news_title"] = [newsDict valueForKey:@"new_title"];
                newsInfoDic[@"news_pic"] = [newsDict valueForKey:@"new_small_pic"];
                newsInfoDic[@"news_url"] = [newsDict valueForKey:@"new_url"];
                newsInfoDic[@"news_push_time"] = [newsDict valueForKey:@"push_time"];
                newsInfoDic[@"news_id"] = [newsDict valueForKey:@"new_id"];
                NSError *err = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newsDict options:NSJSONWritingPrettyPrinted error:&err];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                newsInfoDic[@"news_others"] = jsonStr;

                if(![SqliteOperation insertNewsSqlite:newsInfoDic View:self.view])
                {
                    NSLog(@"插入失败！");
                    return ;
                }
            }
            [self loadNewsContent:0 end:[_newInfo count]];
        }
        [backgroundV removeFromSuperview];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}


#pragma mark- 下拉刷新新闻列表网络请求
// 实际动作为上拉
-(void) downNewsListNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"community_id" : communityId,
                                @"push_time" : [NSNumber numberWithInteger:upTime],
                                @"apitype" : @"comsrv",
                                @"salt" : @"1",
                                @"flag" : @"down",
                                @"tag" : @"getnews",
                                @"hash" : hashString,
                                @"keyset" : @"community_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下拉刷新获取新闻列表网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            NSInteger start = [_newInfo count];
            for(NSInteger i = 0; i < [responseObject count] ; i ++)
            {
                NSDictionary* newsDict = [responseObject objectAtIndex:i];
                [_newInfo addObject:newsDict];
                if(i == [responseObject count] - 1)
                {
                    upTime = [[[responseObject objectAtIndex:i] valueForKey:@"push_time"] integerValue];
                }
                
                SqlDictionary* sqlDict = [[SqlDictionary alloc] init];
                NSMutableDictionary* newsInfoDic = [sqlDict getInitNewsDictionary];
                
                newsInfoDic[@"news_title"] = [newsDict valueForKey:@"new_title"];
                newsInfoDic[@"news_pic"] = [newsDict valueForKey:@"new_small_pic"];
                newsInfoDic[@"news_url"] = [newsDict valueForKey:@"new_url"];
                newsInfoDic[@"news_push_time"] = [newsDict valueForKey:@"push_time"];
                newsInfoDic[@"news_id"] = [newsDict valueForKey:@"new_id"];
//                newsInfoDic[@"news_others"] = [newsDict valueForKey:@"otherNew"];
                NSError *err = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newsDict options:NSJSONWritingPrettyPrinted error:&err];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                newsInfoDic[@"news_others"] = jsonStr;
                
                if(![SqliteOperation insertNewsSqlite:newsInfoDic View:self.view])
                {
                    NSLog(@"插入失败！");
                    return ;
                }
                

            }
            NSInteger end = [_newInfo count];
            [self loadNewsContent:start end:end];
        }
        [_scrollView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


#pragma mark- 上拉刷新新闻列表网络请求 
// 实际动作为下拉
-(void) upNewsListNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"community_id" : communityId,
                                @"push_time" : [NSNumber numberWithInteger:downTime],
                                @"apitype" : @"comsrv",
                                @"salt" : @"1",
                                @"flag" : @"up",
                                @"tag" : @"getnews",
                                @"hash" : hashString,
                                @"keyset" : @"community_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下拉刷新获取新闻列表网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            
            for(NSInteger i = 0; i < [responseObject count] ; i ++)
            {
                NSDictionary* newsDict = [responseObject objectAtIndex:i];
                
                [_newInfo insertObject:newsDict atIndex:0];
                if(i ==  [responseObject count] - 1)
                {
                    downTime = [[[responseObject objectAtIndex:i] valueForKey:@"push_time"] integerValue];
                }
                
                SqlDictionary* sqlDict = [[SqlDictionary alloc] init];
                NSMutableDictionary* newsInfoDic = [sqlDict getInitNewsDictionary];
                
                newsInfoDic[@"news_title"] = [newsDict valueForKey:@"new_title"];
                newsInfoDic[@"news_pic"] = [newsDict valueForKey:@"new_small_pic"];
                newsInfoDic[@"news_url"] = [newsDict valueForKey:@"new_url"];
                newsInfoDic[@"news_push_time"] = [newsDict valueForKey:@"push_time"];
                newsInfoDic[@"news_id"] = [newsDict valueForKey:@"new_id"];
//                newsInfoDic[@"news_others"] = [newsDict valueForKey:@"otherNew"];
                NSError *err = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newsDict options:NSJSONWritingPrettyPrinted error:&err];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                newsInfoDic[@"news_others"] = jsonStr;
                if(![SqliteOperation insertNewsSqlite:newsInfoDic View:self.view])
                {
                    NSLog(@"插入失败！");
                    return ;
                }

            }
            
            NSInteger end = [responseObject count];
            Y = originalY;
            [self loadNewsContent:0 end:end];
            [self reloadNewsContent:end];
        }
        [_scrollView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


#pragma mark -加载新闻内容控件
- (void) loadNewsContent:(NSInteger)start end:(NSInteger)end
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    for(NSInteger i = start;i < end;i ++)
    {
        NSDictionary* infoDict = [_newInfo objectAtIndex:i];
        NSInteger time = [[infoDict valueForKey:@"push_time"] integerValue]  / 1000;
        NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSString* timeStr = [formatter stringFromDate:timeDate];
        
        UILabel* timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, Y, CGRectGetWidth(self.view.frame), 40)];
        timeL.text = timeStr;
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.enabled = NO;
        [_scrollView addSubview:timeL];

        Y = CGRectGetMaxY(timeL.frame) + 10;
        
        NSArray* otherNews = [infoDict valueForKey:@"otherNew"];
        
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, Y, CGRectGetWidth(self.view.frame) - 70, 60 * [otherNews count] + 153)];
        tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tableView.layer.borderWidth = 1.5f;
        tableView.layer.cornerRadius = 6;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
        tableView.bounces = NO;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_scrollView addSubview:tableView];
        Y = CGRectGetMaxY(tableView.frame) + 10;
    }
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), Y);
}

#pragma mark -重新加载新闻内容控件
- (void) reloadNewsContent:(NSInteger)num
{
    NSArray* subViews = [_scrollView subviews];
    for(NSInteger i = 0;i < [subViews count] - 2 * num; i++)
    {
        if([subViews[i] isKindOfClass:[UILabel class]])
        {
            UILabel* timeL = (UILabel*)[subViews objectAtIndex:i];
            timeL.frame = CGRectMake(0, Y, CGRectGetWidth(self.view.frame), 40);
            Y = CGRectGetMaxY(timeL.frame) + 10;
        }
        
        if([subViews[i] isKindOfClass:[UITableView class]])
        {
            UITableView* tableView = (UITableView*)[subViews objectAtIndex:i];
            
            CGFloat height = CGRectGetHeight(tableView.frame);
            CGFloat width = CGRectGetWidth(tableView.frame);
            CGFloat x = CGRectGetMinX(tableView.frame);
            tableView.frame =  CGRectMake(x, Y, width, height);
            tableView.tag += num;
            Y = CGRectGetMaxY(tableView.frame) + 10;
        }
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), Y);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
