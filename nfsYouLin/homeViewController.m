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
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "MBProgressHUBTool.h"
#import "HeaderFile.h"
#import "SqliteOperation.h"
#import "SqlDictionary.h"


@interface homeViewController ()

@end

@implementation homeViewController
{
    forgetViewController* _forgetController;
    registerViewController* _registerController;
    FirstTabBarController* _FirstTabBarController;
    
    UINavigationController *newNavigationController;
    UIActivityIndicatorView* _indicator;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    if (phoneNum.length == 11) {
        self.phoneTextField.text = phoneNum;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*设置textField clear button 图片*/
    UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView* xImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_x.png"]];
    xImageView.frame = CGRectMake(10, 0,14,14);
    [rightVeiw addSubview:xImageView];
    UIView *paddingView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.phoneTextField.leftView = paddingView0;
    self.phoneTextField.rightViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.rightView = rightVeiw;
    self.phoneTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField addTarget:self action:@selector(phoneTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTextField.delegate = self;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.passwordTextField.leftView = paddingView1;
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.rightView = rightVeiw;
    self.passwordTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.delegate = self;
    /*xImageView 添加点击事件*/
    xImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *xImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xImageViewClick:)];
    [xImageView addGestureRecognizer:xImageViewTap];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 20, screenHeight / 2, 40, 40)];
    [self.view addSubview:_indicator];
    _indicator.hidesWhenStopped = YES;
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    _indicator.color = [UIColor redColor];
    
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.phoneTextField)
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        return canChange;
    }
    
    return YES;
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
    
    [self.view endEditing:YES];
    [self login];

}

// 登录
- (void) login
{
    NSString* phoneNum = self.phoneTextField.text;
    NSString* password = self.passwordTextField.text;
    if(phoneNum.length == 0)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"账号不能为空"];
        return;
    }
    //  登录网络请求
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* passWord = [NSString stringWithFormat:@"%@%@",[StringMD5 stringAddMD5:password],phoneNum];
    NSString* addMD5PassWord = [StringMD5 stringAddMD5:passWord];
    
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"phonenum%@password%@",phoneNum,addMD5PassWord]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1",hashString]];
    
    
    NSDictionary* parameter = @{@"phonenum" : phoneNum,
                                @"password" : addMD5PassWord,
                                @"apitype" : @"users",
                                @"tag" : @"login",
                                @"salt" : @"1",
                                @"hash" : hashMD5,
                                @"keyset" : @"phonenum:password:",
                                };
    
    [_indicator startAnimating];
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"登录网络请求成功:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            NSDictionary* usersDict = [responseObject firstObject];
            NSInteger userId = [[usersDict valueForKey:@"pk"] integerValue];
            NSDictionary* personDic = [usersDict valueForKey:@"fields"];
            NSLog(@"[user_community_id valueForKey: is %@",[personDic valueForKey:@"user_community_id"]);
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if(![[NSString stringWithFormat:@"%@",[personDic valueForKey:@"user_community_id"]] isEqualToString:@"<null>"]){
            
                NSLog(@"defaults is ********");
            [defaults setInteger:[[personDic valueForKey:@"user_community_id"] integerValue] forKey:@"communityId"];
                
            }
            
            if(![[NSString stringWithFormat:@"%@",[personDic valueForKey:@"user_family_id"]]isEqualToString:@"<null>"]){
                
                [defaults setObject:[personDic valueForKey:@"user_family_id"] forKey:@"familyId"];
            }
            NSLog(@"defaults is @@@@@@@@@@@");
            [defaults setInteger:[[personDic valueForKey:@"addr_handle_cache"] integerValue] forKey:@"addrCache"];
            
            [defaults setObject:[personDic valueForKey:@"user_portrait"] forKey:@"portrait"];
            [defaults setObject:[personDic valueForKey:@"user_news_receive"] forKey:@"news_status"];
            [defaults setObject:[personDic valueForKey:@"user_nick"] forKey:@"nick"];
            [defaults setObject:[usersDict valueForKey:@"pk"] forKey:@"userId"];
            [defaults setObject:[personDic valueForKey:@"user_password"] forKey:@"password"];
            [defaults setObject:[personDic valueForKey:@"user_type"] forKey:@"type"];
            [defaults synchronize];
            
            SqlDictionary* sqlDict = [[SqlDictionary alloc] init];
            NSMutableDictionary* personInfoDic = [sqlDict getInitUserDictionary];
            personInfoDic[@"user_public_status"] = personDic[@"user_public_status"];
            personInfoDic[@"user_vocation"] = personDic[@"user_profession"];//user_profession
            personInfoDic[@"user_level"] = personDic[@"user_level"];
            personInfoDic[@"user_id"] = [NSNumber numberWithLong:userId];
            
            personInfoDic[@"user_name"] = personDic[@"user_nick"];
            
            personInfoDic[@"user_portrait"] = personDic[@"user_portrait"];
            personInfoDic[@"user_gender"] = personDic[@"user_gender"];
            personInfoDic[@"user_phone_number"] = personDic[@"user_phone_number"];
            personInfoDic[@"user_family_id"] = personDic[@"user_family_id"];
            personInfoDic[@"user_family_address"] = personDic[@"user_family_address"];
            personInfoDic[@"user_birthday"] = personDic[@"user_birthday"];
            personInfoDic[@"user_email"] = personDic[@"user_email"];
            personInfoDic[@"user_type"] = personDic[@"user_type"];
            personInfoDic[@"user_time"] = personDic[@"user_time"];
            personInfoDic[@"user_json"] = personDic[@"user_json"];
            
            if(![SqliteOperation insertUsersSqlite:personInfoDic View:self.view])
            {
                NSLog(@"插入失败！");
                return ;
            }
            [personInfoDic removeAllObjects];
            
            
            for (int i = 1; i < [responseObject count]; i++) {
                [personInfoDic removeAllObjects];
                personInfoDic = [sqlDict getInitFamilyInfoDic];
                NSDictionary* familyDict = responseObject[i];
                if(![[NSString stringWithFormat:@"%@", personDic[@"user_family_id"]] isEqualToString:@"<null>"]&&[personDic[@"user_family_id"] integerValue] ==
                   [familyDict[@"family_id"] integerValue])
                {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setInteger:[[familyDict valueForKey:@"block_id"] integerValue] forKey:@"block_id"];
                    [defaults setObject:[familyDict valueForKey:@"community_name"] forKey:@"familyAddress"];
                    [defaults synchronize];
                }
                personInfoDic[@"family_apt_id"] = familyDict[@"apt_num_id"];
                personInfoDic[@"family_block_id"] = familyDict[@"block_id"];
                personInfoDic[@"family_block"] = familyDict[@"block_name"];
                personInfoDic[@"family_building_id"] = familyDict[@"building_num_id"];
                personInfoDic[@"family_city_code"] = familyDict[@"city_code"];
                personInfoDic[@"family_city_id"] = familyDict[@"city_id"];
                personInfoDic[@"family_city"] = familyDict[@"city_name"];
                personInfoDic[@"family_community_id"] = familyDict[@"community_id"];
                personInfoDic[@"family_community_nickname"] = familyDict[@"community_name"];
                personInfoDic[@"entity_type"] = familyDict[@"entity_type"];
                personInfoDic[@"family_address"] = familyDict[@"family_address"];
                personInfoDic[@"family_apt_num"] = familyDict[@"family_apt_num"];
                personInfoDic[@"family_building_num"] = familyDict[@"family_building_num"];
                personInfoDic[@"family_id"] = familyDict[@"family_id"];
                personInfoDic[@"family_member_count"] = familyDict[@"family_member_count"];
                personInfoDic[@"family_name"] = familyDict[@"family_name"];
                personInfoDic[@"family_address_id"] = familyDict[@"fr_id"];
                personInfoDic[@"is_family_member"] = familyDict[@"is_family_member"];
                personInfoDic[@"ne_status"] = familyDict[@"ne_status"];
                personInfoDic[@"primary_flag"] = familyDict[@"primary_flag"];
                personInfoDic[@"user_avatar"] = familyDict[@"user_avatar"];
                if(![SqliteOperation insertFamilyInfoSqlite:personInfoDic View:self.view])
                {
                    NSLog(@"插入失败！");
                    return ;
                }
                
            }
            
            
            // 测试查询
            //            AppDelegate* app = [[UIApplication sharedApplication] delegate];
            //            FMDatabase* db = app.db;
            //            if([db open])
            //            {
            //                FMResultSet *rs = [db executeQuery:@"SELECT * FROM table_all_family"];
            //                NSLog(@"查询");
            //                while ([rs next]) {
            //
            //                    NSString *user_avatar = [rs stringForColumn:@"user_avatar"];
            //
            //                    NSLog(@"user_avatar = %@",user_avatar);
            //                }
            //            }
            
            [self changePersonInfoNet:userId];
            
            
            
        }
        else if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString* flag = [responseObject valueForKey:@"flag"];
            NSLog(@"flag = %@",flag);
            if([flag isEqualToString:@"no"])
            {
                [MBProgressHUBTool textToast:self.view Tip:@"用户不存在!"];
            }
            else if([flag isEqualToString:@"no1"])
            {
                [MBProgressHUBTool textToast:self.view Tip:@"账户名或密码错误!"];
            }
            NSLog(@"登录失败");
            
        }
        [_indicator stopAnimating];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        [_indicator stopAnimating];
        return;
    }];
    
}


- (IBAction)finishEdit:(id)sender {
    [sender resignFirstResponder];
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

// 更改个人信息网络请求
- (void) changePersonInfoNet: (NSInteger)userId
{
    NSString* phoneNum = self.phoneTextField.text;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%ldimei%@",phoneNum,userId,identifierNumber]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                @"user_id" : [NSString stringWithFormat:@"%ld",userId],
                                @"imei" : identifierNumber,
                                @"apitype" : @"users",
                                @"tag" : @"upload",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_phone_number:user_id:imei:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"更改个人信息网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        NSLog(@"flag = %@",flag);
        if([flag isEqualToString:@"ok"])
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:userId forKey:@"userId"];
            [defaults setValue:phoneNum forKey:@"phoneNum"];
            [defaults synchronize];

            [self presentViewController:newNavigationController animated:YES completion:nil];
        }
        else
        {
            NSLog(@"更改个人信息网络请求 失败");

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.passwordTextField)
    {
        [self login];
    }
    return YES;
}

@end
