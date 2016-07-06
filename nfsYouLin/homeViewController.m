//
//  homeViewController.m
//  nfsYouLin
//
//  Created by Macx on 16/5/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "homeViewController.h"
#import "forgetViewController.h"
#import "registerViewController.h"
#import "FirstTabBarController.h"

@interface homeViewController ()

@end

@implementation homeViewController
{
    forgetViewController* _forgetController;
    registerViewController* _registerController;
    FirstTabBarController* _FirstTabBarController;
    UINavigationController *newNavigationController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*设置textField clear button 图片*/
    UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView* xImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_x.png"]];
    xImageView.frame = CGRectMake(10, 0,14,14);
    [rightVeiw addSubview:xImageView];
    self.phoneTextField.rightView = rightVeiw;
    self.phoneTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField addTarget:self action:@selector(phoneTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTextField.delegate = self;
    self.passwordTextField.rightView = rightVeiw;
    self.passwordTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    /*xImageView 添加点击事件*/
    xImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *xImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xImageViewClick:)];
    [xImageView addGestureRecognizer:xImageViewTap];
    
    
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _forgetController = [storyBoard instantiateViewControllerWithIdentifier:@"forgetController"];
    _registerController = [storyBoard instantiateViewControllerWithIdentifier:@"registerController"];
//    _registerController = [[registerViewController alloc] init];
    _FirstTabBarController = [storyBoard instantiateViewControllerWithIdentifier:@"homeTabView"];
    newNavigationController = [storyBoard instantiateViewControllerWithIdentifier:@"viewID"];

}


- (void)viewWillAppear:(BOOL)animated
{
    /*隐藏首页导航条*/
    self.navigationController.navigationBarHidden = YES;
    
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    /*状态栏背景*/
    UIView * tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    tmpView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tmpView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)xImageViewClick:(UITextField*) textField
{
    if(self.phoneTextField.editing)
    {
        [self.phoneTextField setText:@""];
    }
    else if (self.passwordTextField.editing)
    {
        [self.passwordTextField setText:@""];
    }
}

- (void)phoneTextFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

// UITextFieldDelegate 限制输入框只能输入数字
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
}


- (IBAction)forgetAction:(UIButton *)sender {

    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"忘记密码" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:_forgetController animated:YES];
}

- (IBAction)registerAction:(UIButton *)sender {
    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"快速注册" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:_registerController animated:YES];
}

- (IBAction)loginAction:(id)sender {
    
   [self presentViewController:newNavigationController animated:YES completion:nil];

}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
