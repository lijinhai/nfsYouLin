//
//  InviteRecordVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "InviteRecordVC.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "InviteRecordCell.h"
#import "WaitView.h"

@interface InviteRecordVC ()

@end

@implementation InviteRecordVC
{
    UITableView* _tableView;
    UILabel* _titleL;
    
    NSMutableArray* inviteInfoArr;
    UIView* backgroundView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), 35)];
    _titleL.text = @"您邀请了...";
    _titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleL];
    
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleL.frame), CGRectGetWidth(self.view.frame), 35)];
    titleView.backgroundColor = BackgroundColor;
    [self.view addSubview:titleView];
    
    UILabel* timeTL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) / 3, 35)];
    timeTL.text = @"邀请时间";
    timeTL.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:timeTL];
    
    UILabel* phoneTL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeTL.frame), 0, CGRectGetWidth(self.view.frame) / 3, 35)];
    phoneTL.text = @"好友";
    phoneTL.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:phoneTL];
    
    UILabel* stateTL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneTL.frame), 0, CGRectGetWidth(self.view.frame) / 3, 35)];
    stateTL.text = @"状态";
    stateTL.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:stateTL];
    
    inviteInfoArr = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(titleView.frame)) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 1)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    
    WaitView* waitView = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"加载中..."];
    backgroundView = [[UIView alloc] initWithFrame:self.parentViewController.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:waitView];
    [self.parentViewController.view addSubview:backgroundView];
    [self inviteDetailNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [inviteInfoArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = @"cellId";
    InviteRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[InviteRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.infoDict = [inviteInfoArr objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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
    
}

#pragma mark -Network
// 获取邀请详情网络请求
- (void) inviteDetailNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults valueForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@",userId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{
                                @"user_id" : userId,
                                @"apitype" : @"users",
                                @"salt" : @"1",
                                @"tag" : @"getinviteinfo",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"获取邀请详情请求:%@", responseObject);
        [inviteInfoArr removeAllObjects];
        
        NSInteger count = [[responseObject valueForKey:@"count"] integerValue];
        NSString* countStr = [NSString stringWithFormat:@"%ld",count];
        NSString* titleStr = [NSString stringWithFormat:@"%@位好友成功注册优邻",countStr];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleStr];
        [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,countStr.length)];
        _titleL.text = titleStr;
        _titleL.attributedText = str;
        
        NSArray* infoArr = [responseObject valueForKey:@"info"];
        for(int i = 0; i < [infoArr count]; i++)
        {
            [inviteInfoArr addObject:[infoArr objectAtIndex:i]];
        }
        [_tableView reloadData];
        [backgroundView removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    

}


@end
