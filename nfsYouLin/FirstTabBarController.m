//
//  FirstTabBarController.m
//  nfsYouLin
//
//  Created by Macx on 16/6/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FirstTabBarController.h"

@implementation FirstTabBarController


- (void) viewDidLoad
{
    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statusView];

}
@end
