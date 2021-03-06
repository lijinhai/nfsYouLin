//
//  DialogView.m
//  nfsYouLin
//
//  Created by Macx on 16/7/15.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DialogView.h"

@implementation DialogView
{
    NSInteger _numberOfLines;
    CGFloat _previousHeight;
    CGFloat maxHeight;
    CGFloat minHeight;
    UIView* parentView;
}




- (id) initWithFrame:(CGRect)frame View:(UIView*) view Flag:(NSString*) flag
{
    self = [super initWithFrame:frame];
    if(self)
    {
        parentView = view;
        if([flag isEqualToString:@"sayHi"])
        {
            [self initSayHiView:frame];

        }
        else if([flag isEqualToString:@"common"])
        {
            [self initCommonView:frame];
        }
        else if([flag isEqualToString:@"apply"])
        {
            [self initApplyView:frame];
        }
        else if([flag isEqualToString:@"cancelApply"])
        {
            [self initCancelApplyView:frame];
        }
        else if([flag isEqualToString:@"deleteRepair"])
        {
            [self initDeleteRepairView:frame];
        }
        else if([flag isEqualToString:@"bussnessName"])
        {
            
            [self showBussnessNameView:frame];
        }
        else if([flag isEqualToString:@"repairStatus"])
        {
        
            [self updateRepairStatusView:frame];
        }
        
    }
    
    return self;
    
}

// 打招呼
- (void) initSayHiView: (CGRect) frame
{
    self.backgroundColor = [UIColor clearColor];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 16 * 15) / 2, (frame.size.height - 80) / 2, 16 * 15, 100)];
    self.backView.backgroundColor = [UIColor lightGrayColor];
    
    self.sayHiTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 16 * 15, 50)];
    self.sayHiTV.backgroundColor = [UIColor whiteColor];
    self.sayHiTV.font = [UIFont systemFontOfSize:16];
    self.sayHiTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.sayHiTV.bounces = NO;
    self.sayHiTV.scrollEnabled = NO;
    self.sayHiTV.delegate = self;
//    self.sayHiTV.returnKeyType = UIReturnKeySend;
    _previousHeight = ceilf([self.sayHiTV sizeThatFits:self.sayHiTV.frame.size].height);
    maxHeight = 20 * _previousHeight;
    minHeight = _previousHeight;
    [self.backView addSubview:self.sayHiTV];
    
    self.send = [[UIButton alloc] initWithFrame:CGRectMake(0, 51, self.backView.frame.size.width / 2 - 0.5, 49)];
    [self.send setTitle:@"发送" forState:UIControlStateNormal];
    self.send.backgroundColor = [UIColor whiteColor];
    [self.send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
//    [self.send addTarget:self action:@selector(sendBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.send addTarget:self action:@selector(sendColor:) forControlEvents:UIControlEventTouchDown];
    [self.backView addSubview:self.send];
    
    
    self.cancel = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width / 2 + 0.5 , 51, self.backView.frame.size.width / 2 - 0.5, 49)];
    [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
    self.cancel.backgroundColor = [UIColor whiteColor];
    [self.cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.cancel addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.cancel addTarget:self action:@selector(cancelColor:) forControlEvents:UIControlEventTouchDown];
    
    [self.backView addSubview:self.cancel];
    [self addSubview:self.backView];

}


// 通用对话框 删除  放弃
- (void) initCommonView: (CGRect) frame 
{
    self.backgroundColor = [UIColor clearColor];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(60, (frame.size.height - 80) / 2, frame.size.width - 120, 80)];
    self.backView.backgroundColor = [UIColor lightGrayColor];
    
    UIView* titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame), 40)];
    titleV.backgroundColor = [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    [self.backView addSubview:titleV];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(titleV.frame) - 20, 40)];
//    self.titleL.text = @"xxxxx";
    self.titleL.font = [UIFont systemFontOfSize:15];
    self.titleL.textColor = [UIColor whiteColor];
    [titleV addSubview:self.titleL];
    
    self.OKbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 41, CGRectGetWidth(self.backView.frame) / 2 - 0.5, 39)];
    [self.OKbtn setTitle:@"确定" forState:UIControlStateNormal];
    self.OKbtn.backgroundColor = [UIColor whiteColor];
    [self.OKbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backView addSubview:self.OKbtn];
    self.NOBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.backView.frame) / 2 + 0.5 , 41, CGRectGetWidth(self.backView.frame) / 2 - 0.5, 39)];
    [self.NOBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.NOBtn.backgroundColor = [UIColor whiteColor];
    [self.NOBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backView addSubview:self.NOBtn];
    [self addSubview:self.backView];
    
    
}





// 报名
- (void) initApplyView: (CGRect) frame
{
    self.backgroundColor = [UIColor clearColor];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(30, (frame.size.height - 180) / 2, frame.size.width - 60, 201)];
    self.backView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame), 40)];

    title.backgroundColor = [UIColor whiteColor];
    title.text = @"我要报名";
    title.textColor = [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    title.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:title];
    
    UILabel* adultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame), 55, 55)];
    adultLabel.text = @"成年人";
    adultLabel.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:adultLabel];
    
    UILabel* childLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(adultLabel.frame), 55, 55)];
    childLabel.text = @"儿童";
    childLabel.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:childLabel];

    UIImageView* adultIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(adultLabel.frame) + 80, CGRectGetMaxY(title.frame) + 12.5, 30, 30)];
    adultIV.layer.masksToBounds = YES;
    adultIV.layer.cornerRadius = 15;
    adultIV.image = [UIImage imageNamed:@"icon_chengren.png"];
    
    
    UIImageView* childIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(childLabel.frame) + 80, CGRectGetMaxY(adultLabel.frame) + 12.5, 30, 30)];
    childIV.layer.masksToBounds = YES;
    childIV.layer.cornerRadius = 15;
    childIV.image = [UIImage imageNamed:@"icon_ertong.png"];

    [self.backView addSubview:adultIV];
    [self.backView addSubview:childIV];
    
    
    self.adultTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(adultIV.frame) + 10, CGRectGetMinY(adultLabel.frame) + 15, 80, 25)];
    self.adultTF.text = @"1";
    self.adultTF.textAlignment = NSTextAlignmentCenter;
    self.adultTF.backgroundColor = [UIColor whiteColor];
    self.adultTF.keyboardType = UIKeyboardTypeNumberPad;
    self.adultTF.delegate = self;

    
    self.childTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(childIV.frame) + 10, CGRectGetMinY(childLabel.frame) + 15, 80, 25)];
    self.childTF.text = @"1";
    self.childTF.textAlignment = NSTextAlignmentCenter;
    self.childTF.backgroundColor = [UIColor whiteColor];
    self.childTF.keyboardType = UIKeyboardTypeNumberPad;
    self.childTF.delegate = self;

    
    [self.backView addSubview:self.adultTF];
    [self.backView addSubview:self.childTF];

    UIButton *adultPlusBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.adultTF.frame) + 10, CGRectGetMinY(adultLabel.frame) + 15, 25, 25)];
    [adultPlusBtn setBackgroundImage:[UIImage imageNamed:@"btn_jia_n.png"] forState:UIControlStateNormal];
    [adultPlusBtn addTarget:self action:@selector(adultPlus) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *adultSubBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(adultPlusBtn.frame) + 10, CGRectGetMinY(adultPlusBtn.frame), 25, 25)];
    [adultSubBtn addTarget:self action:@selector(adultSub) forControlEvents:UIControlEventTouchUpInside];
    [adultSubBtn setBackgroundImage:[UIImage imageNamed:@"btn_jian_n.png"] forState:UIControlStateNormal];

    
    
    UIButton *childPlusBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.childTF.frame) + 10, CGRectGetMinY(childLabel.frame) + 15, 25, 25)];
    [childPlusBtn setBackgroundImage:[UIImage imageNamed:@"btn_jia_n.png"] forState:UIControlStateNormal];
    [childPlusBtn addTarget:self action:@selector(childPlus) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *childSubBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(childPlusBtn.frame) + 10, CGRectGetMinY(childPlusBtn.frame), 25, 25)];
    [childSubBtn setBackgroundImage:[UIImage imageNamed:@"btn_jian_n.png"] forState:UIControlStateNormal];
    [childSubBtn addTarget:self action:@selector(childSub) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backView addSubview:adultPlusBtn];
    [self.backView addSubview:adultSubBtn];
    [self.backView addSubview:childPlusBtn];
    [self.backView addSubview:childSubBtn];

    
    
     self.applyYes = [[UIButton alloc] initWithFrame:CGRectMake(0,  151, CGRectGetWidth(self.backView.frame) / 2 - 0.5, 50)];
    [self.applyYes setTitle:@"确定" forState:UIControlStateNormal];
     self.applyYes.backgroundColor = [UIColor whiteColor];
    [self.applyYes setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
     self.applyNo = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.applyYes.frame) + 1,  151, CGRectGetWidth(self.backView.frame) / 2 - 0.5, 50)];
    [self.applyNo setTitle:@"取消" forState:UIControlStateNormal];
     self.applyNo.backgroundColor = [UIColor whiteColor];
    [self.applyNo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backView addSubview:self.applyYes];
    [self.backView addSubview:self.applyNo];
    [self addSubview:self.backView];

    
}

// 取消报名
- (void) initCancelApplyView: (CGRect) frame
{
    self.backgroundColor = [UIColor clearColor];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(60, (frame.size.height - 80) / 2, frame.size.width - 120, 80)];
    self.backView.backgroundColor = [UIColor lightGrayColor];
    
    self.cancelApplyTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame), 40)];
    self.cancelApplyTV.font = [UIFont systemFontOfSize:15];
    self.cancelApplyTV.textAlignment = NSTextAlignmentCenter;
    self.cancelApplyTV.text = @"请确认是否取消报名";
    self.cancelApplyTV.editable = NO;
    self.cancelApplyTV.bounces = NO;
    self.cancelApplyTV.textColor = [UIColor blackColor];
    
    
    [self.backView addSubview:self.cancelApplyTV];
    
    self.cancelApplyYes = [[UIButton alloc] initWithFrame:CGRectMake(0, 41, CGRectGetWidth(self.backView.frame) / 2 - 0.5, 39)];
    [self.cancelApplyYes setTitle:@"确定" forState:UIControlStateNormal];
     self.cancelApplyYes.backgroundColor = [UIColor whiteColor];
    [self.cancelApplyYes setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backView addSubview:self.cancelApplyYes];
    
    
     self.cancelApplyNo = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.backView.frame) / 2 + 0.5 , 41, CGRectGetWidth(self.backView.frame) / 2 - 0.5, 39)];
    [self.cancelApplyNo setTitle:@"取消" forState:UIControlStateNormal];
     self.cancelApplyNo.backgroundColor = [UIColor whiteColor];
    [self.cancelApplyNo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backView addSubview:self.cancelApplyNo];
    [self addSubview:self.backView];
}

//更新报修状态
-(void)updateRepairStatusView:(CGRect) frame
{

    self.backgroundColor = [UIColor clearColor];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(60, (frame.size.height - 80) / 2, frame.size.width - 120, 80)];
    self.backView.backgroundColor = [UIColor lightGrayColor];
    
    self.repairTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame), 40)];
    self.repairTV.font = [UIFont systemFontOfSize:15];
    self.repairTV.textAlignment = NSTextAlignmentCenter;
    self.repairTV.text = @"是否更新当前进度";
    self.repairTV.editable = NO;
    self.repairTV.bounces = NO;
    self.repairTV.textColor = [UIColor blackColor];
    
    [self.backView addSubview:self.repairTV];
    
    self.repairNo = [[UIButton alloc] initWithFrame:CGRectMake(0, 41, CGRectGetWidth(self.backView.frame) / 2 - 0.5, 39)];
    [self.repairNo setTitle:@"取消" forState:UIControlStateNormal];
    self.repairNo.backgroundColor = [UIColor whiteColor];
    [self.repairNo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backView addSubview:self.repairNo];
    
    self.repairYes = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.backView.frame) / 2 + 0.5 , 41, CGRectGetWidth(self.backView.frame) / 2 - 0.5, 39)];
    [self.repairYes setTitle:@"确定" forState:UIControlStateNormal];
    [self.repairYes setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.repairYes.backgroundColor = [UIColor whiteColor];
    [self.repairYes setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backView addSubview:self.repairYes];
    
    [self addSubview:self.backView];

}
// 删除报修
- (void) initDeleteRepairView: (CGRect) frame
{
  //OneBtn  AllBtn
    self.backgroundColor = [UIColor clearColor];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(60, (frame.size.height - 80) / 2, frame.size.width - 120, 80)];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.OneCtl=[[UIControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame), 40)];
    self.OneCtl.backgroundColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    self.OneLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame), 40)];
    self.OneLab.text=@"删除";
    self.OneLab.textAlignment=NSTextAlignmentCenter;
    self.OneLab.textColor=[UIColor whiteColor];
   [self.OneCtl addSubview:_OneLab];
    
    self.AllCtl=[[UIControl alloc] initWithFrame:CGRectMake(0, 41, CGRectGetWidth(self.backView.frame), 39)];
    self.AllCtl.backgroundColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    self.AllLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame), 40)];
    self.AllLab.text=@"删除全部";
    self.AllLab.textAlignment=NSTextAlignmentCenter;
    self.AllLab.textColor=[UIColor whiteColor];
   [self.AllCtl addSubview:_AllLab];
   [self.backView addSubview:_AllCtl];
   [self.backView addSubview:_OneCtl];
   [self addSubview:self.backView];


}
//展示详细商家地址框
-(void)showBussnessNameView:(CGRect)frame{

    self.backgroundColor = [UIColor clearColor];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(50, (frame.size.height - 80) / 2, frame.size.width - 100, 100)];
    self.backView.backgroundColor = [UIColor lightGrayColor];
    
    UIView* titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame), 60)];
    titleV.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:titleV];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(titleV.frame) - 20, 60)];
    self.titleL.font = [UIFont systemFontOfSize:16];
    self.titleL.numberOfLines = 2;
    self.titleL.textColor = [UIColor blackColor];
    [titleV addSubview:self.titleL];
    
     self.OKbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 61, CGRectGetWidth(self.backView.frame), 39)];
    [self.OKbtn setTitle:@"确定" forState:UIControlStateNormal];
     self.OKbtn.backgroundColor = [UIColor whiteColor];
    [self.OKbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backView addSubview:self.OKbtn];
    [self addSubview:self.backView];

}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(parentView)
    {
        [parentView removeFromSuperview];
    }
    [self removeFromSuperview];
}



- (void) textViewDidChange:(UITextView *)textView
{
    CGFloat toHeight = ceilf([textView sizeThatFits:textView.frame.size].height);
    
    
    if(textView.text.length >= 200)
    {
        textView.text = [textView.text substringToIndex:200];
        return;
    }
    
    
    if(toHeight == _previousHeight)
    {
        return;
    }
    
    if (toHeight < minHeight) {
        toHeight = minHeight;
    }
    if (toHeight > maxHeight) {
        toHeight = maxHeight;
    }
    
    
  
    
    CGFloat changeHeight = toHeight - _previousHeight;
    
    CGFloat textViewW = CGRectGetWidth(textView.frame);
    CGFloat textViewH = CGRectGetHeight(textView.frame);
    
    CGRect textViewFrame = textView.frame;
    
    textViewFrame.size = CGSizeMake(textViewW, toHeight);
    textView.frame= textViewFrame;
    if(changeHeight > 0)
    {
        textViewFrame.size = CGSizeMake(textViewW, textViewH);
        textView.frame= textViewFrame;
    }
    else
    {
        textViewFrame.size = CGSizeMake(textViewW, _previousHeight + 14);
        textView.frame= textViewFrame;
    }
    _previousHeight = toHeight;
    
    
    CGFloat backViewX = self.backView.frame.origin.x;
    CGFloat backViewY = self.backView.frame.origin.y;
    CGFloat backViewW = self.backView.frame.size.width;
    CGFloat backViewH = self.backView.frame.size.height + changeHeight;
    self.backView.frame = CGRectMake(backViewX,backViewY, backViewW, backViewH);
    
    
    CGFloat sendX = self.send.frame.origin.x;
    CGFloat sendY = self.send.frame.origin.y + changeHeight;
    CGFloat sendW = self.send.frame.size.width;
    CGFloat sendH = self.send.frame.size.height;
    self.send.frame = CGRectMake(sendX, sendY, sendW, sendH);
    
    CGFloat cancelX = self.cancel.frame.origin.x;
    CGFloat cancelY = self.cancel.frame.origin.y + changeHeight;
    CGFloat cancelW = self.cancel.frame.size.width;
    CGFloat cancelH = self.cancel.frame.size.height;
    self.cancel.frame = CGRectMake(cancelX, cancelY, cancelW, cancelH);
    
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.backView.frame;
        CGPoint point = frame.origin;
        point.y = 80;
        frame.origin = point;
        self.backView.frame = frame;
        
    }];
}


- (void)deleteYColor: (id) sender
{
}

- (void)deleteNColor: (id) sender
{
    
}

- (void) deleteYBtn:(id) sender
{
    NSLog(@"deleteY");
}

- (void) deleteNBtn:(id) sender
{
    NSLog(@"delete");
    if(parentView)
    {
        [parentView removeFromSuperview];
    }
    [self removeFromSuperview];
}


- (void)sendColor: (id) sender
{
    //    self.send.backgroundColor = [UIColor colorWithRed:224.0 /255.0 green:244.0/255.0 blue:224.0 /255.0 alpha:1];
}

- (void)cancelColor: (id) sender
{
    //    self.cancel.backgroundColor = [UIColor colorWithRed:224.0 /255.0 green:244.0/255.0 blue:224.0 /255.0 alpha:1];
}

- (void) sendBtn:(id) sender
{
    NSLog(@"send");
}

- (void) cancelBtn:(id) sender
{
    //    self.cancel.backgroundColor = [UIColor whiteColor];
    NSLog(@"cancel");
    if(parentView)
    {
        [parentView removeFromSuperview];
    }
    [self removeFromSuperview];
}

- (void)adultPlus
{
    NSInteger num = [self.adultTF.text integerValue];
    if(num >= 60000)
    {
        self.adultTF.text = @"60000";
        return;
    }
    
    num ++;
    self.adultTF.text = [NSString stringWithFormat:@"%ld",num];
        
}


- (void)adultSub
{
    NSInteger num = [self.adultTF.text integerValue];
    if(num <= 0)
    {
        self.adultTF.text = @"0";
        return;
    }
    
    num --;
    self.adultTF.text = [NSString stringWithFormat:@"%ld",num];
    
}

- (void)childPlus
{
    NSInteger num = [self.childTF.text integerValue];
    if(num >= 60000)
    {
        self.childTF.text = @"60000";
        return;
    }
    
    num ++;
    self.childTF.text = [NSString stringWithFormat:@"%ld",num];
    
}

- (void)childSub
{
    NSInteger num = [self.childTF.text integerValue];
    if(num <= 0)
    {
        self.childTF.text = @"0";
        return;
    }
    
    num --;
    self.childTF.text = [NSString stringWithFormat:@"%ld",num];
    
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = [textField.text integerValue];
    if (num >= 60000)
    {
        textField.text = @"60000";
        return NO;
    }
    
    return YES;
}

@end
