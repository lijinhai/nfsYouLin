//
//  fillVerifyCodeViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/6/23.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "fillVerifyCodeViewController.h"

@interface fillVerifyCodeViewController ()

@end

@implementation fillVerifyCodeViewController{

    UIColor *_viewColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=_viewColor;
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"";
    /*设置验证码输入框*/
    UIView *paddingView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    _writeValiyTextField.backgroundColor = [UIColor whiteColor];
    _tipInfoLabel.font=[UIFont systemFontOfSize:16];
    _writeValiyTextField.placeholder=@"输入您获取的验证码";
    _writeValiyTextField.leftView=paddingView0;
    _writeValiyTextField.leftViewMode=UITextFieldViewModeAlways;
    _writeValiyTextField.layer.cornerRadius =5.0;
    [_writeValiyTextField becomeFirstResponder];
    /*设置提示信息*/
    _tipInfoLabel.text=@"此验证码是优邻活动中获取的验证码卡片，可以加速认\n证您的地址信息，保障您的及时使用";
    _tipInfoLabel.font=[UIFont systemFontOfSize:14];
    _tipInfoLabel.textColor=[UIColor lightGrayColor];
    _tipInfoLabel.numberOfLines=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valiyAction:(id)sender {
}
@end
