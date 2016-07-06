//
//  registerViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController <NSURLSessionDataDelegate>

@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *verifyTextField;
@property (strong, nonatomic) UITextField *inviteTextField;
@property(nonatomic ,assign) BOOL isClick;

@property (strong, nonatomic) IBOutlet UIButton *verifyBtn;


// 获取验证码
- (IBAction)getVerificationCode:(id)sender;


@property (nonatomic,readwrite) NSMutableDictionary *dict;
- (IBAction)aboutTermsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *youLinServiceButton;

- (IBAction)selectYouLinService:(id)sender;

- (id) init;

@end
