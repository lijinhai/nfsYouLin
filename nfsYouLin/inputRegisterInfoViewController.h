//
//  inputRegisterInfoViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/5/17.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
@interface inputRegisterInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *selectBoyRadio;
@property (weak, nonatomic) IBOutlet UIImageView *selectGirlRadio;


@property (strong, nonatomic) NSString* inviteCode;
@property (strong, nonatomic) NSString* phoneNum;
@property (strong, nonatomic) UITextField *nickNameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *comfirmPWDTextField;
@property (assign, nonatomic) NSInteger genderSelected;

@end
