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
#import "StringMD5.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"
#import "AppDelegate.h"
#import "SqlDictionary.h"
#import "FMDB.h"
#import "Constants.h"

@interface inputRegisterInfoViewController ()

@end

@implementation inputRegisterInfoViewController{
 
    chooseCityViewController * cityController;
    NSMutableDictionary* personInfoDic;
    SqlDictionary* usersDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    UIBarButtonItem *finishItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem = finishItem;
    self.navigationItem.title = @"";
    /*ImageView 添加点击事件*/
    self.selectBoyRadio.userInteractionEnabled = YES;
    self.selectBoyRadio.tag = 1;
    UITapGestureRecognizer *bImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRadioClick:)];
    [self.selectBoyRadio addGestureRecognizer:bImageViewTap];
    
    self.selectGirlRadio.userInteractionEnabled = YES;
    self.selectGirlRadio.tag = 2;
    UITapGestureRecognizer *gImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRadioClick:)];
    [self.selectGirlRadio addGestureRecognizer:gImageViewTap];
    
    
    // 添加昵称输入框
    self.nickNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.nickNameTextField.frame = CGRectMake(3, -1, 240, 49);
    self.nickNameTextField.backgroundColor = [UIColor whiteColor];
    self.nickNameTextField.placeholder = @"请输入昵称（2~10个字）";
    self.nickNameTextField.leftView = paddingView0;
    self.nickNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nickNameTextField.returnKeyType = UIReturnKeyNext;
    self.nickNameTextField.delegate = self;
    [self.nickNameTextField addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    redrawTextField *nickNameTextfield=[[redrawTextField alloc] init:CGRectMake(20, 174, 374, 51) addTextField:self.nickNameTextField];
    // 添加设置密码输入框
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.passwordTextField.frame = CGRectMake(3, -1, 368, 49);
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.placeholder=@"请输入密码（6-16个字符）";
    self.passwordTextField.leftView = paddingView1;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.delegate = self;
    [self.passwordTextField addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    redrawTextField *passwordTextfield=[[redrawTextField alloc] init:CGRectMake(20,228, 374, 51) addTextField:self.passwordTextField];
    
    // 添加确认密码输入框
    
    self.comfirmPWDTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.comfirmPWDTextField.frame = CGRectMake(3, -1, 368, 49);
    self.comfirmPWDTextField.backgroundColor = [UIColor whiteColor];
    self.comfirmPWDTextField.placeholder = @"请确认密码（6-16个字符）";
    self.comfirmPWDTextField.leftView = paddingView2;
    self.comfirmPWDTextField.leftViewMode = UITextFieldViewModeAlways;
    self.comfirmPWDTextField.secureTextEntry = YES;
    self.comfirmPWDTextField.returnKeyType = UIReturnKeyDone;
    self.comfirmPWDTextField.delegate = self;
    [self.comfirmPWDTextField addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    redrawTextField *confirmPasswordTextfield=[[redrawTextField alloc] init:CGRectMake(20,287, 374, 51) addTextField:self.comfirmPWDTextField];
    
    [self.view addSubview:nickNameTextfield];
    [self.view addSubview:passwordTextfield];
    [self.view addSubview:confirmPasswordTextfield];
    
    self.genderSelected = -1;
    /*跳转至选择城市界面*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    cityController = [storyBoard instantiateViewControllerWithIdentifier:@"cityController"];
    usersDict = [[SqlDictionary alloc] init];
    personInfoDic = [usersDict getInitUserDictionary];
    
    NSLog(@"personInfoDic 1 = %@",personInfoDic);
    
}
- (void)viewWillAppear:(BOOL)animated
{
    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"";
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setTextFieldEnabled:NO];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setTextFieldEnabled:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)finishAction{

    NSString* nickName = self.nickNameTextField.text;
    NSString* password = self.passwordTextField.text;
    NSString* comfirmPWD = self.comfirmPWDTextField.text;
    NSString* gender = [NSString stringWithFormat:@"%ld",self.genderSelected];
    // 测试代码
//    [self.view endEditing:NO];
//    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"请选择城市" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:neighborItem];
//    [self.navigationController pushViewController:cityController animated:YES];
//    return;
    if(self.genderSelected == -1)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"请选择性别"];
        return;
    }
    
    if(nickName.length == 0)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"名字不能为空"];
        return;
    }
    
    if(nickName.length < 2)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"名字格式不正确"];
        return;
    }
    
    if(password.length < 6 || comfirmPWD.length < 6)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"输入密码格式不正确"];
        return;
    }
    
    if(![password isEqualToString:comfirmPWD])
    {
        [MBProgressHUBTool textToast:self.view Tip:@"密码不一致,请重新填写"];
        return;
    }
    
  
    personInfoDic[@"user_phone_number"] = self.phoneNum;
    personInfoDic[@"user_name"] = nickName;
    personInfoDic[@"user_gender"] = [NSNumber numberWithInteger:self.genderSelected];
    
    
  
//    return;
    // 发起用户注册网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"gender%@nick%@phonenum%@password%@recommend%@",gender,nickName,self.phoneNum,password,self.inviteCode]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1",MD5String]];
    
    NSDictionary* parameter = @{@"gender"   : gender,
                                @"nick"     : nickName,
                                @"phonenum" : self.phoneNum,
                                @"password" : password,
                                @"recommend": self.inviteCode,
                                @"tag"      : @"regist",
                                @"apitype"  : @"users",
                                @"salt"     : @"1",
                                @"hash"     : hashString,
                                @"keyset"   : @"gender:nick:phonenum:password:recommend:"
                                
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功:%@", responseObject);
        NSInteger flag = [[responseObject valueForKey:@"flag"] integerValue];
        if(flag == 1)
        {
            NSLog(@"注册成功");
            personInfoDic[@"user_id"] = [responseObject valueForKey:@"user_id"];
            personInfoDic[@"user_portrait"] = [responseObject valueForKey:@"user_avatr"];
            if([self insertSqlite:personInfoDic])
            {
                NSLog(@"页面跳转");
                [self.navigationController pushViewController:cityController animated:YES];
            }
            
          
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

    
}

-(void)selectRadioClick:(UITapGestureRecognizer*)sender{
    UIImage *selectedImage = [UIImage imageNamed:@"checked_sex"];
    UIImage *emptyImage = [UIImage imageNamed:@"uncheck_sex"];
    NSLog(@"%ld", sender.view.tag);
    self.genderSelected = sender.view.tag;
    if(sender.view.tag == 1)
    {
        self.selectBoyRadio.image = selectedImage;
        self.selectGirlRadio.image = emptyImage;
    }
    else
    {
        self.selectBoyRadio.image = emptyImage;
        self.selectGirlRadio.image = selectedImage;
    
    }
}

- (void)TextFieldDidChange:(UITextField *)textField
{
    if (textField == self.nickNameTextField)
    {
        if (textField.text.length > 10)
        {
            textField.text = [textField.text substringToIndex:10];
        }
    }
    else if(textField == self.passwordTextField || textField == self.comfirmPWDTextField)
    {
        if(textField.text.length > 16)
        {
            textField.text = [textField.text substringToIndex:16];
        }
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:NO];
}

- (void) setInviteCode:(NSString *)inviteCode
{
    NSLog(@"setInviteCode = %@", inviteCode);
    _inviteCode = inviteCode;
}

- (void) setPhoneNum:(NSString *)phoneNum
{
    NSLog(@"phoneNum = %@",phoneNum);
    _phoneNum = phoneNum;
}



- (void) setTextFieldEnabled:(BOOL)flag
{
    [self.nickNameTextField setEnabled:flag];
    [self.passwordTextField setEnabled:flag];
    [self.comfirmPWDTextField setEnabled:flag];
}

// <UITextFieldDelegat >协议方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.nickNameTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
    {
        [self.comfirmPWDTextField becomeFirstResponder];
    }
    else if(textField == self.comfirmPWDTextField)
    {
        [self.comfirmPWDTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL) insertSqlite: (NSMutableDictionary *) dict
{
    NSLog(@"insertSqlite = %@",dict);
    if(!dict)
        return NO;
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    NSString* filePath = app.dbPath;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath])
    {
        FMDatabase* db = [FMDatabase databaseWithPath:filePath];
        if ([db open])
        {
            [db executeUpdate:INSERT_USERS_TABLE,
                personInfoDic[@"user_public_status"] ,
                personInfoDic[@"user_vocation"] ,
                personInfoDic[@"user_level"] ,
                personInfoDic[@"user_id"],
                personInfoDic[@"user_name"] ,
                personInfoDic[@"user_portrait"],
                personInfoDic[@"user_gender"] ,
                personInfoDic[@"user_phone_number"] ,
                personInfoDic[@"user_family_id"],
                personInfoDic[@"user_family_address"] ,
                personInfoDic[@"user_birthday"],
                personInfoDic[@"user_email"] ,
                personInfoDic[@"user_type"] ,
                personInfoDic[@"user_time"],
                personInfoDic[@"user_json"] ,
                personInfoDic[@"login_account"] ,
                personInfoDic[@"table_version"] ];
        }
        else
        {
            NSLog(@"数据库打开失败");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"数据库打开失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [db close];
            return NO;
        }
        [db close];

    }
    else
    {
        NSLog(@"数据库不存在");
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"数据写入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;

    }
    
    return YES;

}


@end
