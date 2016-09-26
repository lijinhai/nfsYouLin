//
//  lookScheduleVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "lookScheduleVC.h"
#import "HeaderFile.h"
@interface lookScheduleVC ()

@end

@implementation lookScheduleVC{

    UIView* bgView;



}

- (void)viewDidLoad {
    [super viewDidLoad];
    bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    bgView.backgroundColor=BackgroundColor;
    UIView* rectView=[[UIView alloc] initWithFrame:CGRectMake(0,65, screenWidth, 120)];
    rectView.backgroundColor=[UIColor whiteColor];
    
    UIImageView* lineIV=[[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 1, 120)];
    lineIV.image=[UIImage imageNamed:@"tab_bg"];
    UIImageView* hongIV=[[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 10, 10)];
    hongIV.image=[UIImage imageNamed:@"hongdian"];
    UILabel* tipLab=[[UILabel alloc] initWithFrame:CGRectMake(40, 30, 250, 20)];
    tipLab.text=@"报修内容已提交，请耐心等待...";
    [rectView addSubview:tipLab];
    [rectView addSubview:lineIV];
    [rectView addSubview:hongIV];
    [bgView addSubview:rectView];
    [self.view addSubview:bgView];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
