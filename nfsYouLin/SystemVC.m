//
//  SystemVC.m
//  nfsYouLin
//
//  Created by Macx on 2016/11/1.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "SystemVC.h"
#import "HeaderFile.h"

@interface SystemVC ()

@end

@implementation SystemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel* dateL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, CGRectGetWidth(self.view.frame), 20)];
    dateL.text = self.dateStr;
    dateL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dateL];
    
    
    UIView* messageView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(dateL.frame) + 10, CGRectGetWidth(self.view.frame) - 30, 50)];
    messageView.backgroundColor = BackgroundColor;
    messageView.layer.cornerRadius = 5;
    [self.view addSubview:messageView];
    
    UILabel* messageL = [[UILabel alloc] initWithFrame:messageView.bounds];
    messageL.numberOfLines = 0;
    messageL.enabled = NO;
    messageL.text = self.message;
    messageL.textAlignment = NSTextAlignmentCenter;
    [messageView addSubview:messageL];
    
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
