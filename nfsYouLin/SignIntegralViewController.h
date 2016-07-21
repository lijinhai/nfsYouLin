//
//  SignIntegralViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignIntegralViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *pleaseSignImage;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateRulerImageView;

@property (weak, nonatomic) IBOutlet UILabel *MONLabel;

@property (weak, nonatomic) IBOutlet UILabel *TUELabel;

@property (weak, nonatomic) IBOutlet UILabel *WEDLabel;

@property (weak, nonatomic) IBOutlet UILabel *THULabel;

@property (weak, nonatomic) IBOutlet UILabel *FRILabel;

@property (weak, nonatomic) IBOutlet UILabel *SATLabel;

@property (weak, nonatomic) IBOutlet UILabel *SUNLabel;
@property (nonatomic, strong) NSArray *nowWeekSignedArray;
@end
