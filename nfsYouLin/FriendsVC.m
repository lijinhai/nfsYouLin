//
//  FriendsVC.m
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FriendsVC.h"
#import "FriendViewCell.h"
#import "SegmentView.h"
#import "NDetailTableViewController.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "Friends.h"
#import "FriendsManager.h"
#import "MJRefresh.h"

@interface FriendsVC ()

@end

@implementation FriendsVC
{
    SegmentView* segmentView;
    UIColor *color;
    NSMutableArray* friendsArr;
    NSArray* keysArr;
    NSDictionary* friendsDict;
    UIActivityIndicatorView* indicator;
    UIView* backgroundView;
    UIView* headerView;
    UIPanGestureRecognizer* _panGesture;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    color = [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    friendsArr = [[NSMutableArray alloc] init];
    segmentView = [[SegmentView alloc] init];
   
    
    
    UIButton* neighborsBtn = segmentView.neighborsBtn;
    segmentView.nLineView.backgroundColor = color;
    [neighborsBtn setTitleColor:color forState:UIControlStateNormal];

    [neighborsBtn addTarget:self action:@selector(neighborsAction:) forControlEvents:UIControlEventTouchDown];
    
    UIButton* chatBtn = segmentView.chatBtn;
    [chatBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:segmentView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    headerView.backgroundColor = [UIColor redColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentView.frame) + 1, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(segmentView.frame)) style:UITableViewStyleGrouped];

   

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    backgroundView.alpha = 0.5;
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetWidth(backgroundView.frame)/2 - 25, CGRectGetHeight(backgroundView.frame) / 2- 25, 50, 50)];
    indicator.hidesWhenStopped = YES;
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator startAnimating];
    [backgroundView addSubview:indicator];
    
    _panGesture = self.tableView.panGestureRecognizer;
    [_panGesture addTarget:self action:@selector(handlePan:)];
    
    [self.view addSubview:self.tableView];
    [self getNeighborsListNet];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// 点击好友列表
- (void) neighborsAction: (id)sender
{
    self.tableView.bounces = YES;
    [segmentView.neighborsBtn setTitleColor:color forState:UIControlStateNormal];
    segmentView.nLineView.backgroundColor = color;
    
    [segmentView.chatBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    segmentView.cLineView.backgroundColor = [UIColor whiteColor];
    [friendsArr removeAllObjects];
    keysArr = nil;
    [self.tableView reloadData];
    [self.parentViewController.view addSubview:backgroundView];
    [self getNeighborsListNet];

    
}

// 点击聊天记录
- (void) chatAction: (id) sender
{
    self.tableView.bounces = NO;
    [segmentView.neighborsBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    segmentView.nLineView.backgroundColor = [UIColor whiteColor];
    
    [segmentView.chatBtn setTitleColor:color forState:UIControlStateNormal];
    segmentView.cLineView.backgroundColor = color;
    keysArr = nil;
    [self.tableView reloadData];

    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(keysArr)
        return [keysArr count];
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(keysArr)
    {
        NSString* key = [keysArr objectAtIndex:section];
        NSMutableArray* arr = [friendsDict objectForKey:key];
        return [arr count];
    }
    else
        return 0;
 
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(keysArr)
        return [keysArr objectAtIndex:section];
    else
        return @"";
}

// 右侧索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(keysArr)
        return keysArr;
    else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    FriendViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[FriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        
    }
    if(keysArr)
    {
        NSString* key = [keysArr objectAtIndex:indexPath.section];
        NSMutableArray* arr = [friendsDict objectForKey:key];
        Friends* friend = arr[indexPath.row];
        cell.friendsData = friend;

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 30;
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == [keysArr count] - 1)
        return 0.1;
    return 15;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

// 下拉刷下
- (void)loadNewData
{
    [friendsArr removeAllObjects];
    [self getNeighborsListNet];
}

- (void) handlePan:(UIPanGestureRecognizer*)gesture
{
//    CGPoint velocity = [gesture velocityInView:self.tableView];
    CGPoint translation = [gesture translationInView:self.tableView];
    
//    NSLog(@"水平速度:%g 垂直速度为:%g 水平位移:%g 垂直位移:%g",velocity.x ,velocity.y, translation.x ,translation.y);
    
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if(translation.y > 0)
        {
            self.tableView.bounces = YES;
        }
        // 底部上拉
        else if(translation.y < 0)
        {
            self.tableView.bounces = NO;
        }
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        self.tableView.bounces = NO;

    }
    
    
}



- (void) getNeighborsListNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* blockId = [defaults stringForKey:@"block_id"];
   
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String;
    NSString* hashString;
    NSDictionary* parameter;
    
    MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@block_id%@",userId,communityId,blockId]];
    hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    parameter = @{@"user_id" : userId,
                  @"community_id" : communityId,
                  @"block_id" : blockId,
                  @"apitype" : @"users",
                  @"salt" : @"1",
                  @"tag" : @"neighbors",
                  @"hash" : hashString,
                  @"keyset" : @"user_id:community_id:block_id:",
                  };

    NSLog(@"parameters = %@",parameter);
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取邻居列表网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            
            for(int i = 0;i < [responseObject count]; i++)
            {
                if([[responseObject[i] valueForKey:@"user_type"] integerValue] == 4)
                {
                    continue;
                }
                
                if([userId integerValue] == [[responseObject[i] valueForKey:@"user_id"] integerValue])
                {
                    continue;
                }
                Friends* friend = [[Friends alloc] init];
                friend.nick = [responseObject[i] valueForKey:@"user_nick"];
                friend.iconAddr = [responseObject[i] valueForKey:@"user_portrait"];
                friend.houseAddr = [NSString stringWithFormat:@"%@-%@",[responseObject[i] valueForKey:@"building_num"],[responseObject[i] valueForKey:@"aptnum"]];
                friend.profession = [responseObject[i] valueForKey:@"user_profession"];
                friend.publicStatus = [responseObject[i] valueForKey:@"user_public_status"];
                [friendsArr addObject:friend];
            }
            
            FriendsManager* manager = [[FriendsManager alloc] initWithArray:friendsArr];
            friendsDict = [manager friendsWithGroupAndSort];
            keysArr = [friendsDict allKeys];
            keysArr = [keysArr sortedArrayUsingSelector:@selector(compare:)];
            [segmentView.neighborsBtn setTitle:[NSString stringWithFormat:@"附近邻居:%ld",[friendsArr count]] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [backgroundView removeFromSuperview];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取邻居列表请求失败:%@", error.description);
        return;
    }];

}



@end
