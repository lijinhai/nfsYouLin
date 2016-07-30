//
//  NeighborTableViewController.m
//  Neighbor2
//
//  Created by Macx on 16/5/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "NTableViewController.h"
#import "NDetailTableViewController.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "MBProgressHUBTool.h"
#import "DialogView.h"

@interface NTableViewController ()

@end

@implementation NTableViewController
{
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
    UIColor* _color;
    
    NDetailTableViewController* _detailController;
    
    // 等待动画变量
    NSTimer* _changeTimer;
    int _sectionNum;
    NSInteger _imageCount;

    UIImageView* _waitImageView;
    
    // topic Id
    NSString* newTopicId;
    NSString* oldTopicId;
    
    //全部:0 话题:1 2:活动 3:公告 5:建议 6:闲品会
    NSInteger category;
    NSString* Tag;
    
    // 下拉结束标志
    BOOL downFlag;
    
    // 上拉结束标志
    BOOL upFlag;
    
    //  帖子切换结束标志
    BOOL topicFlag;
    
    
    UIView* backgroundView;
    DialogView* dialogView;
    
    NSInteger sectionCount;
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.neighborDataArray)
    {
        if([self.neighborDataArray count] != (sectionCount - 1))
        {
            sectionCount = sectionCount - 1;
        }
    }
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    contentOffsetY = 0;
    // 改变BarItem 图片系统颜色为 自定义颜色 ffba20 
    UIImage *neighborImageA = [UIImage imageNamed:@"btn_linjuquan_a.png"];
    neighborImageA = [neighborImageA imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.neighborTabBarItem.selectedImage = neighborImageA;
    // uicolor ffba20
    _color = [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    
    [self.neighborTabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : _color} forState:UIControlStateSelected];
    // 修改导航栏颜色
    [self.navigationController.navigationBar setBarTintColor:_color];
    UIView * tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    tmpView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:tmpView];
    self.tableView.bounces = NO;
    self.neighborDataArray = [[NSMutableArray alloc] init];

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
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 4)];
    _headView.backgroundColor = [UIColor colorWithRed:51/255.0 green:181/255.0 blue:229/255.0 alpha:1];

    _finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width / 2 - 40, 5, 80, 40)];
    _finishLabel.text = @"加载完成了";
    _finishLabel.enabled = NO;
    _finishLabel.font = [UIFont systemFontOfSize:12];
    _finishLabel.textAlignment = NSTextAlignmentLeft;

    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44)];
    _footerView.backgroundColor = [UIColor whiteColor];
    
    _viewX = (CGRectGetWidth(_headView.frame)) / 5;
    
    //进度环
    _indicatorView = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.hidesWhenStopped  = YES;
    _indicatorView.frame = CGRectMake(CGRectGetMidX(_footerView.frame) - 25, 0, 50, 50);
    [_footerView addSubview:_indicatorView];

    
    self.tableView.tableHeaderView = _headView;
    [self.tableView.tableHeaderView setHidden:YES];
    
    self.tableView.tableFooterView = _footerView;
//    [self.tableView.tableFooterView setHidden:YES];
    
    _panGesture = self.tableView.panGestureRecognizer;
    [_panGesture addTarget:self action:@selector(handlePan:)];
    
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
//    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Neighbour" bundle:nil];
//    _detailController = [storyBoard instantiateViewControllerWithIdentifier:@"details"];
    
    backgroundView = [[UIView alloc] initWithFrame:self.parentViewController.parentViewController.view.bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;
    
    downFlag = YES;
    upFlag = YES;
    topicFlag = YES;
    Tag = @"gettopic";
    category = 1;
    sectionCount = 1;
    [self initWaitImageAnimate];
    [self.view addSubview:_waitImageView];
    
    [self getTopicNet];
    

}

- (void)initWaitImageAnimate
{
    CGFloat waitW = self.view.bounds.size.width / 3;
    _waitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(waitW, CGRectGetMidY(self.view.bounds) - waitW, waitW, waitW)];
    _waitImageView.image = [UIImage animatedImageNamed:@"pd_topic_0" duration:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    if(contentOffsetY == 0)
    {
        contentOffsetY = self.tableView.contentOffset.y;
    }
}

// 表格分区包含多少元素
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
        return 2;
}

// 表格包含分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    if(sectionCount == 0)
    {
        return 1;
    }
    return sectionCount;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellTitle = @"cellTitle";
    static NSString* cellOther = @"cellOther";
    static NSString* cellAnother = @"cellAnother";
    NeighborTableViewCell* cell;
    // 标题选择栏
    if(indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellTitle];
        if(cell == nil)
        {
            cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTitle];
            
        }
        
    }

    else
    {
        // 帖子
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellOther];
            if(cell == nil)
            {
                cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOther];
            
            }
            if([self.neighborDataArray count] != 0)
            {
                cell.neighborDataFrame = self.neighborDataArray[indexPath.section - 1];
            }
        }
        // 评论 赞 查看
        else if(indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellAnother];
            if(cell == nil)
            {
                cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellAnother];
            }
            if([self.neighborDataArray count] != 0)
            {
                NeighborDataFrame* dataFrame = self.neighborDataArray[indexPath.section - 1];
                cell.replyData = dataFrame.neighborData;
            }
        }

}
    
    
    cell.delegate = self;
    cell.sectionNum = indexPath.section;
    cell.rowNum = indexPath.row;
    
    
    return cell;
}

// 表格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 51;
    }
    else if (indexPath.row == 1)
    {
        return 40;
    }
    
    else
    {
        NeighborDataFrame *frame = self.neighborDataArray[indexPath.section - 1];
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

// 滑动到顶部时调用该方法
//滑动到下方内容 点击系统顶部导航 自动定位到顶部时触发
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
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


//拖动后开始滑行
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
}


 //拖动后滑行结束
// 滚动停止时，触发该函数
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

//开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"scrollViewWillBeginDragging 开始拖拽 y=%f",self.tableView.contentOffset.y);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndScrollingAnimation");
}




static BOOL downState = YES;
static BOOL upState = YES;
//static BOOL refreshState = YES;
- (void) handlePan:(UIPanGestureRecognizer*)gesture
{
//    CGPoint velocity = [gesture velocityInView:self.tableView];
    CGPoint translation = [gesture translationInView:self.tableView];
    
//    NSLog(@"水平速度:%g 垂直速度为:%g 水平位移:%g 垂直位移:%g",velocity.x ,velocity.y, translation.x ,translation.y);
 
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
//        NSLog(@"began contentOffsetY = %f",contentOffsetY);
        // 顶部下拉条件
        if(translation.y > 0 && self.tableView.contentOffset.y == contentOffsetY && downState)
        {
//            NSLog(@"began 下拉");
            downState = NO;
//            [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
            [self.navigationController.navigationBar addSubview:_downView];
        }
        // 底部上拉条件
        else if(translation.y < 0 && (self.tableView.contentSize.height == self.tableView.contentOffset.y + self.tableView.frame.size.height))
        {
            _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 94);
            self.tableView.tableFooterView = _footerView;
            upState = NO;
            
        }
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        // 下拉拖拽
        if(!downState)
        {
            [self.tableView.tableHeaderView setHidden:NO];
            self.tableView.tableHeaderView.frame = CGRectMake(CGRectGetMidX(self.tableView.frame) - translation.y, 0, translation.y * 2, 4);
            // 进度条满状态
            if(CGRectGetMinX(self.tableView.tableHeaderView.frame) <= 0.0)
            {
                downState = YES;
                [_headView addSubview:_downView0];
                [_headView addSubview:_downView1];
                [_headView addSubview:_downView2];
                [_headView addSubview:_downView3];
                [_headView addSubview:_downView4];
                [_headView addSubview:_downView5];
                _viewXCount = 0;
                gesture.enabled = NO;
                _downTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(refreshDownData) userInfo:nil repeats:YES];
                if(category == 3 || category == 5)
                {
                    [self downRefreshNoticeAndAdviceNet:[NSString stringWithFormat:@"%ld", category]];
                }
                else
                {
                    [self downRefreshNet];
                }
                return;
            }
        }
        // 上拉拖拽
        if(!upState)
        {

            [_indicatorView startAnimating];
            [self.tableView.tableFooterView setHidden:NO];
            if(fabs(translation.y) >= 50)
            {
                _panGesture.enabled = NO;
                _upTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(refreshUpData) userInfo:nil repeats:YES];
                if(category == 3 || category == 5)
                {
                    [self upRefreshNoticeAndAdviceNet:[NSString stringWithFormat:@"%ld", category]];
                }
                else
                {
                    [self upRefreshNet];
                }
            }
        }
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
//        NSLog(@"end");
        // 下拉拖拽结束
        if(!downState)
        {
//            [self.navigationController.navigationBar setBarTintColor:_color];
            [self.tableView.tableHeaderView setHidden:YES];
            [_downView removeFromSuperview];
        }
        // 上拉拖拽结束
        if(!upState)
        {
            [_indicatorView stopAnimating];
            [self.tableView.tableFooterView setHidden:YES];
            _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 8);
            self.tableView.tableFooterView = _footerView;
            [self.tableView reloadData];
        }
        downState = YES;
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
//    [self.tableView.tableFooterView setHidden:YES];
    _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44);
    self.tableView.tableFooterView = _footerView;
    upFlag = YES;
    [self.tableView reloadData];

}

// 下拉刷新数据

- (void) refreshDownData
{
    _viewXCount++;
    if(_viewXCount >= _viewX)
    {
        _viewXCount = 0;
    }
    
     _downView0.frame = CGRectMake(_viewXCount , 0, 5, CGRectGetHeight(_headView.frame));
    _downView1.frame = CGRectMake(_viewX + _viewXCount , 0, 5, CGRectGetHeight(_headView.frame));
    _downView2.frame = CGRectMake(_viewX  * 2 + _viewXCount, 0, 5, CGRectGetHeight(_headView.frame));
    _downView3.frame = CGRectMake(_viewX * 3 + _viewXCount, 0, 5, CGRectGetHeight(_headView.frame));
    _downView4.frame = CGRectMake(_viewX * 4 + _viewXCount, 0, 5, CGRectGetHeight(_headView.frame));
    _downView5.frame = CGRectMake(_viewX * 5 + _viewXCount, 0, 5, CGRectGetHeight(_headView.frame));
    _downLabel.text = @"正在载入...";
    // 数据刷新完成
    if(!downFlag)
    {
        _downLabel.text = @"下拉刷新";
        downState = YES;
        [_downTimer invalidate];
        [_downView0 removeFromSuperview];
        [_downView1 removeFromSuperview];
        [_downView2 removeFromSuperview];
        [_downView3 removeFromSuperview];
        [_downView4 removeFromSuperview];
        [_downView5 removeFromSuperview];
        [self.tableView.tableHeaderView setHidden:YES];
        [_downView removeFromSuperview];
        _panGesture.enabled = YES;
        [self.tableView reloadData];
    }
}

// 	圆形头像点击事件回调
- (void)showCircularImageViewWithImage:(UIImage*) image
{
    self.tableView.scrollEnabled = NO;
//    UIView* addView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView* addView = [[UIView alloc] initWithFrame:self.parentViewController.parentViewController.view.bounds];
    addView.alpha = 1.0;
    addView.backgroundColor = [UIColor whiteColor];
    [self.parentViewController.parentViewController.view addSubview:addView];
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
//    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView *maskview = [[UIView alloc] initWithFrame:self.parentViewController.parentViewController.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.parentViewController.parentViewController.view addSubview:maskview];

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

// 帖子切换回调
- (void)reloadShowByTitle: (NSString* )text
{
    sectionCount = 1;
    topicFlag = YES;
    [self.neighborDataArray removeAllObjects];
    [self.tableView reloadData];
    
    _changeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(topicChange) userInfo:nil repeats:YES];
    [self.view addSubview:_waitImageView];

    
    if([text isEqualToString:@"全部"])
    {
        Tag = @"gettopic";
        category = 0;
        [self getTopicNet];

    }
    else if([text isEqualToString:@"话题"])
    {
        category = 1;
        Tag = @"singletopic";
        [self getTopicNet];

    }
    else if([text isEqualToString:@"活动"])
    {
        category = 2;
        Tag = @"singleactivity";
        [self getTopicNet];

    }
    else if([text isEqualToString:@"公告"])
    {
        category = 3;
        Tag = @"getnotice";
        [self getNoticeAndAdviceNet:@"3"];

    }
    else if([text isEqualToString:@"建议"])
    {
        category = 5;
        Tag = @"getsuggest";
        [self getNoticeAndAdviceNet:@"5"];
    }
    else if([text isEqualToString:@"闲品会"])
    {
        Tag = @"singlebarter";
        [self getTopicNet];

    }

    

}


- (void) topicChange
{
    if(!topicFlag)
    {
        [_changeTimer invalidate];
        [_waitImageView removeFromSuperview];
        [self.tableView reloadData];
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
    [self.parentViewController.parentViewController.view  addSubview:backgroundView];
    [self.parentViewController.parentViewController.view  addSubview:applyView];
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
    [self.parentViewController.parentViewController.view  addSubview:backgroundView];
    [self.parentViewController.parentViewController.view  addSubview:cancelView];
    
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
    NeighborDataFrame* neighborDataFrame = self.neighborDataArray[sectionNum - 1];
    NeighborData* neighborData = neighborDataFrame.neighborData;
    NSInteger topicId = [[neighborData valueForKey:@"topicId"] integerValue];
    NSInteger num = [neighborData.viewCount integerValue] + 1;
     neighborData.viewCount = [NSString stringWithFormat:@"%ld",num];
    
    [self viewTopicNet:topicId];
   
    
    
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Neighbour" bundle:nil];
    _detailController= [storyBoard instantiateViewControllerWithIdentifier:@"details"];
    UIBarButtonItem* detailItem = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.parentViewController.navigationItem setBackBarButtonItem:detailItem];
    _detailController.sectionNum = sectionNum - 1;
    _detailController.neighborData = neighborData;
    _detailController.neighborDF = neighborDataFrame;
    _detailController.neighborDA = self.neighborDataArray;
    [self.navigationController pushViewController:_detailController animated:YES];
    
}

// 打招呼回调
- (void)sayHi:(NSInteger)topicId
{
    NSLog(@"打招呼");
    DialogView* hiView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"sayHi"];
    hiView.sayHiTV.text = @"欢迎小宝宝来到本小区";
    [self.parentViewController.parentViewController.view  addSubview:backgroundView];
    [self.parentViewController.parentViewController.view  addSubview:hiView];
    
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
    DialogView* deleteView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"delete"];
    [self.parentViewController.parentViewController.view  addSubview:backgroundView];
    [self.parentViewController.parentViewController.view  addSubview:deleteView];

    dialogView = deleteView;
    UIButton* okBtn = deleteView.deleteYes;
    okBtn.tag = topicId;
    [okBtn addTarget:self action:@selector(deleteOkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelBtn = deleteView.deleteNo;
    [cancelBtn addTarget:self action:@selector(deleteNoAction:) forControlEvents:UIControlEventTouchUpInside];

}

// 发起获取帖子网络请求 全部 话题 活动
- (void) getTopicNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id0",userId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : @"0",
                                @"apitype" : @"comm",
                                @"tag" : Tag,
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    NSLog(@"parameter = %@",parameter);
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"获取所有帖子网络请求:%@", responseObject);
        for (int i = 0; i < [responseObject count]; i++,sectionCount++)
        {
            NSDictionary* responseDict = responseObject[i];
            if(i == 0)
            {
                newTopicId = responseDict[@"topicId"];
            }
            
            if(i == ([responseObject count] - 1))
            {
                oldTopicId = responseDict[@"topicId"];
            }
            
            NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
            
            
            NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];

            NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];

            neighborDataFrame.neighborData = neighborData;

            [self.neighborDataArray addObject:neighborDataFrame];

        }
        [_waitImageView removeFromSuperview];
        topicFlag = NO;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


// 发起获取帖子网络请求 公告 建议
- (void) getNoticeAndAdviceNet:(NSString*)type
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id0",userId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : @"0",
                                @"apitype" : @"apiproperty",
                                @"category_type" : type,
                                @"tag" : Tag,
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"获取所有帖子网络请求:%@", responseObject);
        for (int i = 0; i < [responseObject count]; i++,sectionCount++)
        {
            NSDictionary* responseDict = responseObject[i];
            if(i == 0)
            {
                newTopicId = responseDict[@"topicId"];
            }
            
            if(i == ([responseObject count] - 1))
            {
                oldTopicId = responseDict[@"topicId"];
            }
            
            NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
            
            
            NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
            
            NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
            
            neighborDataFrame.neighborData = neighborData;
            
            [self.neighborDataArray addObject:neighborDataFrame];
            
        }
        [_waitImageView removeFromSuperview];
        topicFlag = NO;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


// 下拉刷新网络请求 全部 话题 活动
- (void) downRefreshNet
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    if([self.neighborDataArray count] == 0)
    {
        newTopicId = @"-1";
    }
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%@",userId,communityId, newTopicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : newTopicId,
                                @"apitype" : @"comm",
                                @"tag" : Tag,
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"获取下拉所有帖子网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (NSInteger i = [responseObject count] - 1; i >=0 ; i--,sectionCount++)
            {
                NSDictionary* responseDict = responseObject[i];
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                
                if(i == [responseObject count] - 1)
                {
                    newTopicId = responseDict[@"topic_id"];
                }
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                
                NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
                
                neighborDataFrame.neighborData = neighborData;
                [self.neighborDataArray insertObject:neighborDataFrame atIndex: 0];
            }
        }
        else if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString* flag = [responseObject valueForKey:@"flag"];
            //            NSLog(@"下拉 flag = %@",flag);
        }
        downFlag = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        downFlag = NO;
        return;
    }];

}

// 下拉刷新网络请求 公告 建议
- (void) downRefreshNoticeAndAdviceNet:(NSString*) type
{
    NSLog(@"down type = %@", type);
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    if([self.neighborDataArray count] == 0)
    {
        newTopicId = @"-1";
    }
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%@",userId,communityId, newTopicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : newTopicId,
                                @"apitype" : @"apiproperty",
                                @"category_type" : type,
                                @"tag" : Tag,
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"获取下拉所有帖子网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (NSInteger i = [responseObject count] - 1; i >=0 ; i--,sectionCount++)
            {
                NSDictionary* responseDict = responseObject[i];
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                
                if(i == [responseObject count] - 1)
                {
                    newTopicId = responseDict[@"topic_id"];
                }
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                
                NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
                
                neighborDataFrame.neighborData = neighborData;
                [self.neighborDataArray insertObject:neighborDataFrame atIndex: 0];
            }
        }
        else if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString* flag = [responseObject valueForKey:@"flag"];
            //            NSLog(@"下拉 flag = %@",flag);
        }
        downFlag = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        downFlag = NO;
        return;
    }];
    
}



// 上拉刷新网络请求 全部 话题 活动
- (void) upRefreshNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%@count6",userId,communityId, oldTopicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : oldTopicId,
                                @"count" : @"6",
                                @"apitype" : @"comm",
                                @"tag" : Tag,
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:count:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"获取下拉所有帖子网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++,sectionCount++)
            {
                NSDictionary* responseDict = responseObject[i];
                if(i == ([responseObject count] - 1))
                {
                    oldTopicId = responseDict[@"topicId"];
                }
                
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                
                NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
                
                neighborDataFrame.neighborData = neighborData;
                
                [self.neighborDataArray addObject:neighborDataFrame];
                
            }
            
        }
        else if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString* flag = [responseObject valueForKey:@"flag"];
            NSLog(@"上拉 flag = %@",flag);
        }
        upFlag = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        upFlag = NO;
        return;
    }];

}


// 上拉刷新网络请求 公告 建议
- (void) upRefreshNoticeAndAdviceNet:(NSString*) type
{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%@count6",userId,communityId, oldTopicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : oldTopicId,
                                @"count" : @"6",
                                @"apitype" : @"apiproperty",
                                @"category_type" : type,
                                @"tag" : Tag,
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:count:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"获取下拉所有帖子网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++,sectionCount++)
            {
                NSDictionary* responseDict = responseObject[i];
                if(i == ([responseObject count] - 1))
                {
                    oldTopicId = responseDict[@"topicId"];
                }
                
                NSDictionary* dict = [self getResponseDictionary:responseObject[i]];
                
                NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
                
                NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
                
                neighborDataFrame.neighborData = neighborData;
                
                [self.neighborDataArray addObject:neighborDataFrame];
                
            }
            
        }
        else if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString* flag = [responseObject valueForKey:@"flag"];
            NSLog(@"上拉 flag = %@",flag);
        }
        upFlag = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        upFlag = NO;
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

    if([responseDict[@"topicTitle"] isEqualToString:@"刚刚好"])
    {
//        NSArray* array =
        NSLog(@"walk topicId = %@",responseDict[@"topicId"]);
    }
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
                    sectionCount = sectionCount - 1;
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


@end
