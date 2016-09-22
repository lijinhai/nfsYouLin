//
//  youLinDiscoveryController.m
//  nfsYouLin
//
//  Created by Macx on 16/5/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DiscoveryTVC.h"
#import "FriendsVC.h"
#import "ChatDemoHelper.h"
#import "DiscoveryViewCell.h"
#import "NewsVC.h"
#import "PropertyVC.h"
#import "ServiceVC.h"
#import "NoticeVC.h"
#import "WeatherVC.h"

@interface DiscoveryTVC ()

@end

@implementation DiscoveryTVC
{
    NSArray* _discoveryServiceName;
    NSArray* _discoveryServiceImages;
    UIColor* _viewColor;
    UITabBarController* _parentController;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        self.tableView.bounces = NO;
        _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
        _discoveryServiceName = @[@"邻居", @"商圈", @"公告" ,@"新闻" ,@"天气" ,@"社区服务", @"物业"];
        _discoveryServiceImages = @[@"icon_linju.png", @"icon_shangquan.png" ,@"icon_gonggao.png", @"icon_xinwen.png" ,@"icon_xinwen.png", @"icon_shequfuwu.png", @"icon_wuye.png"];
        /*tableViewCell 下划线 长度设置为屏幕的宽*/
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        
       
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 自定义导航返回箭头
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setRefreshIsMessage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger elementOfSection;
    switch (section) {
        case 0:
            elementOfSection = 1;
            break;
        case 1:
            elementOfSection = 1;
            break;
        case 2:
            elementOfSection = 3;
            break;
        case 3:
            elementOfSection = 2;
            break;
        default:
            elementOfSection = -1;
            break;
    }
    return elementOfSection;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    NSInteger sectionNo = indexPath.section;
    switch (sectionNo) {
        case 0:
            rowNo = rowNo;
            break;
        case 1:
            rowNo += 1;
            break;
        case 2:
            rowNo += 2;
            break;
        case 3:
            rowNo += 5;
            break;
        default:
            break;
    }
    static NSString* identifier = @"cell";
   
    DiscoveryViewCell* cell = (DiscoveryViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[DiscoveryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:_discoveryServiceImages[rowNo]];
    cell.textLabel.text = _discoveryServiceName[rowNo];
   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(sectionNo == 0)
    {
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSInteger unreadCount = 0;
        for (EMConversation *conversation in conversations) {
            unreadCount += conversation.unreadMessagesCount;
        }
        if(unreadCount > 0)
        {
            [cell setMessage:true];
        }
        else
        {
            [cell setMessage:false];
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 16.f;
    }else
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 3) {
//        return 80.f;
//    }else
    return 8.0f;
}


- (UIView*)tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* headerView = nil;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    headerView.backgroundColor = _viewColor;
    return headerView;
}


- (UIView*)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = nil;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    footerView.backgroundColor = _viewColor;
    return footerView;
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
}


// 单元格选中
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *fontColor= [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    NSInteger rowInSection = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            // 邻居
            FriendsVC* friendVC = [ChatDemoHelper shareHelper].friendVC;
            if(friendVC)
            {
                friendVC.listFlag = YES;
                UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"邻居" style:UIBarButtonItemStylePlain target:nil action:nil];
                [neighborItem setTintColor:[UIColor whiteColor]];
                [self.parentViewController.navigationItem setBackBarButtonItem:neighborItem];
                [self.navigationController pushViewController:friendVC animated:YES];
            }
          
            
            break;
        }
        case 1:
        {
            // 商圈
            break;
        }
        case 2:
        {
            switch (rowInSection) {
                case 0:
                {
                    // 公告
                    NoticeVC* noticeVC = [[NoticeVC alloc] initWithStyle:UITableViewStyleGrouped];
                    UIBarButtonItem* noticeItem = [[UIBarButtonItem alloc] initWithTitle:@"物业公告" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [noticeItem setTintColor:[UIColor whiteColor]];
                    [self.parentViewController.navigationItem setBackBarButtonItem:noticeItem];
                    [self.navigationController pushViewController:noticeVC animated:YES];
                    break;
                }
                case 1:
                {
                    // 新闻
                    NewsVC* newsVC = [[NewsVC alloc] init];
                    UIBarButtonItem* newsItem = [[UIBarButtonItem alloc] initWithTitle:@"新闻" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [newsItem setTintColor:[UIColor whiteColor]];
                    [self.parentViewController.navigationItem setBackBarButtonItem:newsItem];
                    [self.navigationController pushViewController:newsVC animated:YES];
                    
                    break;
                }
                case 2:
                {
                    // 天气
                    WeatherVC* weatherVC = [[WeatherVC alloc] init];
                    UIBarButtonItem* weatherItem = [[UIBarButtonItem alloc] initWithTitle:@"天气" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [weatherItem setTintColor:[UIColor whiteColor]];
                    [self.parentViewController.navigationItem setBackBarButtonItem:weatherItem];
                    [self.navigationController pushViewController:weatherVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 3:
        {
            switch (rowInSection) {
                case 0:
                {
                    // 社区服务
                    ServiceVC* serviceVC = [[ServiceVC alloc] init];
                    UIBarButtonItem* serviceItem = [[UIBarButtonItem alloc] initWithTitle:@"社区服务" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.parentViewController.navigationItem setBackBarButtonItem:serviceItem];
                    [self.navigationController pushViewController:serviceVC animated:YES];
                    break;
                }
                case 1:
                {
                    // 物业
                    PropertyVC*  propertyVC=[[PropertyVC alloc] init];
                    UIBarButtonItem* backitem=[[UIBarButtonItem alloc] initWithTitle:@"物业" style:UIBarButtonItemStylePlain target:nil action:nil];
                     self.parentViewController.navigationItem.backBarButtonItem=backitem;
                    [self.navigationController pushViewController:propertyVC animated:YES];
                    
                    break;
                }
                    
                default:
                    break;
            }
        }
        default:
            break;
    }
}


/* 设置单元格宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void) setRefreshIsMessage
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    if(unreadCount > 0)
    {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
    }
    else
    {
        self.tabBarItem.badgeValue = nil;
    }
    [self.tableView reloadData];
}


@end
