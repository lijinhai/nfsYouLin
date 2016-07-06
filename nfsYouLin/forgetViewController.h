//
//  forgetViewController.h
//  nfsYouLin
//
//  Created by Macx on 16/5/10.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgetViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *againPWDTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *verifyBtn;
- (IBAction)verifyAction:(id)sender;

- (void) textFieldResignResponder;

@end
