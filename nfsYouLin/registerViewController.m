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
#import <SMS_SDK/SMSSDK.h>
#import "StringMD5.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"
#import "StringMD5.h"

@interface registerViewController()

@end

@implementation registerViewController
{
 
    aboutTermsViewController*  aboutTermsController;
    inputRegisterInfoViewController* inputRegisterInfoController;
    
    
    NSTimer* _timer;
    NSInteger _secTime;
    UILabel* timeLabel;
    UILabel* titleLabel;
    
    redrawTextField *phoneLineField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    aboutTermsController = [storyBoard instantiateViewControllerWithIdentifier:@"aboutController"];

    inputRegisterInfoController = [storyBoard instantiateViewControllerWithIdentifier:@"registerInfoController"];

    
    _isClick=YES;

    
    // 添加电话号码输入框
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.phoneTextField.frame = CGRectMake(3, -1, 200, 49);
    self.phoneTextField.backgroundColor = [UIColor whiteColor];
    self.phoneTextField.placeholder=@"请输入手机号";
    self.phoneTextField.leftView = paddingView0;
    self.phoneTextField.leftViewMode=UITextFieldViewModeAlways;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField resignFirstResponder];
    //    [self.phoneTextField becomeFirstResponder];
    
    phoneLineField =[[redrawTextField alloc] init:CGRectMake(20, 81, 210, 50) addTextField:self.phoneTextField];
    
    
    // 添加验证码输入框
    self.verifyTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.verifyTextField.frame = CGRectMake(3, -1, 368, 49);
    self.verifyTextField.backgroundColor = [UIColor whiteColor];
    self.verifyTextField.placeholder = @"请输入验证码";
    self.verifyTextField.leftView = paddingView1;
    self.verifyTextField.leftViewMode = UITextFieldViewModeAlways;
    self.verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.verifyTextField addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    redrawTextField *codesTextfield=[[redrawTextField alloc] init:CGRectMake(20,169, 374, 51) addTextField:self.verifyTextField];
    // 添加邀请码
    self.inviteTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.inviteTextField.frame = CGRectMake(3, -1, 368, 49);
    self.inviteTextField.backgroundColor = [UIColor whiteColor];
    self.inviteTextField.placeholder=@"(选填)请输入邀请码或推荐人手机号";
    self.inviteTextField.leftView=paddingView2;
    self.inviteTextField.leftViewMode=UITextFieldViewModeAlways;
    self.inviteTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.inviteTextField addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    redrawTextField *inviteCodeTextfield=[[redrawTextField alloc] init:CGRectMake(20,248, 374, 51) addTextField:self.inviteTextField];
    
    [self.view addSubview:phoneLineField];
    [self.view addSubview:codesTextfield];
    [self.view addSubview:inviteCodeTextfield];
    [_youLinServiceButton setImage:[UIImage imageNamed:@"read_server.png"] forState:UIControlStateNormal];

    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, self.verifyBtn.frame.size.height)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.backgroundColor = [UIColor lightGrayColor];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.verifyBtn.frame.size.width - 22, self.verifyBtn.frame.size.height)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.text = @"秒后重新获取";
    
    _secTime = 60;
    
}



- (void)viewWillAppear:(BOOL)animated
{

    /*设置导航*/
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(selectNextAction:)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    self.navigationItem.title=@"";
    /*设置导航栏颜色*/
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1]];
    UIView * tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    tmpView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:tmpView];
    
    
    if(self.verifyBtn.enabled)
    {
        [self clearTextField];
    }
    
    [self setTextFieldEnabled:NO];
    
}



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setTextFieldEnabled:YES];

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


// 下一步
-(void)selectNextAction:(id)sender
{
    NSLog(@"下一步");
    
//       测试代码
    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"详细信息" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:inputRegisterInfoController animated:YES];
    return;
    
    
    NSLog(@"验证码 = %@",self.verifyTextField.text);
    [self.view endEditing:YES];
    NSString* phoneNum = self.phoneTextField.text;
    NSString* verifyCode = self.verifyTextField.text;
    NSString* inviteCode = self.inviteTextField.text;
    if(phoneNum.length == 0)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"手机号不能为空"];
        return;
    }

    NSString *phoneRegex = @"^1[3 | 4 | 5 | 7 | 8][0-9]\\d{8}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phonePredicate evaluateWithObject:phoneNum];
    if(!isValid)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"请输入正确的手机号"];
        return;
    }

    if(verifyCode.length == 0)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"验证码不能为空"];
        return;
    }
    
    if(verifyCode.length < 4)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"请输入四位验证码"];
        return;
    }
    
    // 发起验证码比对网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"phone%@iosioscode%@",phoneNum,verifyCode]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"phone" : phoneNum,
                                @"ios" : @"ios",
                                @"apitype" : @"users",
                                @"tag" : @"mobverify",
                                @"code" : verifyCode,
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"phone:ios:code:",
                            };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功:%@", responseObject);
        int flag = [[responseObject valueForKey:@"flag"] intValue];
        if(flag == 200)
        {
            NSLog(@"验证码比对正确，跳转页面");
            [self inviteNetwork:phoneNum inviteCode:inviteCode];
        }
        else
        {
            NSLog(@"flag = %d",flag);
            self.phoneTextField.text = @"";
            self.verifyTextField.text = @"";
            self.inviteTextField.text = @"";
            [MBProgressHUBTool textToast:self.view Tip:@"验证码错误,请正确填写"];
        }
        return;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
}

- (void) inviteNetwork:(NSString*)phoneNum inviteCode:(NSString *)inviteCode
{
    
        // 发起邀请码比对网络请求
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
 
        NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"inv_phone%@inv_code%@",phoneNum,inviteCode]];
        NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
        NSDictionary* parameter = @{@"inv_phone" : phoneNum,
                                    @"inv_code" : inviteCode,
                                    @"apitype" : @"users",
                                    @"tag" : @"checkinvstatus",
                                    @"salt" : @"1",
                                    @"hash" : hashString,
                                    @"keyset" : @"inv_phone:inv_code:",
                                };
    
        [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功:%@", responseObject);
            NSString* flag = [responseObject valueForKey:@"flag"];
            
            if([flag isEqualToString:@"ok"])
            {
                UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"详细信息" style:UIBarButtonItemStylePlain target:nil action:nil];
                [self.navigationItem setBackBarButtonItem:neighborItem];
                inputRegisterInfoController.inviteCode = [responseObject valueForKey:@"type"];
                inputRegisterInfoController.phoneNum = phoneNum;
                
                [self.navigationController pushViewController:inputRegisterInfoController animated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败:%@", error.description);
        }];

}



- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 获取验证码
- (IBAction)getVerificationCode:(id)sender {
    NSLog(@"获取验证码");

    [self.view endEditing:YES];
    NSString* phoneNum = self.phoneTextField.text;
    NSLog(@"phoneNum = %@",self.phoneTextField.text);
    
    if(phoneNum.length == 0)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"手机号不能为空"];
        return;
    }
    
    NSString *phoneRegex = @"^1[3 | 4 | 5 | 7 | 8][0-9]\\d{8}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phonePredicate evaluateWithObject:phoneNum];
    if(!isValid)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"请输入正确的手机号"];
        self.phoneTextField.text = @"";
        return;
    }
    
    // 发起验手机是否存在网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"phonenum%@",phoneNum]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1",MD5String]];
    
    NSDictionary* parameter = @{@"phonenum" : phoneNum,
                                @"apitype" : @"users",
                                @"tag" : @"check",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"phonenum:"
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        
        if([flag isEqualToString:@"exist"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"该手机已被注册"];
            self.phoneTextField.text = @"";
            return;
        }
        else
        {
            [sender setEnabled:NO];
            [self.phoneTextField setEnabled:NO];
            self.phoneTextField.textColor = [UIColor lightGrayColor];
            [phoneLineField lineConvertToGray];
            
            timeLabel.text = @"60";
            [self.verifyBtn addSubview:timeLabel];
            [self.verifyBtn addSubview:titleLabel];

            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getVerifyCode) userInfo:nil repeats:YES];
            
            //  获取短信验证码
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNum zone:@"86" customIdentifier:nil result:^(NSError *error)
             {
                 if (!error)
                 {
                     NSLog(@"获取验证码成功");
                     [self overTimer];

                 }
                 else
                 {
                     NSLog(@"错误信息：%@",error);
                     [MBProgressHUBTool textToast:self.view Tip:@"Mob服务器异常"];

                 }
             }];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}




- (void)TextFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneTextField || textField == self.inviteTextField)
    {
        if (textField.text.length > 11)
        {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    else if(textField == self.verifyTextField)
    {
        if(textField.text.length > 4)
        {
            textField.text = [textField.text substringToIndex:4];

        }
    }
}

- (void) getVerifyCode
{
    _secTime--;
    timeLabel.text = [NSString stringWithFormat:@"%ld",_secTime];
   
    if(_secTime == 10)
    {
        timeLabel.textAlignment = NSTextAlignmentCenter;
    }

    if(_secTime == 0)
    {
        [self overTimer];
        [self clearTextField];
    }
}

- (void) overTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
        _secTime = 60;
        [self.verifyBtn setEnabled:YES];
        [self.phoneTextField setEnabled:YES];
        self.phoneTextField.textColor = [UIColor blackColor];
        [phoneLineField lineConvertToBlack];

        timeLabel.textAlignment = NSTextAlignmentLeft;
        [timeLabel removeFromSuperview];
        [titleLabel removeFromSuperview];

    }
}

- (void) clearTextField
{
    self.phoneTextField.text = @"";
    self.verifyTextField.text = @"";
    self.inviteTextField.text = @"";
}

- (void) setTextFieldEnabled:(BOOL)flag
{
    if(!timeLabel.superview)
        [self.phoneTextField setEnabled:flag];
    
    [self.verifyTextField setEnabled:flag];
    [self.inviteTextField setEnabled:flag];
}

@end

