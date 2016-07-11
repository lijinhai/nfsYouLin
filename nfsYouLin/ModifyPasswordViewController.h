//
//  ModifyPasswordViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassWordTextField;

@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *bgView;



@end
