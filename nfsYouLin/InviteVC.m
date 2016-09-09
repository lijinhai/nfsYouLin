//
//  InviteVC.m
//  nfsYouLin
//
//  Created by Macx on 16/8/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "InviteVC.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"
#import "BackgroundView.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "AppDelegate.h"
#import "WaitView.h"
#import "InviteRecordVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface InviteVC ()

@end

@implementation InviteVC
{
    UITextField* _phoneTF;
    UIButton* friendBtn;
    UIButton* familyBtn;
    
    PhonesView* phonesView;
    BackgroundView* bgView;
    NSInteger invType;
    
    UIView* backgroundView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 40)];
    _phoneTF.layer.borderColor=[[UIColor cyanColor] CGColor];
    _phoneTF.layer.cornerRadius = 5;
    _phoneTF.backgroundColor = [UIColor whiteColor];
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.returnKeyType = UIReturnKeyDone;
    _phoneTF.delegate = self;
    _phoneTF.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_phoneTF];
    
    UIControl* phoneV = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(_phoneTF.frame) - 60, 0, 60, 40)];
    phoneV.backgroundColor = MainColor;
    [phoneV addTarget:self action:@selector(phoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* phoneIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 20, 24)];
    phoneIV.image = [UIImage imageNamed:@"tongxunlu.png"];
    [phoneV addSubview:phoneIV];
    [_phoneTF addSubview:phoneV];
    
    UILabel* phoneL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_phoneTF.frame) + 10, CGRectGetWidth(_phoneTF.frame), 50)];
    phoneL.enabled = NO;
    phoneL.font = [UIFont systemFontOfSize:12];
    phoneL.numberOfLines = 0;
    phoneL.text = @"系统会发送一条推荐短信到家人/朋友的手机上，好友可以通过地址下载优邻，好友使用手机号注册成功后可以获得相应的奖励。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:phoneL.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [phoneL.text length])];
    phoneL.attributedText = attributedString;
    [self.view addSubview:phoneL];
    [phoneL sizeToFit];
    
    friendBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) / 2 - 100), CGRectGetMaxY(phoneL.frame) + 20, 60, 60)];
    [friendBtn setAdjustsImageWhenHighlighted:NO];
    [friendBtn setImage:[UIImage imageNamed:@"pic_pengyou_a.png"] forState:UIControlStateNormal];
    friendBtn.layer.masksToBounds = YES;
    friendBtn.layer.cornerRadius = 30;
    [friendBtn addTarget:self action:@selector(friendClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* friendL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(friendBtn.frame), CGRectGetMaxY(friendBtn.frame) + 5, 60, 20)];
    friendL.text = @"朋友";
    friendL.textAlignment = NSTextAlignmentCenter;
    friendL.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:friendL];
    [self.view addSubview:friendBtn];
    
    familyBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) / 2 + 30), CGRectGetMaxY(phoneL.frame) + 20, 60, 60)];
    [familyBtn setAdjustsImageWhenHighlighted:NO];
    [familyBtn setImage:[UIImage imageNamed:@"pic_jiaren_a.png"] forState:UIControlStateNormal];
    familyBtn.layer.masksToBounds = YES;
    familyBtn.layer.cornerRadius = 30;
    [familyBtn addTarget:self action:@selector(familyClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* familyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(familyBtn.frame), CGRectGetMaxY(familyBtn.frame) + 5, 60, 20)];
    familyL.text = @"家人";
    familyL.textAlignment = NSTextAlignmentCenter;
    familyL.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:familyL];
    [self.view addSubview:familyBtn];

    
    UIButton* inviteBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(friendL.frame) + 20, CGRectGetWidth(self.view.frame) - 60, 40)];
    inviteBtn.layer.cornerRadius = 5;
    [inviteBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
    [inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inviteBtn setBackgroundColor:MainColor];
    [inviteBtn addTarget:self action:@selector(inviteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inviteBtn];
    
    UIButton* recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(inviteBtn.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 40)];
    recordBtn.layer.cornerRadius = 5;
    [recordBtn setTitle:@"邀请记录" forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recordBtn setBackgroundColor:MainColor];
    [recordBtn addTarget:self action:@selector(recordClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];

    UIButton* shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(recordBtn.frame) + 10, CGRectGetWidth(self.view.frame) - 60, 40)];
    shareBtn.layer.cornerRadius = 5;
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:MainColor];
    [shareBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UIImageView* hintIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(shareBtn.frame) / 2, CGRectGetMaxY(shareBtn.frame) + 25, 14, 12)];
    hintIV.image = [UIImage imageNamed:@"xin.png"];
    [self.view addSubview:hintIV];
    
    UILabel* hintL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hintIV.frame) + 2, CGRectGetMinY(hintIV.frame), 100, 12)];
    hintL.text = @"温馨提示";
    hintL.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:hintL];
    
    
    UILabel* hint1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneL.frame), CGRectGetMaxY(hintL.frame) + 20, CGRectGetWidth(phoneL.frame), 20)];
    hint1.text = @"1、好友如果未能收到邀请信息，请重新邀请。";
    hint1.numberOfLines = 0;
    hint1.enabled = NO;
    hint1.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:hint1];
    
    UILabel* hint2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(hint1.frame), CGRectGetMaxY(hint1.frame) + 5, CGRectGetWidth(hint1.frame), 40)];
    hint2.text = @"2、邀请后，您也可以在邀请成功界面使用微信、QQ等社交软件发分享给好友。";
    hint2.numberOfLines = 0;
    hint2.enabled = NO;
    hint2.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:hint2];
    
    UILabel* hint3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(hint2.frame), CGRectGetMaxY(hint2.frame) + 5, CGRectGetWidth(hint2.frame), 20)];
    hint3.text = @"3、如果被邀请用户注册体验小区，暂时不提供积分奖励。";
    hint3.numberOfLines = 0;
    hint3.enabled = NO;
    hint3.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:hint3];
    
    invType = -1;
    phonesView = [[PhonesView alloc] init];
    phonesView.delegate = self;
    bgView = [[BackgroundView alloc] initWithFrame:self.view.frame view:phonesView];

    WaitView* waitView = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"加载中..."];
    backgroundView = [[UIView alloc] initWithFrame:self.parentViewController.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:waitView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact;
{
    _phoneTF.text = @"";
    NSMutableArray* phoneArr = [[NSMutableArray alloc] init];
    NSArray* phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        //获取电话号码的KEY
        NSString *phoneLabel = labeledValue.label;
        //获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        NSString *phoneStr = [phoneValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [phoneArr addObject:phoneStr];
    }
    
    if([phoneArr count] == 0)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"联系人手机号获取失败"];
        return;
    }
    else if([phoneArr count] == 1)
    {
        _phoneTF.text = [phoneArr firstObject];
    }
    else
    {
        CGRect rect = CGRectMake(20, CGRectGetMaxY(_phoneTF.frame), 200, [phoneArr count] * 40);
        [phonesView reloadView:rect array:phoneArr];
        [self.parentViewController.view addSubview:bgView];
        [self.parentViewController.view addSubview:phonesView];
    }
}

#pragma mark -PhonesDelegate
-(void) selectedPhone:(NSString *)phone
{
    _phoneTF.text = phone;
}

#pragma mark -selector
- (void) phoneClicked:(id) sender
{
    [_phoneTF resignFirstResponder];
    CNContactPickerViewController * contactVC = [[CNContactPickerViewController alloc] init];
    contactVC.delegate = self;
    [self presentViewController:contactVC animated:YES completion:nil];
}

- (void) friendClicked:(id)sender
{
    invType = 2;
    [friendBtn setImage:[UIImage imageNamed:@"pic_pengyou_b.png"] forState:UIControlStateNormal];
    [familyBtn setImage:[UIImage imageNamed:@"pic_jiaren_a.png"] forState:UIControlStateNormal];
}

- (void) familyClicked:(id)sender
{
    invType = 1;
    [friendBtn setImage:[UIImage imageNamed:@"pic_pengyou_a.png"] forState:UIControlStateNormal];
    [familyBtn setImage:[UIImage imageNamed:@"pic_jiaren_b.png"] forState:UIControlStateNormal];
    
}

- (void) inviteClicked:(id) sender
{
    NSString* phoneNum = _phoneTF.text;
    NSString *phoneRegex = @"^1[3 | 4 | 5 | 7 | 8][0-9]\\d{8}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phonePredicate evaluateWithObject:phoneNum];
    if(!isValid)
    {
        [[[UIAlertView alloc] initWithTitle:@"提醒" message:@"请填写正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    [_phoneTF resignFirstResponder];
    if(invType == -1)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"请选择邀请类别"];
        return;
    }
    [self.parentViewController.view addSubview:backgroundView];
    [self getInviteCodeNet];

}

- (void) recordClicked:(id) sender
{
    NSLog(@"recordClicked");
    InviteRecordVC* recordVC = [[InviteRecordVC alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void) shareClicked: (id) sender
{
    NSLog(@"shareClicked");
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"pic_youlin.png"]];
    if (imageArray)
    {
        [shareParams SSDKSetupShareParamsByText:@"分享内容 @value(url)"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://www.mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeImage];
    }
    
    //2、分享
    [ShareSDK showShareActionSheet:sender
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state)
                   {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@", error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
               }];
}




#pragma mark -UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -Network
// 获取邀请码网络请求
- (void)getInviteCodeNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* familyId = [defaults valueForKey:@"familyId"];
    NSString* userId = [defaults valueForKey:@"userId"];
    NSString* phone = _phoneTF.text;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"family_id%@user_id%@inv_type%ldinv_phone%@",familyId,userId,invType,phone]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"family_id" : familyId,
                                @"user_id" : userId,
                                @"inv_type" : [NSNumber numberWithInteger:invType],
                                @"inv_phone" : phone,
                                @"inv_status" : @"0",
                                @"apitype" : @"users",
                                @"salt" : @"1",
                                @"tag" : @"getinvcode",
                                @"hash" : hashString,
                                @"keyset" : @"family_id:user_id:inv_type:inv_phone:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSString* flag = [responseObject valueForKey:@"flag"];
        NSLog(@"msg = %@",[responseObject valueForKey:@"yl_msg"]);
        if([flag isEqualToString:@"ok"])
        {
            NSString* invCode = [responseObject valueForKey:@"inv_code"];
            NSString* msg = [responseObject valueForKey:@"yl_msg"];
            [self inviteNet:invCode msg:msg];
            
        }
        else if([flag isEqualToString:@"exist"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"该手机号已注册，无法邀请。"];
            return;
        }
        NSLog(@"获取邀请码网络请求:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 邀请网络请求
- (void)inviteNet:(NSString*)invCode msg:(NSString *)msg
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* familyId = [defaults valueForKey:@"familyId"];
    NSString* userId = [defaults valueForKey:@"userId"];
    NSString* phone = _phoneTF.text;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"family_id%@user_id%@inv_type%ldinv_phone%@",familyId,userId,invType,phone]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"family_id" : familyId,
                                @"user_id" : userId,
                                @"inv_type" : [NSNumber numberWithInteger:invType],
                                @"inv_phone" : phone,
                                @"inv_code" : invCode,
                                @"apitype" : @"users",
                                @"salt" : @"1",
                                @"tag" : @"invitenewusers",
                                @"hash" : hashString,
                                @"keyset" : @"family_id:user_id:inv_type:inv_phone:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            NSLog(@"msg = %@",[responseObject valueForKey:@"yl_msg"]);
            NSLog(@"邀请网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            [backgroundView removeFromSuperview];
//            [MBProgressHUBTool textToast:self.view Tip:[responseObject valueForKey:@"yl_msg"]];
             [self showMessageView:[NSArray arrayWithObjects:_phoneTF.text, nil] title:@"优邻" body:msg];
            invType = -1;
            [friendBtn setImage:[UIImage imageNamed:@"pic_pengyou_a.png"] forState:UIControlStateNormal];
            [familyBtn setImage:[UIImage imageNamed:@"pic_jiaren_a.png"] forState:UIControlStateNormal];
            _phoneTF.text = @"";
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}



#pragma mark - MFMessageComposeViewController

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
        {
            //信息传送成功
            [MBProgressHUBTool textToast:self.view Tip:@"信息发送成功"];
            NSLog(@"信息发送成功");
            break;
        }
        case MessageComposeResultFailed:
        {
            //信息传送失败
            [MBProgressHUBTool textToast:self.view Tip:@"信息发送失败"];
            NSLog(@"信息发送失败");

            break;
        }
        case MessageComposeResultCancelled:
        {
            //信息被用户取消传送
            [MBProgressHUBTool textToast:self.view Tip:@"信息取消发送"];
            NSLog(@"信息取消发送");
            break;
        }
        default:
            break;
    }
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
