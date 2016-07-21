//
//  quitView.h
//  nfsYouLin
//
//  Created by jinhai on 16/6/30.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface quitView : UIView
@property (nonatomic, weak)UIViewController *parentVC;
@property (nonatomic, strong)UIView *bGView;
@property(nonatomic,retain) NSString *passValue;
@property (nonatomic, strong)UIButton *logoutBtn;
@property (nonatomic, strong)UIButton *cancelBtn;

+ (instancetype)defaultPopupView;

@end
