//
//  PopupCalendarView.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/12.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PopupCalendarView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationRight.h"
#import "FMDB.h"
#import "MBProgressHUD.h"
#import "FDCalendar.h"
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@implementation PopupCalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame  todayIntegralValue:(NSInteger) todayPoint
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=8.0;
    UILabel *showTodayPointsInfo=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 20)];
    
    NSString *pointString=[NSString stringWithFormat: @"%ld", todayPoint];
    NSString *pointsInfo=[NSString stringWithFormat:@"%@%@%@",@"今天已签过，已领",pointString,@"积分"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:pointsInfo];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:RGBAlpha(255, 140, 0, 1.0)
     
                          range:NSMakeRange(8, pointString.length)];
    showTodayPointsInfo.attributedText = AttributedStr;
    showTodayPointsInfo.font=[UIFont systemFontOfSize:16];
    showTodayPointsInfo.textAlignment=NSTextAlignmentCenter;
    [self addSubview:showTodayPointsInfo];
    

    /*加载日历*/
    FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    CGRect frame1 = CGRectMake(0, 40, 365, 360);
    frame.origin.y = 0;
    calendar.frame = frame1;
    [self addSubview:calendar];
    return self;
}

+ (instancetype)defaultPopupView:(NSInteger) todayPoint tFrame:(CGRect)frame{
    return [[PopupCalendarView alloc]initWithFrame:frame todayIntegralValue:todayPoint];
}

-(void)dismissMyView{
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
}

- (void)textToast:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window  animated:YES];
    
    // Set the annular determinate mode to show task progress.navigationController.view
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor=[UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.minSize=CGSizeMake(50, 50);
    hud.label.text = NSLocalizedString(tips, @"HUD message title");
    
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font= [UIFont systemFontOfSize:15];
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:0.8f];
}

@end
