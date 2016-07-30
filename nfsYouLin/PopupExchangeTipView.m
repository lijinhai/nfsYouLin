//
//  PopupExchangeTipView.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/29.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PopupExchangeTipView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"

@implementation PopupExchangeTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor whiteColor];
    
    UIImageView *wenxinImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 45)];
    wenxinImageView.image=[UIImage imageNamed:@"pic_wenxintishi.png"];
    wenxinImageView.center=CGPointMake(50, 18);
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    titleLabel.center=CGPointMake(self.frame.size.width/2, 30);
    titleLabel.text=@"领取礼品通知";
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    UILabel *contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120)];
    contentLabel.numberOfLines=0;
    contentLabel.center=CGPointMake(self.frame.size.width/2, 90);

    NSString *labelText =@"    亲爱的用户您点击领取的礼品我们已收到通\n知，我们会在  每周五定时为您配送至您的小\n区，请这段时间内保持电话畅通，再次谢谢您\n参与到优邻这个大家庭，祝您生活愉快！";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    contentLabel.attributedText = attributedString;
    contentLabel.font=[UIFont systemFontOfSize:14];
    contentLabel.textAlignment=NSTextAlignmentCenter;
    
    [self addSubview:wenxinImageView];
    [self addSubview:titleLabel];
    [self addSubview:contentLabel];
    return self;
}


+ (instancetype)defaultPopupView{
    return [[PopupExchangeTipView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-100, 160)];
}

-(void) dismissMyTable{
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}


@end
