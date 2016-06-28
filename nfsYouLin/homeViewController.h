//
//  homeViewController.h
//  nfsYouLin
//
//  Created by Macx on 16/5/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)forgetAction:(UIButton *)sender;
- (IBAction)registerAction:(UIButton *)sender;
- (IBAction)loginAction:(id)sender;

@end
