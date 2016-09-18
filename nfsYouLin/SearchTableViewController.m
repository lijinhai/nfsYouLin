//
//  SearchTableViewController.m
//  nfsYouLin
//
//  Created by Macx on 16/6/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "SearchTableViewController.h"
#import "ListTableView.h"
#import "BackgroundView.h"
#import "NeighborTableViewCell.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "ShowImageView.h"
#import "DialogView.h"
#import "NeighborDetailTVC.h"
#import "ApplyDetailTVC.h"
#import "ChatDemoHelper.h"
#import "WaitView.h"
#import "MJRefresh.h"
#import "NewsDetailVC.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController
{
    ListTableView* _listTableView;
    BackgroundView* _backGroundView;
    SearchBarView* _searchBar;
    UIButton* _leftButton;
    
    NSInteger category;
    
    NeighborDetailTVC* neighborDetailVC;
    UIView* backgroundView;
    UIView* waitBgV;
    DialogView* dialogView;
    UIViewController* rootVC;
    NSInteger topicId;
    UIPanGestureRecognizer* _panGesture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];

    self.tableView.bounces = NO;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];
    [self createSearchBar];
    [self setListView];
    self.neighborDataArray = [[NSMutableArray alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    rootVC = window.rootViewController.navigationController;
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;
    [ChatDemoHelper shareHelper].neighborVC.refresh = YES;
    topicId = 0;
    WaitView* waitView = [[WaitView alloc] initWithRect:@"正在提交搜索请求，请稍后..."];
    waitBgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    waitBgV.backgroundColor = [UIColor clearColor];
    [waitBgV addSubview:waitView];
    _panGesture = self.tableView.panGestureRecognizer;
    [_panGesture addTarget:self action:@selector(handlePan:)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    static NSString* cellAnother = @"cellAnother";
     NeighborTableViewCell* cell;
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellOther];
        if(cell == nil)
        {
            cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOther];
        }
        cell.neighborDataFrame = self.neighborDataArray[indexPath.section];

    }
    else if(indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellAnother];
        if(cell == nil)
        {
            cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellAnother];
        }
        NeighborDataFrame* dataFrame = self.neighborDataArray[indexPath.section];
        cell.replyData = dataFrame.neighborData;
    }
    
    cell.sectionNum = indexPath.section;
    cell.rowNum = indexPath.row;
    cell.delegate = self;
    return cell;
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
    [_searchBar resignFirstResponder];
//    [self readTotalInformation:indexPath.section];
}


#pragma mark -Private
- (void) createSearchBar
{
    _searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 120, self.navigationController.navigationBar.frame.size.height * 0.7)];
    
    _searchBar.placeholder = @"请输入关键字";
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.font = [UIFont systemFontOfSize:14];
    _searchBar.delegate = self;
    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchItem:)];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mm_title_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItem:)];
    //    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItems = @[leftItem, searchItem];
    
    
    _leftButton = _searchBar.leftButton;
    [_leftButton setTitle:@"搜全部" forState:UIControlStateNormal];

    [_leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];


}

- (void) setListView
{
//     UINavigationController* navigationController = self.navigationController;
    category = 0;
    _listTableView = [[ListTableView alloc] initWithFrame:CGRectMake(60 + 5, CGRectGetMaxY(self.navigationController.navigationBar.frame), 150, 250)];
    
    _backGroundView = [[BackgroundView alloc] initWithFrame:self.parentViewController.view.frame view:_listTableView];
    BackgroundView* backGroundView = _backGroundView;
    NSArray* nameArray = @[@"搜索全部", @"搜索话题", @"搜索活动", @"搜索公告", @"搜索建议"];
    NSArray* imageArray = @[@"quanbusou", @"huatisou", @"huodongsou", @"gonggaosou", @"jianyisou"];
    UIButton* leftButton = _leftButton;
    [_listTableView setListTableView:nameArray image:imageArray block:^(NSString* string){
        
        if([string isEqualToString:@"搜索全部"])
        {
            category = 0;
        }
        else if([string isEqualToString:@"搜索话题"])
        {
            category = 1;
        }
        else if([string isEqualToString:@"搜索活动"])
        {
            category = 2;
        }
        else if([string isEqualToString:@"搜索公告"])
        {
            category = 3;
        }
        else if([string isEqualToString:@"搜索建议"])
        {
            category = 5;
        }
        else
        {
            
        }

        NSString* newString = [string stringByReplacingOccurrencesOfString:@"索" withString:@""];
        [leftButton setTitle:newString forState:UIControlStateNormal];
        [backGroundView removeFromSuperview];
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

- (void)upRefreshData
{
    [self upSearchResultNet];
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




- (IBAction)backItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
	
- (IBAction)searchItem:(id)sender
{
    [_searchBar.textField resignFirstResponder];
    [self searchResultNet];
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


#pragma mark -SearchBarViewDelegate
- (void)SearchBarViewSearchButtonClicked:(SearchBarView *)searchBar
{
    [_searchBar.textField resignFirstResponder];
    [self searchResultNet];
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

// 报名
- (void) applyDetail:(NSInteger)activityId
{
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

// 查看报名详情回调
- (void)lookApplyDetail:(NSInteger)activityId
{
    [self lookApplyNet:activityId];
}

#pragma mark -cellDelegate 新闻查看
- (void) readNewsDetail:(NSDictionary *)newsInfo
{
    NewsDetailVC *newsDetailVC = [[NewsDetailVC alloc] init];
    newsDetailVC.newsUrl = [newsInfo valueForKey:@"new_url"];
    newsDetailVC.newsTitle = [newsInfo valueForKey:@"new_title"];
    newsDetailVC.newsImage = [newsInfo valueForKey:@"new_small_pic"];
    newsDetailVC.newsId = [[newsInfo valueForKey:@"new_id"] integerValue];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

// 查看全文回调事件
- (void)readTotalInformation:(NSInteger)sectionNum
{
    NeighborDataFrame* neighborDataFrame = self.neighborDataArray[sectionNum];
    NeighborData* neighborData = neighborDataFrame.neighborData;
    NSInteger topicId = [[neighborData valueForKey:@"topicId"] integerValue];
    NSInteger senderId = [[neighborData valueForKey:@"senderId"] integerValue];
    NSInteger num = [neighborData.viewCount integerValue] + 1;
    neighborData.viewCount = [NSString stringWithFormat:@"%ld",num];
    [self viewTopicNet:topicId];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    // 获取帖子状态网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%ldsender_id%ld",userId,communityId,topicId,senderId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"sender_id" : [NSNumber numberWithInteger:senderId],
                                @"apitype" : @"comm",
                                @"tag" : @"delstatus",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:sender_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取帖子状态网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            neighborDetailVC = [[NeighborDetailTVC alloc] init];
            UIBarButtonItem* detailItem = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.parentViewController.navigationItem setBackBarButtonItem:detailItem];
            neighborDetailVC.sectionNum = sectionNum - 1;
            neighborDetailVC.neighborData = neighborData;
            neighborDetailVC.neighborDF = neighborDataFrame;
            neighborDetailVC.neighborDA = self.neighborDataArray;
            [neighborDetailVC getReplyNet];
            [self.navigationController pushViewController:neighborDetailVC animated:YES];
        }
        else
        {
            for(int i = 0; i < [self.neighborDataArray count] ;i++)
            {
                NeighborDataFrame* neighborDataFrame = self.neighborDataArray[i];
                NeighborData* neighborData = neighborDataFrame.neighborData;
                
                if([neighborData.topicId integerValue] == topicId)
                {
                    [self.neighborDataArray removeObject:neighborDataFrame];
                    break;
                }
            }
            [self.tableView reloadData];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"帖子信息" message:@"此贴已不可见" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
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




#pragma mark -Network
// 搜索帖子
- (void) searchResultNet
{
    NSString* searchText = _searchBar.textField.text;
    if(searchText.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入搜索关键字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [rootVC.view addSubview:waitBgV];
    [self.neighborDataArray removeAllObjects];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id0",userId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : @"0",
                                @"key_word" : searchText,
                                @"apitype" : @"comm",
                                @"category_type" : [NSNumber numberWithInteger:category],
                                @"tag" : @"findtopic",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"搜索帖子网络请求:%@", responseObject);
            if([responseObject isKindOfClass:[NSArray class]])
            {
                for (int i = 0; i < [responseObject count]; i++)
                {
                    NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                    NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                    NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
                    neighborDataFrame.neighborData = neighborData;
                    [self.neighborDataArray addObject:neighborDataFrame];
                    if(i == ([responseObject count] - 1))
                    {
                        topicId = [[dict valueForKey:@"topicId"] integerValue];
                        NSLog(@"topicId = %ld",topicId);
                    }
                }
            }        
            if([self.neighborDataArray count] == 0)
            {
                [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"没有搜到"];
            }
            [waitBgV removeFromSuperview];
            [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
}


// 上拉搜索帖子
- (void) upSearchResultNet
{
    NSString* searchText = _searchBar.textField.text;
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
                                @"count" : @"6",
                                @"key_word" : searchText,
                                @"apitype" : @"comm",
                                @"category_type" : [NSNumber numberWithInteger:category],
                                @"tag" : @"findtopic",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上拉搜索帖子网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++)
            {
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
                neighborDataFrame.neighborData = neighborData;
                [self.neighborDataArray addObject:neighborDataFrame];
                
                if(i == ([responseObject count] - 1))
                {
                    topicId = [[dict valueForKey:@"topicId"] integerValue];
                }
            }
            
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
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
            for(int i = 0; i < [self.neighborDataArray count] ;i++)
            {
                NeighborDataFrame* neighborDataFrame = self.neighborDataArray[i];
                NeighborData* neighborData = neighborDataFrame.neighborData;
                NSDictionary* dict = neighborData.infoArray[0];
                NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                if ([[dict valueForKey:@"activityId"] integerValue] == activityId) {
                    [dataDict setObject:@"true" forKey:@"enrollFlag"];
                    [dataDict setObject:[responseObject valueForKey:@"count"] forKey:@"enrollTotal"];
                    NSArray* array = [NSArray arrayWithObject:dataDict];
                    neighborDataFrame.neighborData.infoArray = [array mutableCopy];
                    [self.neighborDataArray replaceObjectAtIndex:i withObject:neighborDataFrame];
                }
            }
            [self.tableView reloadData];
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
            for(int i = 0; i < [self.neighborDataArray count] ;i++)
            {
                NeighborDataFrame* neighborDataFrame = self.neighborDataArray[i];
                NeighborData* neighborData = neighborDataFrame.neighborData;
                NSDictionary* dict = neighborData.infoArray[0];
                NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                if ([[dict valueForKey:@"activityId"] integerValue] == activityId) {
                    [dataDict setObject:@"false" forKey:@"enrollFlag"];
                    [dataDict setObject:[responseObject valueForKey:@"enrollTotal"] forKey:@"enrollTotal"];
                    NSArray* array = [NSArray arrayWithObject:dataDict];
                    neighborDataFrame.neighborData.infoArray = [array mutableCopy];
                    [self.neighborDataArray replaceObjectAtIndex:i withObject:neighborDataFrame];
                }
            }
            [self.tableView reloadData];
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
            for(int i = 0; i < [self.neighborDataArray count] ;i++)
            {
                NeighborDataFrame* neighborDataFrame = self.neighborDataArray[i];
                NeighborData* neighborData = neighborDataFrame.neighborData;
                
                if([neighborData.topicId integerValue] == topicId)
                {
                    [self.neighborDataArray removeObject:neighborDataFrame];
                    break;
                }
            }
            
            [self.tableView reloadData];
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
            for(int i = 0; i < [self.neighborDataArray count] ;i++)
            {
                NeighborDataFrame* neighborDataFrame = self.neighborDataArray[i];
                NeighborData* neighborData = neighborDataFrame.neighborData;
                NSDictionary* dict = neighborData.infoArray[0];
                NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                if([neighborData.topicId integerValue] == topicId)
                {
                    [dataDict setObject:@"1" forKey:@"sayHelloStatus"];
                    NSArray* array = [NSArray arrayWithObject:dataDict];
                    neighborDataFrame.neighborData.infoArray = [array mutableCopy];
                    [self.neighborDataArray replaceObjectAtIndex:i withObject:neighborDataFrame];
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
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 查看报名详情网络请求
- (void) lookApplyNet: (NSInteger)activityId
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"activityId%ld",activityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"activityId" : [NSNumber numberWithInteger:activityId],
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"detenroll",
                                @"hash" : hashString,
                                @"keyset" : @"activityId:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"查看报名详情网络请求:%@", responseObject);
        
        ApplyDetailTVC* applyDetailVC = [[ApplyDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
        UIBarButtonItem* detailItem = [[UIBarButtonItem alloc] initWithTitle:@"报名详情" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.parentViewController.navigationItem setBackBarButtonItem:detailItem];
        
        applyDetailVC.totalNum = [[responseObject valueForKey:@"enrollTotal"] integerValue];
        applyDetailVC.peopleA = [responseObject valueForKey:@"enrollData"];
        NSInteger activityId = [[responseObject valueForKey:@"activityId"] integerValue];
        
        for(int i = 0; i < [self.neighborDataArray count] ;i++)
        {
            NeighborDataFrame* neighborDataFrame = self.neighborDataArray[i];
            NeighborData* neighborData = neighborDataFrame.neighborData;
            NSDictionary* dict = neighborData.infoArray[0];
            NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            if ([[dict valueForKey:@"activityId"] integerValue] == activityId) {
                [dataDict setObject:[responseObject valueForKey:@"enrollTotal"] forKey:@"enrollTotal"];
                NSArray* array = [NSArray arrayWithObject:dataDict];
                neighborDataFrame.neighborData.infoArray = [array mutableCopy];
                [self.neighborDataArray replaceObjectAtIndex:i withObject:neighborDataFrame];
            }
        }
        [self.navigationController pushViewController:applyDetailVC animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
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

@end
