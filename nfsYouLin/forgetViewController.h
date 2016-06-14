//
//  forgetViewController.h
//  nfsYouLin
//
//  Created by Macx on 16/5/10.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *getCaptchaBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *inputCaptcha;
@property (weak, nonatomic) IBOutlet UITextField *inputNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *inputRepeatPassword;

@end
