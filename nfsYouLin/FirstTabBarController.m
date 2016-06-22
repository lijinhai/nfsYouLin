//
//  FirstTabBarController.m
//  nfsYouLin
//
//  Created by Macx on 16/6/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FirstTabBarController.h"
#import "NewTopicViewController.h"
#import "BackgroundView.h"
#import "ListTableView.h"

@implementation FirstTabBarController
{
    ListTableView* _listTableView;
    BackgroundView* _backGroundView;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidLoad
{
//    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
//    statusView.backgroundColor = [UIColor blackColor];
//    [self.navigationController.navigationBar addSubview:statusView];
    

    UINavigationController* navigationController = self.navigationController;
    _listTableView = [[ListTableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 150, CGRectGetMaxY(self.navigationController.navigationBar.frame), 150, 200)];
    
    _backGroundView = [[BackgroundView alloc] initWithFrame:self.parentViewController.view.frame view:_listTableView];
    BackgroundView* backGroundView = _backGroundView;
    NSArray* nameArray = @[@"新建话题", @"发起活动", @"闲品会", @"邀请"];
    NSArray* imageArray = @[@"huati", @"huodong", @"change", @"nav_yaoqinghaoyou"];
    
    [_listTableView setListTableView:nameArray image:imageArray block:^(NSString* string){
        NSLog(@"string = %@",string);
        [backGroundView removeFromSuperview];
        if([string isEqualToString:@"新建话题"])
        {
            NSLog(@"开始新建话题~~");
            NewTopicViewController* newTopicViewController = [[NewTopicViewController alloc] initWithTitle:string];
            [navigationController pushViewController:newTopicViewController animated:YES];
        }
        
    }];
    
    
       // 去掉tableview 顶部空白区域
//    self.automaticallyAdjustsScrollViewInsets = false;
    
}

- (IBAction)addBar:(id)sender {
    NSLog(@"addBar");
    [self.parentViewController.view addSubview:_backGroundView];
    [self.parentViewController.view addSubview:_listTableView];
}


- (IBAction)noticeBar:(id)sender {
    NSLog(@"notice");

}


@end
