//
//  NewsSettingVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/12.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NewsSettingVC.h"
#import "HeaderFile.h"
#import "UIImageView+WebCache.h"
#import "HistoryNewsVC.h"
#import "StringMD5.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUBTool.h"

@interface NewsSettingVC ()

@end

@implementation NewsSettingVC
{
    UITableView* _tableView;
    
    UIAlertController* alert;
    UIAlertAction* receiveAction;
    UIAlertAction* noReceiveAction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackgroundColor;
    CGFloat bgY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, bgY, CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame) - bgY) * 0.4)];
    bgView.backgroundColor = MainColor;
    [self.view addSubview:bgView];
    
    UIImageView* subIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 - 40, CGRectGetHeight(bgView.frame) * 0.5 - 40, 80, 80)];
    subIV.image = [UIImage imageNamed:@"pic_youlin.png"];
    [bgView addSubview:subIV];
    
    UILabel* subL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subIV.frame) + 20, CGRectGetWidth(self.view.frame), 50)];
    subL.text = @"优邻之家";
    subL.textColor = [UIColor whiteColor];
    subL.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:subL];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), CGRectGetWidth(self.view.frame), 100)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    receiveAction = [UIAlertAction actionWithTitle:@"接收消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        action.enabled = NO;
        [self setNewRecivedNet:1];
        
    }];
    
    noReceiveAction = [UIAlertAction actionWithTitle:@"不接收消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        action.enabled = NO;
        [self setNewRecivedNet:2];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:receiveAction];
    [alert addAction:noReceiveAction];
    [alert addAction:cancelAction];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger status = [[defaults stringForKey:@"news_status"] integerValue];
    if(status == 2)
    {
        noReceiveAction.enabled = NO;
    }
    else
    {
        receiveAction.enabled = NO;
    }
    
    [self.view addSubview:_tableView];
}

#pragma mark -UITableViewDelegate UITabelDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = @"cellId";
    NSInteger row = indexPath.row;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (row) {
        case 0:
            cell.textLabel.text = @"历史消息";
            break;
        case 1:
            cell.textLabel.text = @"消息设置";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
    case 0:
    {
        HistoryNewsVC* historyVC = [[HistoryNewsVC alloc] init];
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:item];
        [self.navigationController pushViewController:historyVC animated:YES];
        break;
    }
    case 1:
    {
        [self presentViewController:alert animated:YES completion:nil];
        break;
    }
    default:
        break;
    }

}

#pragma mark -设置新闻接收状态网络请求
- (void) setNewRecivedNet:(NSInteger)status
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%@",phoneNum,userId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1",hashString]];
    NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                @"user_id" : userId,
                                @"receive_status" : [NSNumber numberWithInteger:status],
                                @"apitype" : @"users",
                                @"tag" : @"upload",
                                @"salt" : @"1",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_phone_number:user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"设置是否接收新闻消息网络请求%@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"消息设置成功"];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if(status == 1)
            {
                noReceiveAction.enabled = YES;
                [defaults setObject:@"1" forKey:@"news_status"];
            }
            else
            {
                receiveAction.enabled = YES;
                [defaults setObject:@"2" forKey:@"news_status"];
            }
            [defaults synchronize];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
