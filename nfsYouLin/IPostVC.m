//
//  IPostVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/8/24.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "IPostVC.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "SqliteOperation.h"
#import "MyPostsDetailTVC.h"
#import "MBProgressHUBTool.h"
#import "DialogView.h"
#define SCREEN_WIDTH   ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)
@interface IPostVC ()

@end

@implementation IPostVC{
    
    UIPanGestureRecognizer* _panGesture;
    CGFloat contentOffsetY;
    UIColor* _downViewColor;
    UIView* _downView;
    UIView* _headView;
    UIView* _footerView;
    UILabel* _downLabel;
    UIView* _downView0;
    UIView* _downView1;
    UIView* _downView2;
    UIView* _downView3;
    UIView* _downView4;
    UIView* _downView5;
    CGFloat _viewX; // 下拉动画x坐标
    CGFloat _viewXCount; // 下拉动画x坐标变化位置
    
    UILabel* _finishLabel; // 上拉加载完成
    
    NSTimer* _downTimer; // 下拉定时器
    NSTimer* _upTimer; // 上拉定时器
    
    
    UIActivityIndicatorView *_indicatorView;
    UIActivityIndicatorView *_indicatorLoadView;
    UIColor* _color;
    
    // 等待动画变量
    NSTimer* _changeTimer;
    int _sectionNum;
    NSInteger _imageCount;
    
    UIImageView* _waitImageView;
    
    // topic Id
    NSString* newTopicId;
    NSString* oldTopicId;
    
    NSString* Tag;
    
    // 下拉结束标志
    BOOL downFlag;
    
    // 上拉结束标志
    BOOL upFlag;
    
    //  帖子切换结束标志
    BOOL topicFlag;
    
    MyPostsDetailTVC* myPostsDetailVC;
    UIView* backgroundView;
    DialogView* dialogView;
    
    NSInteger sectionCount;
    UIViewController* rootVC;
    UIBarButtonItem* backItemTitle;

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 修改导航栏颜色
    [self.navigationController.navigationBar setBarTintColor:_color];
    // 自定义导航返回箭头
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    self.navigationItem.title=@"";
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     self.postsDataArray = [[NSMutableArray alloc] init];

    if(self.refresh)
    {
        [self refreshData];
    }else{
        
        if(self.postsDataArray)
        {
            [self getMyPosts];
//            sectionCount = [self.postsDataArray count];
//            NSLog(@"sectionCount is %ld",sectionCount);
//            if([self.postsDataArray count]==0)
//            {
//                UILabel* tiplab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/4 , 200,30)];
//                tiplab.text=@"还没有发表任何帖子";
//                tiplab.font=[UIFont systemFontOfSize:13];
//                tiplab.textColor=[UIColor lightGrayColor];
//                tiplab.textAlignment = NSTextAlignmentCenter;
//                tiplab.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3);
//                tiplab.tag=907;
//                
//                UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/3 , 80,80)];
//                imageView.image=[UIImage imageNamed:@"init_mypush"];
//                imageView.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3-70);
//                imageView.tag=908;
//                
//                [self.view addSubview:tiplab];
//                [self.view addSubview:imageView];
//                return;
//            }
//            [self.PostsTableView reloadData];
        }
    }
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _color = [UIColor colorWithRed:255/255.0 green:222/255.0 blue:31/255.0 alpha:1];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    rootVC = window.rootViewController.navigationController;
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;
    
    contentOffsetY = 0;
    
    self.PostsTableView.bounces = NO;
    self.PostsTableView.delegate=self;
    self.PostsTableView.dataSource=self;
    
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    _downView.backgroundColor = _color;
    _downLabel = [[UILabel alloc] init];
    _downLabel.frame = _downView.frame;
    _downLabel.text = @"下拉刷新";
    
    
    _downLabel.textColor = [UIColor whiteColor];
    _downLabel.textAlignment = NSTextAlignmentCenter;
    [_downView addSubview:_downLabel];
    
    _downView0 = [[UIView alloc] init];
    _downView0.backgroundColor = [UIColor whiteColor];
    
    _downView1 = [[UIView alloc] init];
    _downView1.backgroundColor = [UIColor whiteColor];
    
    _downView2 = [[UIView alloc] init];
    _downView2.backgroundColor = [UIColor whiteColor];
    
    _downView3 = [[UIView alloc] init];
    _downView3.backgroundColor = [UIColor whiteColor];
    
    _downView4 = [[UIView alloc] init];
    _downView4.backgroundColor = [UIColor whiteColor];
    
    
    _downView5 = [[UIView alloc] init];
    _downView5.backgroundColor = [UIColor whiteColor];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.PostsTableView.frame), 4)];
    _headView.backgroundColor = [UIColor colorWithRed:51/255.0 green:181/255.0 blue:229/255.0 alpha:1];
    
    _finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.PostsTableView.frame.size.width / 2 - 40, 5, 80, 40)];
    _finishLabel.text = @"加载完成了";
    _finishLabel.enabled = NO;
    _finishLabel.font = [UIFont systemFontOfSize:12];
    _finishLabel.textAlignment = NSTextAlignmentLeft;
    
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.PostsTableView.frame), 44)];
    _footerView.backgroundColor = [UIColor whiteColor];
    
    _viewX = (CGRectGetWidth(_headView.frame)) / 5;
    
    //进度环
    _indicatorView = [[UIActivityIndicatorView alloc]
                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.hidesWhenStopped  = YES;
    _indicatorView.frame = CGRectMake(CGRectGetMidX(_footerView.frame) - 25, 0, 50, 50);
    [_footerView addSubview:_indicatorView];
    
    
     self.PostsTableView.tableHeaderView = _headView;
    [self.PostsTableView.tableHeaderView setHidden:YES];
    
     self.PostsTableView.tableFooterView = _footerView;
    
     _panGesture = self.PostsTableView.panGestureRecognizer;
    [_panGesture addTarget:self action:@selector(handlePan:)];
    
    
    
    if ([self.PostsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.PostsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.PostsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.PostsTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    upFlag = YES;
    topicFlag = YES;
    
     self.refresh = NO;
     sectionCount = 0;
    [self initWaitImageAnimate];
    //[self getMyPosts];
    
    
}

- (void)initWaitImageAnimate
{
    CGFloat waitW = self.view.bounds.size.width / 3;
    _indicatorLoadView = [[UIActivityIndicatorView alloc]
                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorLoadView.color=[UIColor yellowColor];
    _indicatorLoadView.frame = CGRectMake(waitW, CGRectGetMidY(self.view.bounds) - waitW, waitW, waitW);
    CGAffineTransform transform = CGAffineTransformMakeScale(1.8f, 1.8f);
    _indicatorLoadView.transform=transform;
    [self.view addSubview:_indicatorLoadView];
    [_indicatorLoadView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    if(contentOffsetY == 0)
    {
        contentOffsetY = self.PostsTableView.contentOffset.y;
    }
}

// 表格分区包含多少元素
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

// 表格包含分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    
    return sectionCount;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellOther = @"cellOther";
    static NSString* cellAnother = @"cellAnother";
    MyPostsTableViewCell* cell;
    // 帖子
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellOther];
        if(cell == nil)
        {
            cell = [[MyPostsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOther];
            
        }
        if([self.postsDataArray count] != 0)
        {
            cell.myPostsDataFrame = self.postsDataArray[indexPath.section];
        }
    }
    // 评论 赞 查看
    else if(indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellAnother];
        if(cell == nil)
        {
            cell = [[MyPostsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellAnother];
        }
        if([self.postsDataArray count] != 0)
        {
            MyPostsDataFrame* dataFrame = self.postsDataArray[indexPath.section];
            cell.replyData = dataFrame.myPostsData;
            cell.replyView.backgroundColor=[UIColor whiteColor];
            cell.praiseView.backgroundColor=[UIColor whiteColor];
            cell.watchView.backgroundColor=[UIColor whiteColor];
        }
    }
    cell.delegate=self;
    cell.sectionNum = indexPath.section;
    cell.rowNum = indexPath.row;
    
    return cell;
}

// 表格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        return 40;
    }
    else
    {
        MyPostsDataFrame *frame = self.postsDataArray[indexPath.section];
        NSInteger height = frame.cellHeight + 1;
        return height;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    }else
        return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    }else
        return 8.0f;
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


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}


// 处理单元格的选中
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return;
    }
    [self readTotalInformation:indexPath.section];
}

static BOOL upState = YES;

- (void) handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:self.PostsTableView];
    
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
       
        // 底部上拉条件
        if(translation.y < 0 && (self.PostsTableView.contentSize.height == self.PostsTableView.contentOffset.y + self.PostsTableView.frame.size.height))
        {
            _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.PostsTableView.frame), 94);
            self.PostsTableView.tableFooterView = _footerView;
            upState = NO;
            
        }
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        // 上拉拖拽
        if(!upState)
        {
            [_indicatorView startAnimating];
            [self.PostsTableView.tableFooterView setHidden:NO];
            if(fabs(translation.y) >= 50)
            {
                 _panGesture.enabled = NO;
                 _upTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(refreshUpData) userInfo:nil repeats:YES];
                [self upRefreshPosts];
                
            }
        }
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        // 上拉拖拽结束
        if(!upState)
        {
            [_indicatorView stopAnimating];
            [self.PostsTableView.tableFooterView setHidden:YES];
             _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.PostsTableView.frame), 8);
             self.PostsTableView.tableFooterView = _footerView;
            [self.PostsTableView reloadData];
        }
        upState = YES;
    }
    
    
}


// 上拉刷新数据

- (void) refreshUpData
{
    if(!upFlag)
    {
        [_upTimer invalidate];
        [_indicatorView stopAnimating];
        [_footerView addSubview:_finishLabel];
        [self performSelector:@selector(finishUpRefresh) withObject:nil afterDelay:0.5];
    }
}

// 上拉刷新完成
- (void) finishUpRefresh
{
    _panGesture.enabled = YES;
    upState = YES;
    [_finishLabel removeFromSuperview];
    _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.PostsTableView.frame), 44);
    self.PostsTableView.tableFooterView = _footerView;
    upFlag = YES;
    [self.PostsTableView reloadData];
    
}


// 	圆形头像点击事件回调
- (void)showCircularImageViewWithImage:(UIImage*) image
{
    self.PostsTableView.scrollEnabled = NO;
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
             self.PostsTableView.scrollEnabled = YES;
             [showImage removeFromSuperview];
             [addView removeFromSuperview];
         }];
         
     }];
    
}


// 图片点击回调事件
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    self.PostsTableView.scrollEnabled = NO;
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
            self.PostsTableView.scrollEnabled = YES;
        }];
        
    }];
    
}

// 帖子切换回调
- (void)reloadShowByTitle: (NSString* )text
{
    sectionCount = 0;
    topicFlag = YES;
    [self.postsDataArray removeAllObjects];
    [self.PostsTableView reloadData];
    
    _changeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(topicChange) userInfo:nil repeats:YES];
    [self.view addSubview:_waitImageView];
}


- (void) topicChange
{
    if(!topicFlag)
    {
        [_changeTimer invalidate];
        [_waitImageView removeFromSuperview];
        [self.PostsTableView reloadData];
        topicFlag = YES;
    }
}

// 报名
- (void) applyDetail:(NSInteger)activityId
{
    NSLog(@"报名详情");
    DialogView* applyView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"apply"];
    backgroundView.alpha = 0.0f;
    applyView.alpha = 0.0f;
    [rootVC.view  addSubview:backgroundView];
    [rootVC.view  addSubview:applyView];
    [UIView animateWithDuration:0.3f animations:^{
        backgroundView.alpha = 0.8f;
        applyView.alpha = 1.0f;
    }];
    
    dialogView = applyView;
    UIButton* okBtn = applyView.applyYes;
    okBtn.tag = activityId;
    [okBtn addTarget:self action:@selector(okApplyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelBtn = applyView.applyNo;
    [cancelBtn addTarget:self action:@selector(cancelApplyAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 取消报名回调
- (void) cancelApply:(NSInteger) activityId
{
    NSLog(@"取消报名");
    DialogView* cancelView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"cancelApply"];
    [rootVC.view  addSubview:backgroundView];
    [rootVC.view  addSubview:cancelView];
    
    dialogView = cancelView;
    UIButton* okBtn = cancelView.cancelApplyYes;
    okBtn.tag = activityId;
    [okBtn addTarget:self action:@selector(cancelOkApplyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelBtn = cancelView.cancelApplyNo;
    [cancelBtn addTarget:self action:@selector(cancelNoApplyAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 查看全文回调事件
- (void)readTotalInformation:(NSInteger)sectionNum
{
    MyPostsDataFrame* myPostsDataFrame = self.postsDataArray[sectionNum];
    MyPostsData* myPostsData = myPostsDataFrame.myPostsData;
    NSInteger topicId = [[myPostsData valueForKey:@"topicId"] integerValue];
    NSInteger num = [myPostsData.viewCount integerValue] + 1;
    myPostsData.viewCount = [NSString stringWithFormat:@"%ld",num];
    
    [self viewTopicNet:topicId];
    
    myPostsDetailVC = [[MyPostsDetailTVC alloc] init];
    myPostsDetailVC.sectionNum = sectionNum;
    myPostsDetailVC.myPostsData = myPostsData;
    myPostsDetailVC.myPostsDF = myPostsDataFrame;
    myPostsDetailVC.myPostsDA = self.postsDataArray;
    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItemTitle];
    [self.navigationController pushViewController:myPostsDetailVC animated:YES];
    
}

// 打招呼回调
- (void)sayHi:(NSInteger)topicId
{
    NSLog(@"打招呼");
    DialogView* hiView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"sayHi"];
    hiView.sayHiTV.text = @"欢迎小宝宝来到本小区";
    
    [rootVC.view  addSubview:backgroundView];
    [rootVC.view  addSubview:hiView];
    
    dialogView = hiView;
    UIButton* okBtn = hiView.send;
    okBtn.tag = topicId;
    [okBtn addTarget:self action:@selector(hiOkAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* cancelBtn = hiView.cancel;
    [cancelBtn addTarget:self action:@selector(hiNoAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 删除帖子回调
- (void)deleteTopic:(NSInteger)topicId
{
    DialogView* deleteView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"common"];
    [rootVC.view  addSubview:backgroundView];
    [rootVC.view  addSubview:deleteView];
    
    deleteView.titleL.text = @"确定要删除该内容嘛？";
    dialogView = deleteView;
    UIButton* okBtn = deleteView.OKbtn;
    okBtn.tag = topicId;
    [okBtn addTarget:self action:@selector(deleteOkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* noBtn = deleteView.NOBtn;
    [noBtn addTarget:self action:@selector(deleteNoAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

/*获得我发的帖子*/
-(void)getMyPosts{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [NSString stringWithFormat:@"%ld", [SqliteOperation getNowCommunityId]];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy.allowInvalidCertificates = YES;
     manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@",userId,communityId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@2016",hashString]];
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"count" : @"6",
                                @"deviceType":@"ios",
                                @"apitype" : @"comm",
                                @"tag" : @"mytopic",
                                @"salt" : @"2016",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:community_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"info_responseObject is %@",responseObject);
        for (int i = 0; i < [[responseObject objectForKey:@"info"] count]; i++,sectionCount++)
        {
            if((UILabel *)[self.view viewWithTag:907])
            {
                
                UILabel *label=(UILabel *)[self.view viewWithTag:907];
               [label removeFromSuperview];
            }
            if((UIImageView *)[self.view viewWithTag:908])
            {
                
                UIImageView *imageView=(UIImageView *)[self.view viewWithTag:908];
                [imageView removeFromSuperview];
            }
            
            NSDictionary* responseDict = [[responseObject objectForKey:@"info"] objectAtIndex:i];
            if(i == 0)
            {
                
                newTopicId = responseDict[@"topicId"];
            }
            
            if(i == ([[responseObject objectForKey:@"info"] count]-1))
            {
                
                oldTopicId = responseDict[@"topicId"];
                
            }
            NSDictionary* dict = [self getResponseDictionary:[[responseObject objectForKey:@"info"] objectAtIndex:i]];
            MyPostsData *myPostsData = [[MyPostsData alloc] initWithDict:dict];
            MyPostsDataFrame *myPostsDataFrame = [[MyPostsDataFrame alloc]init];
            myPostsDataFrame.myPostsData = myPostsData;
            [self.postsDataArray addObject:myPostsDataFrame];
            
        }
        [_indicatorLoadView stopAnimating];
        topicFlag = NO;
        sectionCount = [self.postsDataArray count];
        NSLog(@"sectionCount is %ld",sectionCount);
        if([self.postsDataArray count]==0)
        {
            UILabel* tiplab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/4 , 200,30)];
            tiplab.text=@"还没有发表任何帖子";
            tiplab.font=[UIFont systemFontOfSize:13];
            tiplab.textColor=[UIColor lightGrayColor];
            tiplab.textAlignment = NSTextAlignmentCenter;
            tiplab.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3);
            tiplab.tag=907;
            
            UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/3 , 80,80)];
            imageView.image=[UIImage imageNamed:@"init_mypush"];
            imageView.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3-70);
            imageView.tag=908;
            
            [self.view addSubview:tiplab];
            [self.view addSubview:imageView];
            return;
        }
        [self.PostsTableView reloadData];
        //[self.PostsTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];
    
}


- (void) refreshData
{
    
    NSLog(@"上拉刷新");
    [self upRefreshPosts];
     self.refresh = NO;
}
/*上拉刷新，获取帖子数据*/
-(void) upRefreshPosts{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [NSString stringWithFormat:@"%ld", [SqliteOperation getNowCommunityId]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%@",userId,communityId,oldTopicId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@2016",hashString]];
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : oldTopicId,
                                @"count" : @"6",
                                @"deviceType":@"ios",
                                @"apitype" : @"comm",
                                @"tag" : @"mytopic",
                                @"salt" : @"2016",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        for (int i = 0; i < [[responseObject objectForKey:@"info"] count]; i++,sectionCount++)
        {
            NSDictionary* responseDict = [[responseObject objectForKey:@"info"] objectAtIndex:i];
            if(i == ([[responseObject objectForKey:@"info"] count]-1))
            {
                oldTopicId = responseDict[@"topicId"];
                
            }
            
             NSDictionary* dict = [self getResponseDictionary:[[responseObject objectForKey:@"info"] objectAtIndex:i]];
            
             MyPostsData *myPostsData = [[MyPostsData alloc] initWithDict:dict];
             MyPostsDataFrame *myPostsDataFrame = [[MyPostsDataFrame alloc]init];
             myPostsDataFrame.myPostsData = myPostsData;
            [self.postsDataArray addObject:myPostsDataFrame];
        }
        
        upFlag = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];
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
             @"infoArray" : responseDict[@"objectData"],
             @"praiseType" : responseDict[@"praiseType"],
             @"viewCount" : responseDict[@"viewNum"],
             @"praiseCount" : responseDict[@"likeNum"],
             @"replyCount" : responseDict[@"commentNum"],
             @"topicId" : responseDict[@"topicId"],
             
             };
    return dict;
}


// 确定报名
- (void) okApplyAction: (id)sender
{
    NSLog(@"确定报名");
    
    UIButton* button = (UIButton*)sender;
    NSInteger activityId = button.tag;
    
    [self applyNet:activityId Adult:[dialogView.adultTF.text integerValue] Child:[dialogView.childTF.text integerValue]];
    
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
}

// 取消报名
- (void) cancelApplyAction: (id)sender
{
    NSLog(@"取消报名");
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
}

// 确定取消报名
- (void) cancelOkApplyAction: (id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger activityId = button.tag;
    [self cancelApplyNet:activityId];
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}

// 不取消报名
- (void) cancelNoApplyAction: (id) sender
{
    
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}

// 确定删除帖子
- (void) deleteOkAction: (id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger topicId = button.tag;
    [self deleteTopicNet:topicId];
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}

// 取消删除帖子
- (void) deleteNoAction: (id) sender
{
    
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}

// 发送打招呼
- (void) hiOkAction: (id) sender
{
    
    if(dialogView)
    {
        UIButton* button = (UIButton*)sender;
        NSInteger topicId = button.tag;
        [self sayHiNet:topicId Content:dialogView.sayHiTV.text];
        [backgroundView removeFromSuperview];
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}

// 取消发送打招呼
- (void) hiNoAction: (id) sender
{
    NSLog(@"取消发送打招呼");
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}

// 浏览帖子次数网络请求
// topicId 帖子id
- (void) viewTopicNet: (NSInteger)topicId
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ldcommunity_id%@",userId,topicId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"community_id" : communityId,
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"intotopic",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:community_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"浏览帖子次数网络请求:%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 报名网络请求
// activityId 活动Id adultNum 成人人数 childNum 小孩人数
- (void) applyNet:(NSInteger) activityId Adult:(NSInteger)adultNum Child:(NSInteger)childNum
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"activityId%lduserId%@enrollUserCount%ldenrollNeCount%ld",activityId,userId,adultNum,childNum]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"activityId" :
                                    [NSNumber numberWithInteger:activityId],
                                @"userId" : userId,
                                @"enrollUserCount" : [NSNumber numberWithInteger:adultNum],
                                @"enrollNeCount" : [NSNumber numberWithInteger:childNum],
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"enroll",
                                @"hash" : hashString,
                                @"keyset" : @"activityId:userId:enrollUserCount:enrollNeCount:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"报名网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            for(int i = 0; i < [self.postsDataArray count] ;i++)
            {
                MyPostsDataFrame* myPostsDataFrame = self.postsDataArray[i];
                MyPostsData* myPostsData = myPostsDataFrame.myPostsData;
                NSDictionary* dict = myPostsData.infoArray[0];
                NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                if ([[dict valueForKey:@"activityId"] integerValue] == activityId) {
                    [dataDict setObject:@"true" forKey:@"enrollFlag"];
                    [dataDict setObject:[responseObject valueForKey:@"count"] forKey:@"enrollTotal"];
                    NSArray* array = [NSArray arrayWithObject:dataDict];
                    myPostsDataFrame.myPostsData.infoArray = [array mutableCopy];
                    [self.postsDataArray replaceObjectAtIndex:i withObject:myPostsDataFrame];
                }
            }
            [self.PostsTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 删除帖子网络请求
// topicId 帖子Id
- (void) deleteTopicNet:(NSInteger) topicId
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%ld",userId,communityId,topicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"deltopic",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除帖子网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            for(int i = 0; i < [self.postsDataArray count] ;i++)
            {
                MyPostsDataFrame* myPostsDataFrame = self.postsDataArray[i];
                MyPostsData* myPostsData = myPostsDataFrame.myPostsData;
                
                if([myPostsData.topicId integerValue] == topicId)
                {
                    [self.postsDataArray removeObject:myPostsDataFrame];
                    sectionCount = sectionCount - 1;
                    break;
                }
            }
            [self.PostsTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 取消报名网络请求
// activityId 活动Id
- (void) cancelApplyNet:(NSInteger) activityId
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"activityId%lduserId%@",activityId,userId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"activityId" :
                                    [NSNumber numberWithInteger:activityId],
                                @"userId" : userId,
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"delenroll",
                                @"hash" : hashString,
                                @"keyset" : @"activityId:userId:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"取消报名网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            for(int i = 0; i < [self.postsDataArray count] ;i++)
            {
                MyPostsDataFrame* myPostsDataFrame = self.postsDataArray[i];
                MyPostsData* myPostsData = myPostsDataFrame.myPostsData;
                NSDictionary* dict = myPostsData.infoArray[0];
                NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                if ([[dict valueForKey:@"activityId"] integerValue] == activityId) {
                    [dataDict setObject:@"false" forKey:@"enrollFlag"];
                    [dataDict setObject:[responseObject valueForKey:@"enrollTotal"] forKey:@"enrollTotal"];
                    NSArray* array = [NSArray arrayWithObject:dataDict];
                    myPostsDataFrame.myPostsData.infoArray = [array mutableCopy];
                    [self.postsDataArray replaceObjectAtIndex:i withObject:myPostsDataFrame];
                }
            }
            [self.PostsTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


// 打招呼网络请求
// topicId 帖子Id content 打招呼内容
- (void) sayHiNet:(NSInteger) topicId Content:(NSString*)content
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ldcontent%@",userId,topicId,content]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"content" : content,
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"sayhello",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:content:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"打招呼网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            for(int i = 0; i < [self.postsDataArray count] ;i++)
            {
                MyPostsDataFrame* myPostsDataFrame = self.postsDataArray[i];
                MyPostsData* myPostsData = myPostsDataFrame.myPostsData;
                NSDictionary* dict = myPostsData.infoArray[0];
                NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                if([myPostsData.topicId integerValue] == topicId)
                {
                    [dataDict setObject:@"1" forKey:@"sayHelloStatus"];
                    NSArray* array = [NSArray arrayWithObject:dataDict];
                    myPostsDataFrame.myPostsData.infoArray = [array mutableCopy];
                    [self.postsDataArray replaceObjectAtIndex:i withObject:myPostsDataFrame];
                    break;
                }
                
            }
            
        }
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"black"])
        {
        }
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"no"])
        {
        }
        [self.PostsTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

@end
