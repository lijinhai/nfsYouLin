//
//  RectWaitView.m
//  nfsYouLin
//
//  Created by jinhai on 16/8/23.
//  Copyright © 2016年 jinhai. All rights reserved.
//
#define SCREEN_WIDTH   ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)
#import "RectWaitView.h"

@implementation RectWaitView{

    //UIView* backgroundView;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView*) initWithFrame:(CGRect)frame Title:(NSString *)title
{
    
   RectWaitView* backgroundView=[[RectWaitView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundView.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.4];
   
    UIView* viewb=[[UIView alloc] initWithFrame:CGRectMake(40, (CGRectGetHeight(frame) - 100)/ 2, CGRectGetWidth(frame)-80, 60)];
    viewb.backgroundColor=[UIColor whiteColor];
    viewb.layer.masksToBounds = YES;
    viewb.layer.cornerRadius = 3;
    viewb.alpha=1.0;
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(25, 8, 50, 50)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.color=[UIColor darkGrayColor];
    [indicator startAnimating];
    [viewb addSubview:indicator];
        
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 11, 120, 40)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [viewb addSubview:titleLabel];
    [backgroundView addSubview:viewb];
    return backgroundView;
    
}



@end
