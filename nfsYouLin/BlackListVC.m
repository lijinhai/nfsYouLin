//
//  BlackListVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/8.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "BlackListVC.h"
#import "StringMD5.h"
#import "Friends.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"
#import "WaitView.h"

@interface BlackListVC ()

@end

@implementation BlackListVC
{
    NSMutableArray* _blackArr;
    UIView* backgroundView;
    UIView* backgroundView1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.bounces = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 1)];
    _blackArr = [NSMutableArray array];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
   
    WaitView* waitView = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"正在加载..."];
    backgroundView = [[UIView alloc] initWithFrame:self.parentViewController.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:waitView];
    [self.parentViewController.view addSubview:backgroundView];
    [self getBlackListNet];
    
    WaitView* waitView1 = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"正在移除..."];
    backgroundView1 = [[UIView alloc] initWithFrame:self.parentViewController.view.frame];
    backgroundView1.backgroundColor = [UIColor clearColor];
    [backgroundView1 addSubview:waitView1];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationItem.title = @"黑名单";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_blackArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"blackCell";
    FriendViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[FriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blackCell"];
        
    }
   
    NSLog(@"count = %ld",[_blackArr count]);
    cell.friendsData = _blackArr[indexPath.row];
    cell.row = indexPath.row;
    cell.section = indexPath.section;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController* sheetAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* singleAction = [UIAlertAction actionWithTitle:@"解除当前" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.parentViewController.view addSubview:backgroundView1];
        [self removeSingleBlackNet:indexPath.row];
    }];
    
    UIAlertAction* allAction = [UIAlertAction actionWithTitle:@"解除全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.parentViewController.view addSubview:backgroundView1];
        [self removeAllBlackNet];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor redColor] forKey:@"titleTextColor"];

    
    [sheetAlert addAction:singleAction];
    [sheetAlert addAction:allAction];
    [sheetAlert addAction:cancelAction];
    [self presentViewController:sheetAlert animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark -获取黑名单网络请求
- (void) getBlackListNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults valueForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString*  MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@",userId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter =@{
                               @"user_id" : userId,
                               @"apitype" : @"users",
                               @"salt" : @"1",
                               @"tag" : @"getblacklist",
                               @"hash" : hashString,
                               @"keyset" : @"user_id:",
                               };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取黑名单列表网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            NSArray* blackArray = [responseObject valueForKey:@"black_users_id"];
            for(NSInteger i = 0; i < [blackArray count]; i++)
            {
                NSDictionary* dict = blackArray[i];
                Friends* friend = [[Friends alloc] init];
                friend.nick = [dict valueForKey:@"userName"];
                friend.profession = [dict valueForKey:@"userPro"];
                friend.iconAddr = [dict valueForKey:@"userAvatar"];
                friend.houseAddr = [dict valueForKey:@"userAddr"];
                friend.userId = [[dict valueForKey:@"userId"] integerValue];
                [_blackArr addObject:friend];
            }
        }
        else if([flag isEqualToString:@"nono"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"没有黑名单成员"];
        }
        [backgroundView removeFromSuperview];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
}


#pragma mark -移除当前黑名单网络请求
- (void) removeSingleBlackNet:(NSInteger) row
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults valueForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    Friends* friend = [_blackArr objectAtIndex:row];
    NSString* blackList = [NSString stringWithFormat:@"%ld",friend.userId];
    
    NSString*  MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@black_user_id%@",userId, blackList]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter =@{
                               @"user_id" : userId,
                               @"black_user_id" : blackList,
                               @"action_id" : @"2",
                               @"apitype" : @"users",
                               @"salt" : @"1",
                               @"tag" : @"blacklist",
                               @"hash" : hashString,
                               @"keyset" : @"user_id:black_user_id:",
                               };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"移除当前网络请求:%@", responseObject);
        [backgroundView1 removeFromSuperview];
        [_blackArr removeObjectAtIndex:row];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}

#pragma mark -移除全部黑名单网络请求
- (void) removeAllBlackNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults valueForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSMutableString* blackList = [[NSMutableString alloc] init];
    for(NSInteger i = 0; i < [_blackArr count];i++)
    {
        Friends* friend = [_blackArr objectAtIndex:i];
        [blackList appendFormat:@"%ld:",friend.userId];
    }
    
    
    NSString*  MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@black_list%@",userId, blackList]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter =@{
                               @"user_id" : userId,
                               @"black_list" : blackList,
                               @"apitype" : @"users",
                               @"salt" : @"1",
                               @"tag" : @"clearblacklist",
                               @"hash" : hashString,
                               @"keyset" : @"user_id:black_list:",
                               };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"移除所有网络请求:%@", responseObject);
        [backgroundView1 removeFromSuperview];
        [_blackArr removeAllObjects];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
}

@end
