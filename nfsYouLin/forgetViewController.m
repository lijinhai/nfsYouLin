//
//  forgetViewController.m
//  nfsYouLin
//
//  Created by Macx on 16/5/10.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "forgetViewController.h"
#import "MBProgressHUD.h"

@interface forgetViewController ()

@end

@implementation forgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    /*显示导航条*/
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textToast:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view    animated:YES];
    
    // Set the annular determinate mode to show task progress.navigationController.view
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor=[UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.minSize=CGSizeMake(50, 50);
    hud.label.text = NSLocalizedString(tips, @"HUD message title");
    
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font= [UIFont systemFontOfSize:15];
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:3.f];
}

-(void)selectRightAction
{
    //[self  dismissViewControllerAnimated:YES  completion:nil];
    /*需补充判断手机号是否正确，密码设置是否一致等*/
    if ([_inputPhoneNumber.text isEqualToString:@""]) {
       [self textToast:@"手机号不能为空"];
    }else
    {
     [self.navigationController popViewControllerAnimated:YES];
    }
    
    /*if else */
    //[self.navigationController popViewControllerAnimated:YES];
}

@end
