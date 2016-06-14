//
//  registerViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "registerViewController.h"
#import "redrawTextField.h"
#import "aboutTermsViewController.h"
#import "inputRegisterInfoViewController.h"
@interface registerViewController()

@end

@implementation registerViewController{
 
aboutTermsViewController*  aboutTermsController;
    inputRegisterInfoViewController* inputRegisterInfoController;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    aboutTermsController = [storyBoard instantiateViewControllerWithIdentifier:@"aboutController"];
    inputRegisterInfoController=[storyBoard instantiateViewControllerWithIdentifier:@"registerInfoController"];

}

- (void)viewWillAppear:(BOOL)animated
{
    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(selectNextAction:)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    self.navigationItem.title=@"";
    /*设置导航栏颜色*/
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1]];
    UIView * tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    tmpView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:tmpView];

    /*添加电话号码输入框*/
    UITextField *inputPhoneInfoField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    inputPhoneInfoField.frame = CGRectMake(3, -1, 240, 49);
    inputPhoneInfoField.backgroundColor = [UIColor whiteColor];
    inputPhoneInfoField.placeholder=@"请输入手机号";
    inputPhoneInfoField.leftView=paddingView0;
    inputPhoneInfoField.leftViewMode=UITextFieldViewModeAlways;
    [inputPhoneInfoField becomeFirstResponder];
    redrawTextField *phoneTextfield=[[redrawTextField alloc] init:CGRectMake(20, 81, 246, 50) addTextField:inputPhoneInfoField];
    //[inputPhoneInfoField resignFirstResponder];
    //NSLog(@"执行我");
    /*添加验证码输入框*/
    UITextField *inputCodesInfoField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    inputCodesInfoField.frame = CGRectMake(3, -1, 368, 49);
    inputCodesInfoField.backgroundColor = [UIColor whiteColor];
    inputCodesInfoField.placeholder=@"请输入验证码";
    inputCodesInfoField.leftView=paddingView1;
    inputCodesInfoField.leftViewMode=UITextFieldViewModeAlways;
    redrawTextField *codesTextfield=[[redrawTextField alloc] init:CGRectMake(20,169, 374, 51) addTextField:inputCodesInfoField];
    /*添加邀请码*/
    UITextField *inputInviteCodeInfoField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    inputInviteCodeInfoField.frame = CGRectMake(3, -1, 368, 49);
    inputInviteCodeInfoField.backgroundColor = [UIColor whiteColor];
    inputInviteCodeInfoField.placeholder=@"(选填)请输入邀请码或推荐人手机号";
    inputInviteCodeInfoField.leftView=paddingView2;
    inputInviteCodeInfoField.leftViewMode=UITextFieldViewModeAlways;

    redrawTextField *inviteCodeTextfield=[[redrawTextField alloc] init:CGRectMake(20,248, 374, 51) addTextField:inputInviteCodeInfoField];
    
    [self.view addSubview:phoneTextfield];
    [self.view addSubview:codesTextfield];
    [self.view addSubview:inviteCodeTextfield];
    [_youLinServiceButton setImage:[UIImage imageNamed:@"read_server.png"] forState:UIControlStateNormal];
    _isClick=YES;
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)aboutTermsAction:(id)sender {
    
     /*设置选中优邻服务协议*/
    [_youLinServiceButton setImage:[UIImage imageNamed:@"read_server.png"] forState:UIControlStateNormal];
    _isClick=YES;
    /*跳转至关于优邻服务协议*/
    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"关于优邻服务协议" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:aboutTermsController animated:YES];
}

- (IBAction)selectYouLinService:(id)sender {
    if(_isClick)
    {
      [_youLinServiceButton setImage:[UIImage imageNamed:@"read_server_hui.png"] forState:UIControlStateNormal];
        _isClick=NO;
    }else{
        [_youLinServiceButton setImage:[UIImage imageNamed:@"read_server.png"] forState:UIControlStateNormal];
        _isClick=YES;
    }
    
}

-(void)selectNextAction:(id)sender
{
    /*检查验证码及邀请码及手机号是否正确*/
    /*if{
     
     }else{
     
     }
     */
    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"详细信息" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:inputRegisterInfoController animated:YES];
    
}
@end

