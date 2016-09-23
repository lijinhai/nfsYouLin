//
//  WeatherVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "WeatherVC.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "WeatherView.h"
#import "MJRefresh.h"


@interface WeatherVC ()

@end

@implementation WeatherVC
{
    UIScrollView* _scrollView;
    NSMutableArray* _weatherDetailArr;
    CGFloat Y;
    UIActivityIndicatorView* indicatorView;
    NSInteger upId;
    NSInteger downId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    upId = 0;
    downId = 0;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = BackgroundColor;
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downDate)];
    _scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upDate)];
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 20, screenHeight / 2, 40, 40)];
    indicatorView.hidesWhenStopped = YES;
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicatorView.color = MainColor;
    [indicatorView startAnimating];
    
    [_scrollView addSubview:indicatorView];
    [self.view addSubview:_scrollView];
    Y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    _weatherDetailArr = [NSMutableArray array];
    
    [self weatherNet];
}

#pragma mark- 上拉刷新upDate
- (void)upDate
{
    [_scrollView.mj_footer beginRefreshing];
    [self upWeatherNet];
}

#pragma mark- 下拉刷新downDate
-(void) downDate
{
    [_scrollView.mj_header beginRefreshing];
    [self downWeatherNet];
}


#pragma mark -获取天气网络请求
- (void) weatherNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"community_id" : communityId,
                                @"action_id" : @"0",
                                @"weaorzod_id" : @"0",
                                @"apitype" : @"comsrv",
                                @"salt" : @"1",
                                @"tag" : @"getweaorzod",
                                @"hash" : hashString,
                                @"keyset" : @"community_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取天气网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            NSMutableArray* array = [responseObject valueForKey:@"weaorzod_detail"];
            _weatherDetailArr = [array mutableCopy];
        }
        upId = [[[_weatherDetailArr objectAtIndex:0] valueForKey:@"weaorzod_id"] integerValue];
        downId = [[[_weatherDetailArr objectAtIndex:[_weatherDetailArr count] - 1] valueForKey:@"weaorzod_id"] integerValue];
        [self loadWeatherContent:0 end:[_weatherDetailArr count]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

#pragma mark -上拉天气网络请求
- (void) upWeatherNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"community_id" : communityId,
                                @"action_id" : @"2",
                                @"weaorzod_id" : [NSNumber numberWithInteger:upId],
                                @"apitype" : @"comsrv",
                                @"salt" : @"1",
                                @"tag" : @"getweaorzod",
                                @"hash" : hashString,
                                @"keyset" : @"community_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上拉获取天气网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            NSArray* weatherArr = [responseObject valueForKey:@"weaorzod_detail"];
            NSInteger start = [_weatherDetailArr count];
            for(NSInteger i = 0;i < [weatherArr count]; i++)
            {
                [_weatherDetailArr addObject:[weatherArr objectAtIndex:i]];
            }
            
            NSInteger end = [_weatherDetailArr count];
            upId = [[[weatherArr objectAtIndex:[weatherArr count] - 1] valueForKey:@"weaorzod_id"] integerValue];
            [self loadWeatherContent:start end:end];

        }
        [_scrollView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
}

#pragma mark -下拉天气网络请求
- (void) downWeatherNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"community_id" : communityId,
                                @"action_id" : @"1",
                                @"weaorzod_id" : [NSNumber numberWithInteger:downId],
                                @"apitype" : @"comsrv",
                                @"salt" : @"1",
                                @"tag" : @"getweaorzod",
                                @"hash" : hashString,
                                @"keyset" : @"community_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下拉获取天气网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            NSArray* weatherArr = [responseObject valueForKey:@"weaorzod_detail"];
            for(NSInteger i = [weatherArr count] - 1; i >= 0; i--)
            {
                [_weatherDetailArr insertObject:[weatherArr objectAtIndex:i] atIndex:0];
            }
            NSInteger end = [weatherArr count];
            Y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
            downId = [[[weatherArr objectAtIndex:0] valueForKey:@"weaorzod_id"] integerValue];
            [self loadWeatherContent:0 end:end];
            [self reloadWeatherContent:end];
            
        }

        [_scrollView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -重新加载新闻内容控件
- (void) reloadWeatherContent:(NSInteger)num
{
    NSArray* subViews = [_scrollView subviews];
    for(NSInteger i = 0;i < [subViews count] - 2 * num; i++)
    {
        if([subViews[i] isKindOfClass:[UILabel class]])
        {
            UILabel* timeL = (UILabel*)[subViews objectAtIndex:i];
            timeL.frame = CGRectMake(0, Y, CGRectGetWidth(self.view.frame), 40);
            Y = CGRectGetMaxY(timeL.frame);
        }
        
        if([subViews[i] isKindOfClass:[WeatherView class]])
        {
            WeatherView* weatherView = (WeatherView*)[subViews objectAtIndex:i];
            
            CGFloat height = CGRectGetHeight(weatherView.frame);
            CGFloat width = CGRectGetWidth(weatherView.frame);
            CGFloat x = CGRectGetMinX(weatherView.frame);
            weatherView.frame =  CGRectMake(x, Y, width, height);
            weatherView.tag += num;
            Y = CGRectGetMaxY(weatherView.frame);
        }
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), Y);
}


#pragma mark -加载天气内容控件
- (void) loadWeatherContent:(NSInteger)start end:(NSInteger)end
{

    for(NSInteger i = end - 1;i >= start;i --)
    {
        NSDictionary* weatherDict = [_weatherDetailArr objectAtIndex:i];
        NSString* timeStr = [weatherDict valueForKey:@"wpr_time"];
        
        UILabel* timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, Y, CGRectGetWidth(self.view.frame), 40)];
        timeL.text = timeStr;
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.enabled = NO;
        [_scrollView addSubview:timeL];
        Y = CGRectGetMaxY(timeL.frame)	;
        
        WeatherView* weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(20, Y, screenWidth - 40, 330)];
        weatherView.tag = i;
        NSMutableDictionary* weatherInfo = [[NSMutableDictionary alloc] init];
        weatherInfo[@"temperature"] = [[[[weatherDict valueForKey:@"wpr_detail"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"temperature"];
        weatherInfo[@"city_name"] = [[[weatherDict valueForKey:@"wpr_detail"] valueForKey:@"realtime"] valueForKey:@"city_name"];
        weatherInfo[@"info"] = [[[[weatherDict valueForKey:@"wpr_detail"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"info"];
        weatherInfo[@"day_temperature"] = [[[[[[weatherDict valueForKey:@"wpr_detail"] valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:2];
        NSLog(@"day_temperature = %@",weatherInfo[@"day_temperature"]);
        weatherInfo[@"night_temperature"] = [[[[[[weatherDict valueForKey:@"wpr_detail"] valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"info"] valueForKey:@"night"] objectAtIndex:2];
        weatherInfo[@"tomorrow_day_temperature"] = [[[[[[weatherDict valueForKey:@"wpr_detail"] valueForKey:@"weather"] objectAtIndex:1] valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:2];
        weatherInfo[@"tomorrow_night_temperature"] = [[[[[[weatherDict valueForKey:@"wpr_detail"] valueForKey:@"weather"] objectAtIndex:1] valueForKey:@"info"] valueForKey:@"night"] objectAtIndex:2];
        weatherInfo[@"after_day_temperature"] = [[[[[[weatherDict valueForKey:@"wpr_detail"] valueForKey:@"weather"] objectAtIndex:2] valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:2];

        weatherInfo[@"after_night_temperature"] = [[[[[[weatherDict valueForKey:@"wpr_detail"] valueForKey:@"weather"] objectAtIndex:2] valueForKey:@"info"] valueForKey:@"night"] objectAtIndex:2];
        weatherInfo[@"luck"] = [[weatherDict valueForKey:@"zod_info"] valueForKey:@"zodiac_summary"];
        weatherInfo[@"constellation"] = [[weatherDict valueForKey:@"zod_info"] valueForKey:@"zodiac_imgurl"];

        weatherView.weatherInfo = weatherInfo;
        [_scrollView addSubview:weatherView];
        
        Y = CGRectGetMaxY(weatherView.frame);
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), Y);
    [indicatorView stopAnimating];
}


@end
