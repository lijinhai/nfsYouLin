//
//  InviteVC.m
//  nfsYouLin
//
//  Created by Macx on 16/8/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "InviteVC.h"
#import "HeaderFile.h"

@interface InviteVC ()

@end

@implementation InviteVC
{
    UITextField* _phoneTF;
    UIButton* friendBtn;
    UIButton* familyBtn;
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
    hint1.text = @"1、好友如果未能收到邀请信息，可以在邀请记录中在次邀请。";
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

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -selector
- (void) phoneClicked:(id) sender
{
    NSLog(@"phoneClicked");
}

- (void) friendClicked:(id)sender
{
    [friendBtn setImage:[UIImage imageNamed:@"pic_pengyou_b.png"] forState:UIControlStateNormal];
    [familyBtn setImage:[UIImage imageNamed:@"pic_jiaren_a.png"] forState:UIControlStateNormal];
}

- (void) familyClicked:(id)sender
{
    [friendBtn setImage:[UIImage imageNamed:@"pic_pengyou_a.png"] forState:UIControlStateNormal];
    [familyBtn setImage:[UIImage imageNamed:@"pic_jiaren_b.png"] forState:UIControlStateNormal];
    
}

- (void) inviteClicked:(id) sender
{
    NSLog(@"inviteClicked");
}

- (void) recordClicked:(id) sender
{
    NSLog(@"recordClicked");
}

- (void) shareClicked: (id) sender
{
    NSLog(@"shareClicked");
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

@end
