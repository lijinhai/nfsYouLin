//
//  AboutYouLinViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/1.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutYouLinViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *yinsiLabel;
@property (weak, nonatomic) IBOutlet UILabel *youfanLabel;

@property (nonatomic, strong)UIView *checkUpdateView;
@property (weak, nonatomic) IBOutlet UIImageView *youlinIV;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@end
