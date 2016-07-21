//
//  PopupCalendarView.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/12.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupCalendarView : UIView
@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
+ (instancetype)defaultPopupView:(NSInteger) todayPoint tFrame:(CGRect)frame;
@end
