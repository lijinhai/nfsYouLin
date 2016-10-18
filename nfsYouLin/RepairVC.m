//
//  RepairVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "RepairVC.h"
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
#import "CreateRepairVC.h"
#import "HeaderFile.h"
#import "LewPopupViewController.h"
#import "PopLetterListView.h"
#import "lookScheduleVC.h"

@interface RepairVC ()

@end

@implementation RepairVC
{
    ListTableView* _listTableView;
    BackgroundView* _backGroundView;
    UIButton* _leftButton;
    UISegmentedControl *segment;
    UILabel *line1;
    UILabel *line2;
    NeighborDetailTVC* neighborDetailVC;
    UIView* backgroundView;
    UIView* waitBgV;
    DialogView* dialogView;
    UIViewController* rootVC;
    NSInteger topicId;
    NSString* newTopicId;
    NSString* oldTopicId;
    UIPanGestureRecognizer* _panGesture;
    UIImageView* _waitImageView;
    UIColor *_viewColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, screenWidth, self.view.bounds.size.height-85) style:UITableViewStyleGrouped];//110
    //self.tableView.frame=CGRectMake(0, 200, screenWidth, self.view.bounds.size.height-100);
    self.tableView.backgroundColor = [UIColor whiteColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.bounces = NO;
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGr];
    //self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];
    self.neighborDataArray = [[NSMutableArray alloc] init];
    //UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //rootVC = window.rootViewController.navigationController;
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;
    [ChatDemoHelper shareHelper].neighborVC.refresh = YES;
    topicId = 0;
    //[self initWaitImageAnimate];
    //_panGesture = self.tableView.panGestureRecognizer;
    //[_panGesture addTarget:self action:@selector(handlePan:)];
    [self.view addSubview:_tableView];
    //[self getRepairPosts];
}

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
    UIBarButtonItem *barrightBtn = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addRepair:)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    [self getRepairPosts];
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
            [self getRepairPosts];
            break;
        }
        case 1:{
            line2.backgroundColor=UIColorFromRGB(0xFFBA02);
            line1.backgroundColor=[UIColor darkGrayColor];
            [self getCompleteRepairPosts];
            break;
        }
        default:
            break;
    }
}

-(void)addRepair:(id)sender{
    
    if([SqliteOperation checkAudiAddressResult]){
        
        CreateRepairVC* repairVC = [[CreateRepairVC alloc] init];
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"create",@"option",
                                     nil];
        [repairVC setTopicInfo:dict];
        [self.navigationController pushViewController:repairVC animated:YES];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@" 您当前的地址信息不完整或正在审核中" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"哈哈哈哈哈");
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


// 表格分区包含多少元素
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// 表格包含分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.neighborDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellOther = @"cellOther";
    static NSString* cellRepair = @"cellRepair";
    NeighborTableViewCell* cell;
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellOther];
        if(cell == nil)
        {
            cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOther];
            [cell.deleteButton setHidden:YES];
        }
        cell.neighborDataFrame = self.neighborDataArray[indexPath.section];
        
    }
    else if(indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellRepair];
        if(cell == nil)
        {
            cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellRepair];
        }
        UIControl* letterCtl=cell.letterView;
        letterCtl.tag=indexPath.section;
        [letterCtl addTarget:self action:@selector(touchDownlLetter:) forControlEvents:UIControlEventTouchDown];
        UIControl* scheduleCtl =cell.scheduleView;
        [scheduleCtl addTarget:self action:@selector(touchDownlSchedule:) forControlEvents:UIControlEventTouchDown];
    }
    
    cell.sectionNum = indexPath.section;
    cell.rowNum = indexPath.row;
    cell.delegate = self;
    return cell;
}

//私信物业管理员
-(void)touchDownlLetter:(id)sender
{

    NSLog(@"私信物业管理员");
    NeighborDataFrame* dataFrame = self.neighborDataArray[[sender tag]];
    NSMutableArray* letterLister =  dataFrame.neighborData.propertyUserId;//propertyUserId
    PopLetterListView *view = [PopLetterListView defaultPopupView:letterLister];
    view.parentVC = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
     NSLog(@"动画结束");
    }];


}
//跳转至进度页面
-(void)touchDownlSchedule:(id)sender
{
    
   NSLog(@"跳转至进度页面");
    UIBarButtonItem *backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"维修进度" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItemTitle];
    lookScheduleVC *jumpScheduleVC = [[lookScheduleVC alloc] init];
    [self.navigationController pushViewController:jumpScheduleVC animated:YES];
}

// 表格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        return 40;
    }
    else
    {
        NeighborDataFrame *frame = self.neighborDataArray[indexPath.section];
        NSInteger height = frame.cellHeight + 1;
        return height;
    }
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
    return;
}



- (NSDictionary*) getResponseDictionary: (NSDictionary *) responseDict
{
    NSDictionary* dict;
    dict = @{
             @"iconName" : responseDict[@"senderPortrait"],
             @"titleName" : responseDict[@"topicTitle"],
             @"accountName" : responseDict[@"displayName"],
             @"publishText" : responseDict[@"topicContent"],
             @"picturesArray" : responseDict[@"mediaFile"],
             @"topicTime" : responseDict[@"topicTime"],
             @"systemTime" : responseDict[@"systemTime"],
             @"senderId" : responseDict[@"senderId"],
             @"cacheKey" : responseDict[@"cacheKey"],
             @"topicCategory" : responseDict[@"objectType"],
             @"propertyUserId" : responseDict[@"property_userId"],//objectData
             @"topicCategoryType" : responseDict[@"topicCategoryType"],
             @"topicId" : responseDict[@"topicId"],
             
             };
    return dict;
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
    UIView* addView = [[UIView alloc] initWithFrame:self.view.bounds];
    addView.alpha = 1.0;
    addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addView];
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
    [self.view addSubview:maskview];
    
    //    [self.view addSubview:maskview];
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
- (void) getRepairPosts
{
    //[self.view addSubview:waitBgV];
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
        
        NSLog(@"物业维修请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            [self setSegmentedControl];
            for (int i = 0; i < [responseObject count]; i++)
            {
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
                neighborDataFrame.neighborData = neighborData;
                [self.neighborDataArray addObject:neighborDataFrame];
                if(i == 0)
                {
                    topicId = [[dict valueForKey:@"topicId"] integerValue];
                    newTopicId=[NSString stringWithFormat:@"%ld",topicId];
                    NSLog(@"newTopicId = %ld",topicId);
                }
            }
        }else{
        
            UIImageView *noPIV=[[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2, 100, 90, 100)];
            noPIV.image=[UIImage imageNamed:@"baoxiuinit"];
            noPIV.center=CGPointMake(screenWidth/2, screenHeight/4);
            UILabel *tiplab=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2, 160, screenWidth, 20)];
            tiplab.text=@"您家里维护的棒棒的，没有报修！";
            tiplab.textAlignment=NSTextAlignmentCenter;
            tiplab.font=[UIFont systemFontOfSize:11.0];
            tiplab.center=CGPointMake(screenWidth/2, screenHeight/4+90);
            [self.view addSubview:noPIV];
            [self.view addSubview:tiplab];
        
        }
        //[_waitImageView removeFromSuperview];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}
// 完成维修
- (void) getCompleteRepairPosts
{
    //[self.view addSubview:waitBgV];
    [self.neighborDataArray removeAllObjects];
    [self.tableView reloadData];
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
        
        NSLog(@"物业维修请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++)
            {
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
                neighborDataFrame.neighborData = neighborData;
                [self.neighborDataArray addObject:neighborDataFrame];
                                if(i == 0)
                                {
                                    topicId = [[dict valueForKey:@"topicId"] integerValue];
                                    newTopicId=[NSString stringWithFormat:@"%ld",topicId];
                                    NSLog(@"newTopicId = %ld",topicId);
                                }
            }
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

//长按删除报修帖子
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        
        //deleteRepair
        CGPoint point = [gesture locationInView:self.tableView];
        
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if(indexPath == nil) return ;
        
        DialogView* deleteView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"deleteRepair"];
        [self.view  addSubview:backgroundView];
        [self.view  addSubview:deleteView];
        dialogView = deleteView;
        
        UIControl* oneCtl = deleteView.OneCtl;
        oneCtl.tag = topicId;
        [oneCtl addTarget:self action:@selector(touchDownOne:) forControlEvents:UIControlEventTouchUpInside];
        
        UIControl* allCtl = deleteView.AllCtl;
        allCtl.tag = topicId;
        [allCtl addTarget:self action:@selector(touchDownAll:) forControlEvents:UIControlEventTouchUpInside];

    }
}

// 删除一个
-(void)touchDownOne:(id)sender
{

    NSLog(@"删除一个");
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
}

// 删除所有
-(void)touchDownAll:(id)sender
{
    
    NSLog(@"删除所有");
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }

}
@end
