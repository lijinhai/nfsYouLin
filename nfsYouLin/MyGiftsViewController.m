//
//  MyGiftsViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//
#define SCREEN_WIDTH   ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)
#import "MyGiftsViewController.h"
#import "ExchangingGiftsViewController.h"
#import "ExchangedGiftsViewController.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "SqliteOperation.h"
#import "HeaderFile.h"

@interface MyGiftsViewController (){
    UISegmentedControl *segment;
    UIScrollView *_scrollView;
    UILabel *line1;
    UILabel *line2;
    
}


@end

@implementation MyGiftsViewController{

    ExchangingGiftsViewController *exchangingGiftView;
    ExchangedGiftsViewController *exchangedGiftView;
    UIActivityIndicatorView* _indicator;
    UIColor *_viewColor;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"";
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 20, screenHeight / 2, 40, 40)];
    [self.view addSubview:_indicator];
    _indicator.hidesWhenStopped = YES;
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    _indicator.color = [UIColor redColor];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    
}
-(void)viewWillAppear:(BOOL)animated{

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setSegmentedControl];
    [self build];
    
    

}

-(void)build
{
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.frame = CGRectMake(0,55,SCREEN_WIDTH,SCREEN_HEIGHT-70);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2,SCREEN_HEIGHT-70);
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    exchangingGiftView = [[ExchangingGiftsViewController alloc]init];
    exchangingGiftView.view.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-70);
    _downingRectLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-rectStatus.size.height-rectNav.size.height-70, SCREEN_WIDTH, 15)];
    _downingRectLabel.tag=101;
    _downingRectLabel.backgroundColor=_viewColor;
    [exchangingGiftView.view addSubview:_downingRectLabel];
    
    [self addChildViewController:exchangingGiftView];
    [_scrollView addSubview:exchangingGiftView.view];
    
    
    
    exchangedGiftView = [[ExchangedGiftsViewController alloc]init];
    CGRect aframe = CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT-70);
    
    exchangedGiftView.view.frame =aframe;
    _downedRectLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-rectStatus.size.height-rectNav.size.height-70, SCREEN_WIDTH, 15)];
    _downedRectLabel.backgroundColor=_viewColor;
    _downedRectLabel.tag=102;
    [exchangedGiftView.view addSubview:_downedRectLabel];
    [self addChildViewController:exchangedGiftView];
    [_scrollView addSubview:exchangedGiftView.view];
    
}

-(void)setSegmentedControl{
    
    if (!segment) {
        
        segment = [[UISegmentedControl alloc]initWithItems:nil];
        segment.frame=CGRectMake(0, 0, SCREEN_WIDTH, 40);
        [segment insertSegmentWithTitle:
         @"进行中" atIndex: 0 animated: NO ];
        [segment insertSegmentWithTitle:
         @"已兑换" atIndex: 1 animated: NO ];
        // 去掉颜色,现在整个segment偶看不到,可以相应点击事件
        segment.tintColor = [UIColor clearColor];
        
        // 正常状态下
        NSDictionary * normalTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName : [UIColor grayColor]};
        [segment setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
        
        // 选中状态下
        NSDictionary * selctedTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName : [UIColor redColor]};
        [segment setTitleTextAttributes:selctedTextAttributes forState:UIControlStateSelected];
         segment.backgroundColor=[UIColor whiteColor];
         segment.selectedSegmentIndex = 0;//设置默认选择项索引
        //设置跳转的方法
        [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
         UILabel *grayRectLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 15)];
         grayRectLabel.backgroundColor=_viewColor;
        
        
        
         line1=[[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/2, 3)];
         line1.backgroundColor=[UIColor redColor];
         line2=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,40, SCREEN_WIDTH/2, 3)];
         line2.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:line1];
        [self.view addSubview:line2];
        [self.view addSubview:grayRectLabel];
        [self.view addSubview:segment];
        
    }
    
}

-(void)change:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
            
        case 0:{
            line1.backgroundColor=[UIColor redColor];
            line2.backgroundColor=[UIColor whiteColor];
            [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * Seg.selectedSegmentIndex, 0) animated:YES];
            break;
        }
        case 1:{
            line2.backgroundColor=[UIColor redColor];
            line1.backgroundColor=[UIColor whiteColor];
            [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * Seg.selectedSegmentIndex, 0) animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
