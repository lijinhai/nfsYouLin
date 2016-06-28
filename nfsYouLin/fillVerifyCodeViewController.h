//
//  fillVerifyCodeViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/6/23.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fillVerifyCodeViewController : UIViewController
- (IBAction)valiyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *valiyBtn;

@property (weak, nonatomic) IBOutlet UITextField *writeValiyTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipInfoLabel;


@end
