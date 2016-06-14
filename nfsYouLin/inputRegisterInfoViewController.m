//
//  inputRegisterInfoViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/17.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "inputRegisterInfoViewController.h"
#import "chooseCityViewController.h"
#import "redrawTextField.h"

@interface inputRegisterInfoViewController ()

@end

@implementation inputRegisterInfoViewController{
 
    chooseCityViewController * cityController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"";
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //UIBarButtonItem *barleftBtn=[[UIBarButtonItem alloc]initWithTitle:@"详细信息" style:UIBarButtonItemStylePlain target:self action:nil];
    //self.navigationItem.leftBarButtonItem=barleftBtn;
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(selectCompleteAction)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    self.navigationItem.title=@"";
    /*xImageView 添加点击事件*/
    _selectBoyRadio.userInteractionEnabled = YES;
    _selectBoyRadio.tag=1;
    UITapGestureRecognizer *xImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRadioClick:)];
    [_selectBoyRadio addGestureRecognizer:xImageViewTap];
    
    _selectGirlRadio.userInteractionEnabled = YES;
    _selectGirlRadio.tag=2;
   UITapGestureRecognizer *xImageViewTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRadioClick:)];
    [_selectGirlRadio addGestureRecognizer:xImageViewTap2];
    /*添加重绘的文本框*/
    /*添加昵称输入框*/
    UITextField *inputNickNameField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    inputNickNameField.frame = CGRectMake(3, -1, 240, 49);
    inputNickNameField.backgroundColor = [UIColor whiteColor];
    inputNickNameField.placeholder=@"请输入昵称（2~10个字）";
    inputNickNameField.leftView=paddingView0;
    inputNickNameField.leftViewMode=UITextFieldViewModeAlways;
    [inputNickNameField becomeFirstResponder];
    redrawTextField *nickNameTextfield=[[redrawTextField alloc] init:CGRectMake(20, 174, 374, 51) addTextField:inputNickNameField];
    /*添加设置密码输入框*/
    UITextField *inputPasswordField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    inputPasswordField.frame = CGRectMake(3, -1, 368, 49);
    inputPasswordField.backgroundColor = [UIColor whiteColor];
    inputPasswordField.placeholder=@"请输入密码（6-16个字符）";
    inputPasswordField.leftView=paddingView1;
    inputPasswordField.leftViewMode=UITextFieldViewModeAlways;
    redrawTextField *passwordTextfield=[[redrawTextField alloc] init:CGRectMake(20,228, 374, 51) addTextField:inputPasswordField];
    /*添加确认密码输入框*/
    UITextField *inputConfirmPasswordInfoField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    inputConfirmPasswordInfoField.frame = CGRectMake(3, -1, 368, 49);
    inputConfirmPasswordInfoField.backgroundColor = [UIColor whiteColor];
    inputConfirmPasswordInfoField.placeholder=@"请确认密码（6-16个字符）";
    inputConfirmPasswordInfoField.leftView=paddingView2;
    inputConfirmPasswordInfoField.leftViewMode=UITextFieldViewModeAlways;
    
    redrawTextField *confirmPasswordTextfield=[[redrawTextField alloc] init:CGRectMake(20,287, 374, 51) addTextField:inputConfirmPasswordInfoField];
    
    [self.view addSubview:nickNameTextfield];
    [self.view addSubview:passwordTextfield];
    [self.view addSubview:confirmPasswordTextfield];
    /*跳转至选择城市界面*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    cityController = [storyBoard instantiateViewControllerWithIdentifier:@"cityController"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectCompleteAction{

    /*添加相关逻辑判断*/
    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"请选择城市" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:cityController animated:YES];
}

-(void)selectRadioClick:(UITapGestureRecognizer*)sender{
    UIImage *image1= [UIImage imageNamed:@"checked_sex"];
    UIImage *image2= [UIImage imageNamed:@"uncheck_sex"];
    NSLog(@"%ld", sender.view.tag);
    if(sender.view.tag==1)
    {
        _selectBoyRadio.image = image1;
        _selectGirlRadio.image =image2;
    }else{
        _selectBoyRadio.image = image2;
        _selectGirlRadio.image =image1;
    
    }
}

@end
