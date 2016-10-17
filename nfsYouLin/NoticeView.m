//
//  NoticeView.m
//  nfsYouLin
//
//  Created by Macx on 2016/10/17.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NoticeView.h"
#import "HeaderFile.h"

@implementation NoticeView
{
    UIButton* waterBtn;
    UIButton* payBtn;
    UIButton* activityBtn;
    UIButton* otherBtn;
;

}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = BackgroundColor;
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(frame), 70)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        waterBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 100, 30)];
        [waterBtn addTarget:self action:@selector(noticeClicked:) forControlEvents:UIControlEventTouchUpInside];
        waterBtn.tag = 0;
        [waterBtn setImage:[UIImage imageNamed:@"btn_weixuanzhong.png"] forState:UIControlStateNormal];
        [waterBtn setImage:[UIImage imageNamed:@"btn_xuanzhong.png"] forState:UIControlStateHighlighted];
        [waterBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 90)];
        [waterBtn setTitle:@"停水通知" forState:UIControlStateNormal];
        [waterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:waterBtn];
        
        activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 40, 100, 30)];
        [activityBtn addTarget:self action:@selector(noticeClicked:) forControlEvents:UIControlEventTouchUpInside];
        activityBtn.tag = 1;
        [activityBtn setImage:[UIImage imageNamed:@"btn_weixuanzhong.png"] forState:UIControlStateNormal];
        [activityBtn setImage:[UIImage imageNamed:@"btn_xuanzhong.png"] forState:UIControlStateHighlighted];
        [activityBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 90)];
        [activityBtn setTitle:@"活动通知" forState:UIControlStateNormal];
        [activityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:activityBtn];
        
        payBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth * 0.5 + 30, 0, 100, 30)];
        [payBtn addTarget:self action:@selector(noticeClicked:) forControlEvents:UIControlEventTouchUpInside];
        payBtn.tag = 2;
        [payBtn setImage:[UIImage imageNamed:@"btn_weixuanzhong.png"] forState:UIControlStateNormal];
        [payBtn setImage:[UIImage imageNamed:@"btn_xuanzhong.png"] forState:UIControlStateHighlighted];
        [payBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 90)];
        [payBtn setTitle:@"缴费通知" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:payBtn];
        
        otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth * 0.5 + 30, 40, 100, 30)];
        [otherBtn addTarget:self action:@selector(noticeClicked:) forControlEvents:UIControlEventTouchUpInside];
        otherBtn.tag = 2;

        [otherBtn setImage:[UIImage imageNamed:@"btn_weixuanzhong.png"] forState:UIControlStateNormal];
        [otherBtn setImage:[UIImage imageNamed:@"btn_xuanzhong.png"] forState:UIControlStateHighlighted];
        [otherBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 90)];
        [otherBtn setTitle:@"其他" forState:UIControlStateNormal];
        [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [otherBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        [view addSubview:otherBtn];
    }
    return self;
}



- (void)noticeClicked:(UIButton*) button
{
    [_delegate seletedNotice:button.tag];
}

@end
