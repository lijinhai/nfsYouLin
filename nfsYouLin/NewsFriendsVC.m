//
//  NewsFriendsVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/18.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NewsFriendsVC.h"
#import "HeaderFile.h"
#import "PeopleInfoVC.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "Friends.h"
#import "FriendsManager.h"
#import "MBProgressHUBTool.h"


@interface NewsFriendsVC ()

@end

@implementation NewsFriendsVC
{
    NSMutableArray* friendsArr;
    NSArray* keysArr;
    NSMutableDictionary* friendsDict;
    
    UITableView* _tableView;

}

- (id) init
{
    self = [super init];
    if(self)
    {
        self.view.backgroundColor = BackgroundColor;
        
        friendsArr = [[NSMutableArray alloc] init];
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        [self.view addSubview:_tableView];
        [self getNeighborsListNet];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"附近邻居";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keysArr count];
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

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(keysArr)
        return [keysArr objectAtIndex:section];
    else
        return nil;
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
    
    cell.celldelegate = self;
    cell.row = indexPath.row;
    cell.section = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* key = [keysArr objectAtIndex:indexPath.section];
    NSMutableArray* arr = [friendsDict objectForKey:key];
    Friends* friend = arr[indexPath.row];
    NSInteger friendId = friend.userId;
    [self shareNewsNet:friendId];
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


#pragma mark -查看个人信息代理 cellDelegate
- (void) peopleInfoViewController:(NSInteger)peopleId icon:(NSString*)icon name:(NSString*)name
{
    PeopleInfoVC* peopleInfoVC = [[PeopleInfoVC alloc] init];
    peopleInfoVC.peopleId = peopleId;
    peopleInfoVC.icon = icon;
    peopleInfoVC.displayName = name;
    UIBarButtonItem* infoItem = [[UIBarButtonItem alloc] initWithTitle:@"邻居信息" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.parentViewController.navigationItem setBackBarButtonItem:infoItem];
    [self.navigationController pushViewController:peopleInfoVC animated:YES];
}

#pragma mark -获取邻居列表网络请求
- (void) getNeighborsListNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* blockId = [defaults stringForKey:@"block_id"];
    
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* nickDict = [[NSMutableDictionary alloc] init];
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
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"获取邻居列表网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            
            for(int i = 0;i < [responseObject count]; i++)
            {
                if([[responseObject[i] valueForKey:@"user_type"] integerValue] == 4)
                {
                    continue;
                }
                
                NSInteger Id =[[responseObject[i] valueForKey:@"user_id"] integerValue];
                [userDict setValue:[responseObject[i] valueForKey:@"user_portrait"] forKey:[NSString stringWithFormat:@"%ld",Id]];
                [nickDict setValue:[responseObject[i] valueForKey:@"user_nick"] forKey:[NSString stringWithFormat:@"%ld",Id]];
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
                friend.userId = [[responseObject[i] valueForKey:@"user_id"] integerValue];
                [friendsArr addObject:friend];
            }
            
            FriendsManager* manager = [[FriendsManager alloc] initWithArray:friendsArr];
            friendsDict = [manager friendsWithGroupAndSort];
            keysArr = [friendsDict allKeys];
            keysArr = [keysArr sortedArrayUsingSelector:@selector(compare:)];
        }
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取邻居列表请求失败:%@", error.description);
        return;
    }];
    
}

#pragma mark -分享新闻网络请求
- (void) shareNewsNet:(NSInteger)friendId
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String;
    NSString* hashString;
    NSDictionary* parameter;
    
    MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"recipy_id%@community_id%@sender_id%ldnews_id%ld",userId,communityId,friendId,self.newsId]];
    hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    parameter = @{@"recipy_id" : userId,
                  @"sender_id" : [NSNumber numberWithInteger:friendId],
                  @"community_id" : communityId,
                  @"news_id" : [NSNumber numberWithInteger:self.newsId],
                  @"apitype" : @"comm",
                  @"salt" : @"1",
                  @"tag" : @"newshare",
                  @"hash" : hashString,
                  @"keyset" : @"recipy_id:community_id:sender_id:news_id:",
                  };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"分享新闻网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"分享成功"];
        }
        else if([flag isEqualToString:@"black"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"好友为黑名单成员，分享失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"分享新闻请求失败:%@", error.description);
        return;
    }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
