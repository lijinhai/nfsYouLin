//
//  BlackListViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/1.
//  Copyright © 2016年 jinhai. All rights reserved.
//
#define SCREEN_WIDTH   ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)
#import "BlackListViewController.h"
#import "UIImageView+WebCache.h"
#import "blackerInfo.h"
#import "blackerTableViewCell.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUBTool.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "RectWaitView.h"

@interface BlackListViewController ()

@end

@implementation BlackListViewController{

    NSMutableArray* testAry;
    UIColor *_viewColor;
    UIView* backgroundView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _blackerAry=[[NSMutableArray alloc] init];
    
    for(int i=0;i<[_blackListAry count];i++)
    {
        blackerInfo* blacker=[[blackerInfo alloc] init];
        blacker.headUrl=[[_blackListAry objectAtIndex:i] objectForKey:@"userAvatar"];
        blacker.nickStr=[[_blackListAry objectAtIndex:i] objectForKey:@"userName"];
        blacker.addressStr=[[_blackListAry objectAtIndex:i] objectForKey:@"userAddr"];
        blacker.vocationStr=[[_blackListAry objectAtIndex:i] objectForKey:@"userPro"];
        [_blackerAry addObject:blacker];
    }
    RectWaitView* waitView = [[RectWaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"正在移出..."];
    backgroundView = [[UIView alloc] initWithFrame:self.parentViewController.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:waitView];
    
}

-(void)viewWillAppear:(BOOL)animated{

    if([_blackListAry count]==0)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"没有黑名单成员"];
    }
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    
    /*黑名单表格初始化*/
    [self resetTableViewFooterView];
    self.blackListTable.dataSource=self;
    self.blackListTable.delegate=self;
    self.blackListTable.bounces = NO;
     _blackListTable.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _blackListTable.bounds.size.width, 0.01)];
    [_blackListTable setSeparatorInset:UIEdgeInsetsZero];
    [_blackListTable setLayoutMargins:UIEdgeInsetsZero];
     _blackListTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.blackListTable addGestureRecognizer:longPressGr];
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*重置tableview的footerview*/
-(void)resetTableViewFooterView{

    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;//64
    /*黑名单表格初始化*/
    float footH=SCREEN_HEIGHT-[_blackListAry count]*75-rectStatus.size.height-rectNav.size.height;
    if(footH>0)
    {
        UIView* footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,footH)];
        footerView.backgroundColor=_viewColor;
        [_blackListTable setTableFooterView:footerView];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
       return [_blackListAry count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    static NSString *CellIdentifier = @"blackerid";
    blackerTableViewCell *cell = (blackerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
         cell = [[blackerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blackerid"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         blackerInfo* blacker=[_blackerAry objectAtIndex:rowNo];
         cell.blackerData=blacker;
       
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.0f;
}


- (UIView*)tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}


- (UIView*)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
}


// 单元格选中
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}


/* 设置单元格宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.blackListTable];
        
        NSIndexPath * indexPath = [self.blackListTable indexPathForRowAtPoint:point];
        
        if(indexPath == nil) return ;
        
        UIAlertController *dealBlackerAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *removePresentAct=[UIAlertAction actionWithTitle:@"解除当前" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            NSLog(@"解除当前");
            NSString* blackerIdStr=[[_blackListAry objectAtIndex:indexPath.row] objectForKey:@"userId"];
            [self deleteOneBlacker:blackerIdStr deleteOneIndex:indexPath];
        }];
        
        UIAlertAction *removeAllAct=[UIAlertAction actionWithTitle:@"解除全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            
            NSLog(@"解除全部");
            [self deleteAllBlacker];
        }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击了取消");
        }];
        
        [removePresentAct setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [removeAllAct setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [cancelAct setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        [dealBlackerAlert addAction:removePresentAct];
        [dealBlackerAlert addAction:removeAllAct];
        [dealBlackerAlert addAction:cancelAct];
        //弹出提示框；
        [self presentViewController:dealBlackerAlert animated:true completion:nil];
    }
}

-(void)deleteOneBlacker:(NSString*)blackIdStr  deleteOneIndex:(NSIndexPath *)indexPath
{
    [self.parentViewController.view addSubview:backgroundView];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@black_user_id%@",userId,blackIdStr]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@823", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"black_user_id" :blackIdStr,
                                @"action_id" : @"2",
                                @"deviceType": @"ios",
                                @"apitype" : @"users",
                                @"salt" : @"823",
                                @"tag" : @"blacklist",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:black_user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除黑名单:%@", responseObject);
        
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            [_blackListAry removeObjectAtIndex:indexPath.row];
            [_blackListTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//UITableViewRowAnimationAutomatic
            [self resetTableViewFooterView];
            [backgroundView removeFromSuperview];
            
        }
        else if([[responseObject valueForKey:@"flag"] isEqualToString:@"del_error"])
        {
             [backgroundView removeFromSuperview];
             [MBProgressHUBTool textToast:self.view Tip:@"该用户不存在"];
        }else{
             [backgroundView removeFromSuperview];
             [MBProgressHUBTool textToast:self.view Tip:@"网络不给力"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}

-(void)deleteAllBlacker{

    [self.parentViewController.view addSubview:backgroundView];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@",userId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@823", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"deviceType": @"ios",
                                @"apitype" : @"users",
                                @"salt" : @"823",
                                @"tag" : @"clearblacklist",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除所有黑名单:%@", responseObject);
        
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            [_blackListAry removeAllObjects];
            [self resetTableViewFooterView];
            [_blackListTable reloadData];
            //[_blackListTable de];
            [backgroundView removeFromSuperview];
            
        }
        else if([[responseObject valueForKey:@"flag"] isEqualToString:@"parameter_error"])
        {
            [backgroundView removeFromSuperview];
            [MBProgressHUBTool textToast:self.view Tip:@"网络不给力"];
        }else{
            
            [backgroundView removeFromSuperview];
            [MBProgressHUBTool textToast:self.view Tip:@"网络不给力"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];


}
@end
