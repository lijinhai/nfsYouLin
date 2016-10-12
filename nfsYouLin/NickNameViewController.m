//
//  NickNameViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/4.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NickNameViewController.h"
#import "PersonalInformationViewController.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "SqliteOperation.h"

@interface NickNameViewController ()

@end

@implementation NickNameViewController{
 
    UIColor *_viewColor;
    PersonalInformationViewController *PersonalInformationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor = _viewColor;
    

}

-(void)viewWillAppear:(BOOL)animated{

    /*页面跳转*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    PersonalInformationController=[storyBoard instantiateViewControllerWithIdentifier:@"personalinformationcontroller"];
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"";
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    /*设置textfield属性*/
    _nikeNameTextField.frame = CGRectMake(20, 80, screenWidth-40, 40);
    _tipLabel.frame = CGRectMake(20, 128, screenWidth-40, 40);
    _tipLabel.numberOfLines = 0;
    _nikeNameTextField.backgroundColor=[UIColor whiteColor];
    
    [_nikeNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //_tipLabel.backgroundColor=[UIColor whiteColor];
    
    if(![_nikeNameValue isEqualToString:@""])
    {
      _nikeNameTextField.text=_nikeNameValue;
    }
    
}

- (void)returnText:(ReturnTextBlock)block {
   
    self.returnTextBlock = block;
}

- (IBAction)View_TouchDown:(id)sender {
    
      [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (IBAction)nick_DidEndExit:(id)sender {
    
    [sender resignFirstResponder];
}
-(void)sureAction{

    [self changeNickName];
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_nikeNameTextField.text);
        NSLog(@"nikeNameTextField.text is %@",_nikeNameTextField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeNickName{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%@user_nick%@",phoneNum,userId,_nikeNameTextField.text]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@812",hashString]];
    NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                @"user_id" : userId,
                                @"user_nick":_nikeNameTextField.text,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"upload",
                                @"salt" : @"812",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_phone_number:user_id:user_nick:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"sexresponseObject is %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            [SqliteOperation updateUserNickInfo:[userId longLongValue] nickName:_nikeNameTextField.text];
            NSLog(@"更改昵称成功");
        }else{
        
        
            NSLog(@"更改昵称失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];


}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nikeNameTextField) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
