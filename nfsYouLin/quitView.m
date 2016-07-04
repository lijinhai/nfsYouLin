//
//  quitView.m
//  nfsYouLin
//
//  Created by jinhai on 16/6/30.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "quitView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"


@implementation quitView{

    UILabel *tipInfo;
    UIButton *quitLoginBtn;
    UIButton *cancelBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    //[self addSubview:quitChooseTable];
    /*提示说明信息*/
    tipInfo=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 50)];
    tipInfo.text=@"退出当前账号后，不会删除任何历史数据，下\n次登录仍可以使用本账户";
    tipInfo.textColor=[UIColor lightGrayColor];
    tipInfo.numberOfLines=0;
    tipInfo.textAlignment=NSTextAlignmentCenter;
    /*退出按钮*/
    quitLoginBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 80, self.frame.size.width-20, 40)];
   [quitLoginBtn setTitle:@"退出登录" forState:UIControlStateNormal];

    quitLoginBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    quitLoginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [quitLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quitLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    quitLoginBtn.tintColor=[UIColor whiteColor];
    quitLoginBtn.layer.cornerRadius=5.0f;
    quitLoginBtn.backgroundColor=[UIColor redColor];
    [quitLoginBtn addTarget:self action:@selector(toggleQuitButton) forControlEvents: UIControlEventTouchUpInside];
    /*取消按钮*/
    cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 140, self.frame.size.width-20, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    cancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cancelBtn.tintColor=[UIColor whiteColor];
    cancelBtn.layer.cornerRadius=5.0f;
    cancelBtn.backgroundColor=[UIColor darkGrayColor];
    [cancelBtn addTarget:self action:@selector(toggleCancelButton) forControlEvents: UIControlEventTouchUpInside];

    /*定义view*/
    _bGView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 205)];
    _bGView.backgroundColor=[UIColor whiteColor];
    [_bGView addSubview:tipInfo];
    [_bGView addSubview:quitLoginBtn];
    [_bGView addSubview:cancelBtn];
    
    [self addSubview:_bGView];
    return self;
}

-(void)toggleQuitButton{


    NSLog(@"退出登录");
    [self dismissMyTable];
}

-(void)toggleCancelButton{
    
    
    NSLog(@"取消");
    [self dismissMyTable];
}

+ (instancetype)defaultPopupView{
    return [[quitView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 205)];
}

-(void) dismissMyTable{
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSlide new]];
}


@end

