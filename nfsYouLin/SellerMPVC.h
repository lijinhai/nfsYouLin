//
//  SellerMPVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerMPVC : UIViewController
@property (nonatomic, strong) UILabel *typeRL;
@property (nonatomic, strong) UIControl *typeCL;

@property (nonatomic, strong) UILabel *orderRL;
@property (nonatomic, strong) UIControl *orderCL;
@property (nonatomic, strong) UIImageView *leftUpArrowIV;
@property (nonatomic, strong) UIImageView *leftDownArrowIV;
@property (nonatomic, strong) UIImageView *rightUpArrowIV;
@property (nonatomic, strong) UIImageView *rightDownArrowIV;
@property (nonatomic, strong) UITextField* searchTF;
@property (nonatomic, strong) UIControl* backView;
//刷新子ViewController
-(void)refreshChildViewController;
@end
