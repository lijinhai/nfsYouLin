//
//  AdministratorRTVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/10/18.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "AdministratorRTVC.h"
#import "ResidentRTVC.h"
#import "residenterRinfo.h"
#import "ListTableView.h"
#import "BackgroundView.h"
#import "NeighborTableViewCell.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "SqliteOperation.h"
#import "StringMD5.h"
#import "ShowImageView.h"
#import "DialogView.h"
#import "NeighborDetailTVC.h"
#import "ApplyDetailTVC.h"
#import "ChatDemoHelper.h"
#import "WaitView.h"
#import "MJRefresh.h"
#import "BackgroundView.h"
#import "DetailRepairVC.h"

@interface AdministratorRTVC ()

@end

@implementation AdministratorRTVC
{
    ListTableView* _listTableView;
    BackgroundView* _backGroundView;
    UIButton* _leftButton;
    UIView* backgroundView;
    UIView* waitBgV;
    DialogView* dialogView;
    UISegmentedControl *segment;
    UILabel *line1;
    UILabel *line2;
    UIViewController* rootVC;
    NSInteger topicId;
    NSString* newTopicId;
    NSString* oldTopicId;
    UIPanGestureRecognizer* _panGesture;
    UIImageView* _waitImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSegmentedControl];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(segment.frame)+2.5f, screenWidth, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    rootVC = window.rootViewController.navigationController;
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;
    [ChatDemoHelper shareHelper].neighborVC.refresh = YES;
    topicId = 0;
    _panGesture = self.tableView.panGestureRecognizer;
    [_panGesture addTarget:self action:@selector(handlePan:)];
    [self.view addSubview:_tableView];
    [self initWaitImageAnimate];
    [self getUserRepairPosts];
    
}
static NSString * const reuseIdentifier = @"Cell";

- (void)initWaitImageAnimate
{
    CGFloat waitW = self.view.bounds.size.width / 3;
    _waitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(waitW, CGRectGetMidY(self.view.bounds) - waitW, waitW, waitW)];
    _waitImageView.image = [UIImage animatedImageNamed:@"pd_topic_0" duration:0.5];
    UILabel* tiplab=[[UILabel alloc] initWithFrame:CGRectMake(waitW/4-20, _waitImageView.frame.size.height+8, 150, 20)];
    tiplab.text = @"正在加载，请等待...";
    tiplab.font = [UIFont systemFontOfSize:13.f];
    tiplab.textColor = UIColorFromRGB(0xFFBA02);
    [_waitImageView addSubview:tiplab];
    [self.view addSubview:_waitImageView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.userADAry = [[NSMutableArray alloc] init];
     self.neighborDataArray = [[NSMutableArray alloc] init];
    //[self getUserRepairPosts];
}
-(void)setSegmentedControl{
    
    if (!segment) {
        
        segment = [[UISegmentedControl alloc]initWithItems:nil];
        segment.frame=CGRectMake(0, 64, screenWidth, 40);
        [segment insertSegmentWithTitle:
         @"未完成" atIndex: 0 animated: NO ];
        [segment insertSegmentWithTitle:
         @"已完成" atIndex: 1 animated: NO ];
        // 去掉颜色,现在整个segment偶看不到,可以相应点击事件
        segment.tintColor = [UIColor clearColor];
        
        // 正常状态下
        NSDictionary * normalTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName : [UIColor grayColor]};
        [segment setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
        
        // 选中状态下
        NSDictionary * selctedTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName : UIColorFromRGB(0xFFBA02)};
        [segment setTitleTextAttributes:selctedTextAttributes forState:UIControlStateSelected];
        segment.backgroundColor=[UIColor whiteColor];
        segment.selectedSegmentIndex = 0;//设置默认选择项索引
        //设置跳转的方法
        [segment addTarget:self action:@selector(changesSegment:) forControlEvents:UIControlEventValueChanged];
        
        line1=[[UILabel alloc] initWithFrame:CGRectMake(0, 104, screenWidth/2, 3)];
        line1.backgroundColor=UIColorFromRGB(0xFFBA02);
        line2=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2,104, screenWidth/2, 3)];
        line2.backgroundColor=[UIColor darkGrayColor];
        [self.view addSubview:line1];
        [self.view addSubview:line2];
        [self.view addSubview:segment];
        
    }
    
}

-(void)changesSegment:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
            
        case 0:{
            line1.backgroundColor=UIColorFromRGB(0xFFBA02);
            line2.backgroundColor=[UIColor darkGrayColor];
            [self getUserRepairPosts];
            break;
        }
        case 1:{
            line2.backgroundColor=UIColorFromRGB(0xFFBA02);
            line1.backgroundColor=[UIColor darkGrayColor];
            [self getUserRepairedPosts];
            //[self getCompleteRepairPosts];
            break;
        }
        default:
            break;
    }
}

// 表格分区包含多少元素
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userADAry count];
}

// 表格包含分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResidentRTVC* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell)
    {
     cell = [[ResidentRTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    }
    residenterRinfo* cellresidenter = [_userADAry objectAtIndex:indexPath.row];
    cell.residenterRepairData = cellresidenter;
    return cell;
}


// 表格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        return 65;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    CGFloat h = self.tableView.contentSize.height;
    CGFloat H = CGRectGetHeight(self.view.frame);
    if(h <= H)
    {
        self.tableView.contentSize = CGSizeMake(CGRectGetWidth(self.tableView.frame), H + 5);
    }
}

// 处理单元格的选中
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    DetailRepairVC* dRVC = [[DetailRepairVC alloc] init];
    residenterRinfo* residenter = [_userADAry objectAtIndex:indexPath.row];
    dRVC.neighborData = self.neighborDataArray[indexPath.row];
    dRVC.repairF = residenter.auditStatus;
    UIBarButtonItem *backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"详细" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItemTitle];
    [self.navigationController pushViewController:dRVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSDictionary*) getResponseDictionary: (NSDictionary *) responseDict
{
    NSDictionary* dict;
    dict = @{
             @"phone" : responseDict[@"phone"],
             @"iconName" : responseDict[@"senderPortrait"],
             @"titleName" : responseDict[@"topicTitle"],
             @"accountName" : responseDict[@"displayName"],
             @"publishText" : responseDict[@"topicContent"],
             @"picturesArray" : responseDict[@"mediaFile"],
             @"topicTime" : [NSString stringWithFormat:@"%@", responseDict[@"topicTime"]],
             @"systemTime" : responseDict[@"systemTime"],
             @"senderName" : responseDict[@"senderName"],
             @"senderId" : responseDict[@"senderId"],
             @"cacheKey" : responseDict[@"cacheKey"],
             @"topicCategory" : responseDict[@"objectType"],
             @"topicId" : responseDict[@"topicId"],
             @"familyName" : responseDict[@"familyName"],
             
             };
    return dict;
}

- (void)upRefreshData
{
    
    [self upRefreshRepairPosts];
}


#pragma mark -Action

- (void) handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:self.tableView];
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if(translation.y > 0)
        {
            self.tableView.bounces = NO;
        }
        // 底部上拉
        else if(translation.y < 0)
        {
            self.tableView.bounces = YES;
        }
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat h = self.tableView.contentSize.height;
        CGFloat H = CGRectGetHeight(self.view.frame);
        if(h <= H)
        {
            self.tableView.contentSize = CGSizeMake(CGRectGetWidth(self.tableView.frame), H + 5);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftButton:(UIButton *)leftButton
{
    
    [self.parentViewController.view addSubview:_backGroundView];
    [self.parentViewController.view addSubview:_listTableView];
}

#pragma mark -cellDelegate

// 	圆形头像点击事件回调
- (void)showCircularImageViewWithImage:(UIImage*) image
{
    self.tableView.scrollEnabled = NO;
    UIView* addView = [[UIView alloc] initWithFrame:rootVC.view.bounds];
    addView.alpha = 1.0;
    addView.backgroundColor = [UIColor whiteColor];
    [rootVC.view addSubview:addView];
    ShowImageView* showImage = [[ShowImageView alloc] initWithFrame:self.view.frame circularImage:image];
    [showImage show:addView didFinish:^()
     {
         [UIView animateWithDuration:0.5f animations:^{
             
             showImage.alpha = 0.0f;
             addView.alpha = 0.0f;
             
         } completion:^(BOOL finished) {
             self.tableView.scrollEnabled = YES;
             [showImage removeFromSuperview];
             [addView removeFromSuperview];
         }];
         
     }];
    
}


// 图片点击回调事件
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    self.tableView.scrollEnabled = NO;
    UIView *maskview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [rootVC.view addSubview:maskview];
     ShowImageView* showImage = [[ShowImageView alloc] initWithFrame:self.parentViewController.view.bounds byClickTag:clickTag appendArray:imageViews];
    [showImage show:maskview didFinish:^(){
        [UIView animateWithDuration:0.5f animations:^{
            showImage.alpha = 0.0f;
            maskview.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [showImage removeFromSuperview];
            [maskview removeFromSuperview];
            self.tableView.scrollEnabled = YES;
        }];
        
    }];
    
}

#pragma mark -Network
// 获取维修帖子
- (void) getUserRepairPosts
{
    [rootVC.view addSubview:waitBgV];
    [self.userADAry removeAllObjects];
    [self.tableView reloadData];
    [self.neighborDataArray removeAllObjects];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id0process_type2",userId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : @"0",
                                @"process_type" : @"2",
                                @"apitype" : @"apiproperty",
                                @"category_type" : @"4",
                                @"tag" : @"getrepair",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:process_type:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"维修用户的网络请求:%@", responseObject);
        //NSMutableArray *infoArray = [responseObject valueForKey:@"info"];
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++)
            {
                residenterRinfo* residenterObj = [[residenterRinfo alloc] init];
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                residenterObj.headPicUrl = [[responseObject objectAtIndex:i] valueForKey:@"senderPortrait"];
                residenterObj.nikeAndComm = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"displayName"]];
                residenterObj.repairDetailInfo = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"topicTitle"]];
                residenterObj.repairTime = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"topicTime"]];
                residenterObj.systemTime = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"systemTime"]];
                NSString* repariflag = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i]  objectForKey:@"process_status"]];
                if([repariflag isEqualToString:@"1"])
                {
                    
                   residenterObj.auditStatus = @"等待审核";
                    
                }else if([repariflag isEqualToString:@"2"])
                {
                
                   residenterObj.auditStatus = @"审核通过，派人维修";
                }else{
                
                
                   residenterObj.auditStatus = @"维修完成";
                }
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                [_userADAry addObject:residenterObj];
                
                [self.neighborDataArray addObject:neighborData];
                if(i == 0)
                {
                    topicId = [[dict valueForKey:@"topicId"] integerValue];
                    newTopicId=[NSString stringWithFormat:@"%ld",topicId];
                    NSLog(@"newTopicId = %ld",topicId);
                }

            }

        }
        if([self.userADAry count] == 0)
        {
            [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"没有报修"];
        }
        [_waitImageView removeFromSuperview];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}
// 获取维修完成的帖子
- (void) getUserRepairedPosts
{
    [rootVC.view addSubview:waitBgV];
    [self.userADAry removeAllObjects];
    [self.tableView reloadData];
    [self.neighborDataArray removeAllObjects];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id0process_type3",userId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : @"0",
                                @"process_type" : @"3",
                                @"apitype" : @"apiproperty",
                                @"category_type" : @"4",
                                @"tag" : @"getrepair",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:process_type:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"维修用户的网络请求:%@", responseObject);
        //NSMutableArray *infoArray = [responseObject valueForKey:@"info"];
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++)
            {
                residenterRinfo* residenterObj = [[residenterRinfo alloc] init];
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                residenterObj.headPicUrl = [[responseObject objectAtIndex:i] valueForKey:@"senderPortrait"];
                residenterObj.nikeAndComm = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"displayName"]];
                residenterObj.repairDetailInfo = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"topicTitle"]];
                residenterObj.repairTime = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"topicTime"]];
                residenterObj.systemTime = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"systemTime"]];
                NSString* repariflag = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i]  objectForKey:@"process_status"]];
                if([repariflag isEqualToString:@"1"])
                {
                    
                    residenterObj.auditStatus = @"等待审核";
                    
                }else if([repariflag isEqualToString:@"2"])
                {
                    
                    residenterObj.auditStatus = @"审核通过，派人维修";
                }else{
                    
                    
                    residenterObj.auditStatus = @"维修完成";
                }
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                [_userADAry addObject:residenterObj];
                
                [self.neighborDataArray addObject:neighborData];
                if(i == 0)
                {
                    topicId = [[dict valueForKey:@"topicId"] integerValue];
                    newTopicId=[NSString stringWithFormat:@"%ld",topicId];
                    NSLog(@"newTopicId = %ld",topicId);
                }
                
            }
            
        }
        if([self.userADAry count] == 0)
        {
            [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"没有报修"];
        }
        [_waitImageView removeFromSuperview];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


/*上拉刷新，获取住户报修数据*/
-(void) upRefreshRepairPosts{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    if([self.userADAry count] == 0)
    {
        newTopicId = @"-1";
    }
    NSLog(@"newTopicId = %@",newTopicId);
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%@",userId,communityId, newTopicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : newTopicId,
                                @"apitype" : @"apiproperty",
                                @"category_type" : @"4",
                                @"tag" :  @"getrepair",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下拉刷新数据是%@",responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++)
            {
                residenterRinfo* residenterObj = [[residenterRinfo alloc] init];
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                residenterObj.headPicUrl = [[responseObject objectAtIndex:i] valueForKey:@"senderPortrait"];
                residenterObj.nikeAndComm = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"displayName"]];
                residenterObj.repairDetailInfo = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"topicTitle"]];
                residenterObj.repairTime = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"topicTime"]];
                residenterObj.systemTime = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"systemTime"]];
                NSString* repariflag = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i]  objectForKey:@"process_status"]];
                if([repariflag isEqualToString:@"1"])
                {
                    
                    residenterObj.auditStatus = @"等待审核";
                    
                }else if([repariflag isEqualToString:@"2"])
                {
                    
                    residenterObj.auditStatus = @"审核通过，派人维修";
                }else{
                    
                    
                    residenterObj.auditStatus = @"维修完成";
                }
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                [_userADAry addObject:residenterObj];
                
                [self.neighborDataArray addObject:neighborData];
                
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];
}

@end
