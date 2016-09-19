//
//  PropertyVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/18.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyVC : UIViewController


//报修
@property(strong, nonatomic) UIControl *repairCtl;
@property(strong, nonatomic) UIButton  *repairBtn;
@property(strong, nonatomic) UILabel  *repairLab;

//建议
@property(strong, nonatomic) UIControl *adviceCtl;
@property(strong, nonatomic) UIButton  *adviceBtn;
@property(strong, nonatomic) UILabel  *adviceLab;

@end
