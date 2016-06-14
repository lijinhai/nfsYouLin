//
//  registerViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputRegisterPhone;
@property (nonatomic,readwrite) NSMutableDictionary *dict;
- (IBAction)aboutTermsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *youLinServiceButton;

- (IBAction)selectYouLinService:(id)sender;
@property(nonatomic ,assign) BOOL isClick; 
@end
