//
//  forgetViewController.m
//  nfsYouLin
//
//  Created by Macx on 16/5/10.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "forgetViewController.h"
#import "MBProgressHUBTool.h"
#import "HeaderFile.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import <SMS_SDK/SMSSDK.h>
#import "WaitView.h"

@interface forgetViewController ()

@end

@implementation forgetViewController
{
    NSTimer* _timer;
    NSInteger _secTime;
    UILabel* timeLabel;
    UILabel* titleLabel;
    
    NSInteger userId;
    UIView* backgroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction)];
    self.navigationItem.rightBarButtonItem = barrightBtn;
    
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneNumTF addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.verifyCodeTF addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.passwordTF.returnKeyType = UIReturnKeyNext;
    self.passwordTF.delegate = self;
    [self.passwordTF addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.againPWDTF.returnKeyType = UIReturnKeyGo;
    self.againPWDTF.delegate = self;
    [self.againPWDTF addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, self.verifyBtn.frame.size.height)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.backgroundColor = [UIColor lightGrayColor];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.verifyBtn.frame.size.width - 22, self.verifyBtn.frame.size.height)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.text = @"秒后重新获取";
    
    backgroundView = [[UIView alloc] initWithFrame:self.parentViewController.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    WaitView* waitView = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"正在重置..."];
    [backgroundView addSubview:waitView];
    _secTime = 60;
    userId = 0;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 显示导航条
    self.navigationController.navigationBarHidden = NO;
    [self setTextFieldEnabled:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setTextFieldEnabled:YES];
}


// 点击完成
-(void)selectRightAction
{
    [self finishSetNewPWD];
}

// 完成忘记密码
- (void) finishSetNewPWD
{
    [self.view endEditing:YES];
    NSString* phoneNum = self.phoneNumTF.text;
    NSString* verifyCode = self.verifyCodeTF.text;
    NSString* password = self.passwordTF.text;
    NSString* againPWD = self.againPWDTF.text;
    
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
    
    if(password.length < 6 || againPWD.length < 6)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"输入密码格式不正确"];
        return;
    }
    
    if(![password isEqualToString:againPWD])
    {
        [MBProgressHUBTool textToast:self.view Tip:@"密码不一致,请重新填写"];
        return;
    }
    
    
    // 发起验证码比对网络请求
    [self.parentViewController.view addSubview:backgroundView];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
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
            NSLog(@"验证码比对正确");
            [self changPWDNetWork:phoneNum PWD:password];
        }
        else
        {
            NSLog(@"flag = %d",flag);
            self.verifyCodeTF.text = @"";
            [backgroundView removeFromSuperview];
            [MBProgressHUBTool textToast:self.view Tip:@"验证码错误,请正确填写"];
        }
        return;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [backgroundView removeFromSuperview];
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}


// 修改密码网络请求
- (void) changPWDNetWork: (NSString*) phoneNum PWD:(NSString *)password
{
    // 手机序列号
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* passWord = [NSString stringWithFormat:@"%@%@",[StringMD5 stringAddMD5:password],phoneNum];
    NSString* addMD5PassWord = [StringMD5 stringAddMD5:passWord];
    
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"phone%@imei%@password%@",phoneNum,identifierNumber,addMD5PassWord]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1",hashString]];
    
    NSDictionary* parameter = @{@"phone" : phoneNum,
                                @"imei" : identifierNumber,
                                @"password" : addMD5PassWord,
                                @"apitype" : @"users",
                                @"tag" : @"updatepwd",
                                @"salt" : @"1",
                                @"hash" : hashMD5,
                                @"keyset" : @"phone:imei:password:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"忘记密码请求成功:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            [self.navigationController popViewControllerAnimated:YES];

            [MBProgressHUBTool textToast:self.view Tip:@"密码重置成功"];
        }
        else if([[responseObject valueForKey:@"flag"] isEqualToString:@"none_p"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"手机号不存在"];
        }
        else if([[responseObject valueForKey:@"flag"] isEqualToString:@"none_o"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"用户不存在"];
        }
        else if([[responseObject valueForKey:@"flag"] isEqualToString:@"no"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"服务器异常"];
        }
        [backgroundView removeFromSuperview];
        return;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}

- (void)TextFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumTF)
    {
        if (textField.text.length > 11)
        {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    else if (textField == self.verifyCodeTF)
    {
        if (textField.text.length > 4)
        {
            textField.text = [textField.text substringToIndex:4];
        }
    }
    else if (textField == self.passwordTF || textField == self.againPWDTF)
    {
        if (textField.text.length > 16)
        {
            textField.text = [textField.text substringToIndex:16];
        }
    }


    
}



- (IBAction)verifyAction:(id)sender {

    [self.view endEditing:YES];
    NSString* phoneNum = self.phoneNumTF.text;
    
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
        self.passwordTF.text = @"";
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
        userId = [[responseObject valueForKey:@"user_id"] integerValue];
        if([flag isEqualToString:@"ok"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"手机号不正确或用户不存在"];
            self.phoneNumTF.text = @"";
            return;
        }
        else
        {
            [sender setEnabled:NO];
            [self.phoneNumTF setEnabled:NO];
            self.phoneNumTF.textColor = [UIColor lightGrayColor];
            timeLabel.text = @"60";
            [self.verifyBtn addSubview:timeLabel];
            [self.verifyBtn addSubview:titleLabel];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getVerifyCode) userInfo:nil repeats:YES];
            
            //  获取短信验证码
            NSLog(@"获取验证码。。。");
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNum zone:@"86" customIdentifier:nil result:^(NSError *error)
             {
                 if (!error)
                 {
                     NSLog(@"获取验证码成功");
//                     [self overTimer];
                     
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




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void) setTextFieldEnabled:(BOOL)flag
{
    if(!timeLabel.superview)
        [self.passwordTF setEnabled:flag];
    [self.verifyCodeTF setEnabled:flag];
    [self.phoneNumTF setEnabled:flag];
    [self.againPWDTF setEnabled:flag];
}

- (void) clearTextField
{
    self.passwordTF.text = @"";
    self.verifyCodeTF.text = @"";
    self.phoneNumTF.text = @"";
    self.againPWDTF.text = @"";
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
//        [self clearTextField];
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
        [self.phoneNumTF setEnabled:YES];
        self.phoneNumTF.textColor = [UIColor blackColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [timeLabel removeFromSuperview];
        [titleLabel removeFromSuperview];
        
    }
}

// UITextField Delegat
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.passwordTF)
    {
        [self.againPWDTF becomeFirstResponder];
    }
    else if(textField == self.againPWDTF)
    {
        [self.againPWDTF resignFirstResponder];
        [self finishSetNewPWD];
    }
    
    return YES;
}

@end
