//
//  NeighborTableViewController.m
//  Neighbor2
//
//  Created by Macx on 16/5/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "NTableViewController.h"
#import "NDetailTableViewController.h"


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

    NSInteger _count;
    
    UIActivityIndicatorView *_indicatorView;
    UIColor* _color;
    
    NDetailTableViewController* _detailController;

}

static int sectionCount = 6;

- (void)viewWillAppear:(BOOL)animated
{
    
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
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIView * tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    tmpView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:tmpView];
    
    self.tableView.bounces = NO;
    _neighborDataArray = [[NSMutableArray alloc] init];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
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
            cell.neighborDataFrame = self.neighborDataArray[indexPath.section];
            
        }
        // 评论 赞 查看
        else if(indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellAnother];
            if(cell == nil)
            {
                cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellAnother];
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
    if((indexPath.section != 0 && indexPath.row == 1) || indexPath.section == 0)
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
    NSLog(@"scrollViewShouldScrollToTop");
    return YES;
}

// 滑动到顶部时调用该方法
//滑动到下方内容 点击系统顶部导航 自动定位到顶部时触发
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScrollToTop");
}

// 处理单元格的选中
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self readTotalInformation:indexPath.section];
}


//拖动后开始滑行
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDecelerating");
}


 //拖动后滑行结束
// 滚动停止时，触发该函数
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");

}

//开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging 开始拖拽 y=%f",self.tableView.contentOffset.y);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation");
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
        NSLog(@"began contentOffsetY = %f",contentOffsetY);
        // 顶部下拉条件
        if(translation.y > 0 && self.tableView.contentOffset.y == contentOffsetY && downState)
        {
            NSLog(@"began 下拉");
            downState = NO;
//            [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
            [self.navigationController.navigationBar addSubview:_downView];
        }
        // 底部上拉条件
        else if(translation.y < 0 && (self.tableView.contentSize.height == self.tableView.contentOffset.y + self.tableView.frame.size.height))
        {
            NSLog(@"底部上拉条件");
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
                _count = 0;
//                refreshState = NO;
                gesture.enabled = NO;
                _downTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(refreshDownData) userInfo:nil repeats:YES];
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
            }
        }
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"end");
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
    NSLog(@"refreshUpData 正在执行第%ld次任务",_count++);
    
    // 数据刷新完成
    if(_count == 500)
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
    sectionCount += 3;
    upState = YES;
    _count = 0;
    [_finishLabel removeFromSuperview];
//    [self.tableView.tableFooterView setHidden:YES];
    _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44);
    self.tableView.tableFooterView = _footerView;
    [self.tableView reloadData];

}

// 下拉刷新数据

- (void) refreshDownData
{
    NSLog(@"refreshDownData 正在执行第%ld次任务",_count++);
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
    if(_count == 500)
    {
        
        _downLabel.text = @"下拉刷新";
        _count = 0;
        downState = YES;
//        [self.navigationController.navigationBar setBarTintColor:_color];
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
        sectionCount += 1;
        [self.tableView reloadData];
    }
}

// 帖子表格数据来源
- (NSMutableArray *)neighborDataArray
{
  
    [_neighborDataArray removeAllObjects];
    
    NSDate* date = [NSDate  date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString* timeString = [dateFormatter stringFromDate:date];
    
    for(int i = 0; i < sectionCount; i ++)
    {
        NSDictionary* dict;
        if(i == 1)
        {
            dict = @{@"titleCategory" : @"话题",
                     @"iconName" : @"default_normal_avatar",
                     @"titleName" : [NSString stringWithFormat:@"跳跳-%d",i],
                     @"accountName" : @"动物园",
                     @"addressInfo" : @"保利清华园",
                     @"publishTime" : @"1小时前",
                     @"dateTime"    : timeString,
                     @"publishText" : @"在欧洲，古罗马时已有动物园的雏型。最初的动物园雏形起源于是古代国王、皇帝和王公贵族们的一种嗜好，从各地收集来的珍禽异兽圈在皇宫里供其玩赏，像黄金、珠宝一样，是他们这些人财富和地位的象征，当时的动物园和普通百姓一点关系都没有。一开始，这种收集行为比较随意，碰上什么就抓什么，后来渐渐地对动物有了一些了解，才开始有一些计划性和组织性。不过那时的动物都关在笼子里，并不考虑它们舒不舒服，只考虑如何让参观者看得更清楚一些。公元前2300年前的一块石匾上就有对当时在美索不达米亚南部苏美尔的重要城市乌尔收集珍稀动物的描述，这可能是人类有记载的最早动物采集行为。",
                     @"picturesArray" : @[@"dog.png",
                                          @"duck.png",
                                          @"elephant.png",
                                          @"frog.png",
                                          @"mouse.png",
                                          @"rabbit.png",
                                          @"elephant.png",
                                          @"dog.png",
                                          @"duck.png"],
                     };

        }
        else if(i == 2)
        {
            dict = @{@"titleCategory" : @"话题",
                     @"iconName" : @"default_normal_avatar",
                     @"titleName" : [NSString stringWithFormat:@"跳跳-%d",i],
                     @"accountName" : @"walk",
                     @"addressInfo" : @"保利清华园",
                     @"publishTime" : @"1小时前",
                     @"dateTime"    : timeString,
                     @"publishText" : @"我家的宠物",
                     @"picturesArray" : @[@"dog.png",
                                          @"elephant.png",
                                         ],
                     };

        }
        else if (i == 3)
        {
            dict = @{@"titleCategory" : @"话题",
                     @"iconName" : @"default_normal_avatar",
                     @"titleName" : [NSString stringWithFormat:@"跳跳-%d",i],
                     @"accountName" : @"金海",
                     @"addressInfo" : @"保利清华园",
                     @"publishTime" : @"1小时前",
                     @"dateTime"    : timeString,
                     @"publishText" : @"今天又买了好几个宠物 哈哈 就是有钱！！",
                     @"picturesArray" : @[@"dog.png",
                                          @"duck.png",
                                          @"elephant.png",
                                          @"frog.png",
                                          @"mouse.png",
                                         ],
                     };

        }
        else if(i == 4)
        {
            dict = @{@"titleCategory" : @"话题",
                     @"iconName" : @"default_normal_avatar",
                     @"titleName" : [NSString stringWithFormat:@"跳跳-%d",i],
                     @"accountName" : @"大神",
                     @"addressInfo" : @"保利清华园",
                     @"publishTime" : @"1小时前",
                     @"dateTime"    : timeString,
                     @"publishText" : @"来来 组队打刀塔",
                     @"picturesArray" : @[@"dog.png",
                                          @"duck.png",
                                          @"elephant.png",
                                          @"frog.png",
                                          @"mouse.png",
                                          @"rabbit.png",
                                          @"elephant.png",
                                          ],
                     };

        }
        else
        {
            dict = @{@"titleCategory" : @"话题",
                     @"iconName" : @"default_normal_avatar",
                     @"titleName" : [NSString stringWithFormat:@"跳跳-%d",i],
                     @"accountName" : @"动物世界",
                     @"addressInfo" : @"保利清华园",
                     @"publishTime" : @"1小时前",
                     @"dateTime"    : timeString,
                     @"publishText" : @"欢迎 欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎",
                     @"picturesArray" : @[@"dog.png",
                                          @"duck.png",
                                          @"elephant.png",
                                          @"frog.png",
                                          @"mouse.png",
                                          @"rabbit.png",
                                          @"elephant.png",
                                          @"dog.png",
                                          @"duck.png"],
                     };

        }
        NeighborData *neighborData = [[NeighborData alloc] initWithDict:dict];
        NeighborDataFrame *neighborDataFrame = [[NeighborDataFrame alloc]init];
        neighborDataFrame.neighborData = neighborData;
        [_neighborDataArray addObject:neighborDataFrame];

    }
    return _neighborDataArray;
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

// 查看全文回调事件
- (void)readTotalInformation:(NSInteger)sectionNum
{
    NeighborDataFrame* neighborDataFrame = _neighborDataArray[sectionNum];
    NeighborData* neighborData = neighborDataFrame.neighborData;
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Neighbour" bundle:nil];
    _detailController= [storyBoard instantiateViewControllerWithIdentifier:@"details"];
    UIBarButtonItem* detailItem = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.parentViewController.navigationItem setBackBarButtonItem:detailItem];
    _detailController.sectionNum = sectionNum;
    _detailController.neighborData = neighborData;
    [self.navigationController pushViewController:_detailController animated:YES];
    
}

@end
