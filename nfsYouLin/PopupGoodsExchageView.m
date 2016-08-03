//
//  PopupGoodsExchageView.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/26.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PopupGoodsExchageView.h"
#import "UIViewController+LewPopupViewController.h"
#import "UIImageView+WebCache.h"
#import "LewPopupViewAnimationRight.h"
@implementation PopupGoodsExchageView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame arrayId:(NSInteger)goodsId allGoodsArray:(NSMutableArray *) goodsAry allPoints:(NSInteger)goodsPoints
{
    self=[super initWithFrame:frame];
    UIColor *fontColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    UIView *goodsPicView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 200)];
    goodsPicView.backgroundColor=[UIColor whiteColor];
    goodsPicView.layer.cornerRadius=5.0;
    goodsPicView.center=CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
    goodsPicView.tag=2008;
    UIImageView* goodsPic=[[UIImageView alloc] init];
    NSURL* url = [NSURL URLWithString:[[goodsAry objectAtIndex:goodsId] objectForKey:@"gl_pic"]];
    [goodsPic sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        goodsPic.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        goodsPic.center=CGPointMake(goodsPicView.frame.size.width/2, goodsPicView.frame.size.height/3);}];
    UILabel *goodsNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    goodsNameLabel.center=CGPointMake(goodsPicView.frame.size.width/2, goodsPicView.frame.size.height-15);
    goodsNameLabel.text=[[goodsAry objectAtIndex:goodsId] objectForKey:@"gl_name"];
    goodsNameLabel.textAlignment=NSTextAlignmentCenter;
    goodsNameLabel.font=[UIFont systemFontOfSize:14];
    goodsNameLabel.textColor=[UIColor lightGrayColor];
    [goodsPicView addSubview:goodsPic];
    [goodsPicView addSubview:goodsNameLabel];
    
    UIView *setGoodsCountView=[[UIView alloc] initWithFrame:CGRectMake(0 , 0, 160, 40)];
    setGoodsCountView.center=CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2+150);
    setGoodsCountView.backgroundColor=[UIColor whiteColor];
    setGoodsCountView.layer.cornerRadius=6.0;
    setGoodsCountView.tag=2009;
    setGoodsCountView.userInteractionEnabled=YES;
    /*左侧按钮*/
    self.leftBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.leftBtn.tag=111;
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_jia_n.png"] forState:UIControlStateNormal];
    [setGoodsCountView addSubview:self.leftBtn];
    
    /*右侧按钮*/
    self.rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(120, 0, 40, 40)];
    self.rightBtn.tag=110;
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_jian_n.png"] forState:UIControlStateNormal];
    [setGoodsCountView addSubview:self.rightBtn];
    
    /*竖线分隔*/
    UIView *verticalLine1 = [[UIView alloc]initWithFrame:CGRectMake(41, 0, 1, 40)];
    verticalLine1.backgroundColor = [UIColor grayColor];
    [setGoodsCountView addSubview:verticalLine1];
    UIView *verticalLine2 = [[UIView alloc]initWithFrame:CGRectMake(119, 0, 1, 40)];
    verticalLine2.backgroundColor = [UIColor grayColor];
    [setGoodsCountView addSubview:verticalLine2];
    /*货物数量*/
    _countTextField=[[UITextField alloc] initWithFrame:CGRectMake(42, 0, 78, 40)];
    _countTextField.text=@"1";
    _countTextField.font=[UIFont systemFontOfSize:16];
    _countTextField.textAlignment=NSTextAlignmentCenter;
    [setGoodsCountView addSubview:_countTextField];
    
    
    UIView *downPointsView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 45)];
    downPointsView.backgroundColor=[UIColor whiteColor];
    downPointsView.center=CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height-22.5);
    downPointsView.tag=2010;
    _totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width*3/4, 45)];
    int center_x = floor([[UIScreen mainScreen] bounds].size.width*3/8);
    int center_y = floor(22.5);
    _totalLabel.center=CGPointMake(center_x, center_y);
    
    NSString *tip=nil;
    self.sureBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width/4, 45)];
    self.sureBtn.center=CGPointMake([[UIScreen mainScreen] bounds].size.width*7/8, 22.5);
    self.sureBtn.tag=[[[goodsAry objectAtIndex:goodsId] objectForKey:@"gl_id"] intValue];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];

    if([[[goodsAry objectAtIndex:goodsId] objectForKey:@"gl_credit"] intValue]>goodsPoints)
    {
      tip=@"（你的积分未达到）";
      _sureBtn.backgroundColor=[UIColor lightGrayColor];
      _sureBtn.userInteractionEnabled=NO;
        
    }else{
    
     tip=@"";
    _sureBtn.backgroundColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    
    }
    NSString *jifenStr=@" 积分";
    NSString *pointsInfo=[NSString stringWithFormat:@"%@%@%@%@",@"合计：",[[goodsAry objectAtIndex:goodsId] objectForKey:@"gl_credit"],jifenStr,tip];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:pointsInfo];
    /*合计*/
    [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 3)];
    /*分数*/
    [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:fontColor}
                           range:NSMakeRange(3, pointsInfo.length-6-tip.length)];
    /*积分*/
    [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:fontColor}
                           range:NSMakeRange(pointsInfo.length-tip.length-3, 3)];
    
    /*tip*/
    if(tip.length>0)
    {
        [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}range:NSMakeRange(pointsInfo.length-tip.length, tip.length)];
    
    }
    _totalLabel.attributedText = AttributedStr;
    _totalLabel.textAlignment=NSTextAlignmentCenter;
    
    

    [downPointsView addSubview:_totalLabel];
    [downPointsView addSubview:self.sureBtn];

    _popupViewsArray=[[NSMutableArray alloc] init];
    [_popupViewsArray addObject:goodsPicView];
    [_popupViewsArray addObject:setGoodsCountView];
    [_popupViewsArray addObject:downPointsView];

    [self addSubview:goodsPicView];
    [self addSubview:setGoodsCountView];
    [self addSubview:downPointsView];
    
    return  self;
}



-(void) dismissPopupView{
    
    [_parentVC lew_dismissPopupViewsWithanimation:[LewPopupViewAnimationRight new]];
}


+ (instancetype)defaultPopupView:(CGRect)frame arrayId:(NSInteger)goodsID allGoodsArray:(NSMutableArray *) goodsAry allPoints:(NSInteger)goodsPoints{
    
    return [[PopupGoodsExchageView alloc]initWithFrame:frame arrayId:goodsID allGoodsArray:goodsAry allPoints:goodsPoints];
}

@end
