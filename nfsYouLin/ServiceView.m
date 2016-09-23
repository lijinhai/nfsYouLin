//
//  ServiceView.m
//  nfsYouLin
//
//  Created by Macx on 16/9/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ServiceView.h"
#import "HeaderFile.h"
#import "StringMD5.h"

#define FONT [UIFont systemFontOfSize:15]

@implementation ServiceView
{
    UIImageView* _titleIV;
    
    // 办公地址
    UIImageView* _addressIV;
    UILabel* _addressL;
    
    // 办公时间
    UIImageView* _workTimeIV;
    UILabel* _workTimeL;
    
    // 服务电话
    UIImageView* _phoneIV;
    UILabel* _phoneL;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.5;
        self.layer.cornerRadius = 10;
        
        UIImageView* titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) * 0.5 - 40, 25, 80, 80)];
        titleIV.layer.masksToBounds = YES;
        titleIV.layer.cornerRadius = 40;
//        titleIV.image = [UIImage imageNamed:@"pic_juweihui.png"];
        [self addSubview: titleIV];
        _titleIV = titleIV;
        
        UIImageView* addressIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleIV.frame) + 25, 20, 20)];
//        addressIV.image = [UIImage imageNamed:@"pic_dizhi.png"];
        addressIV.layer.cornerRadius = 3;
        [self addSubview:addressIV];
        _addressIV = addressIV;
        
        
        CGSize addrTSize = [StringMD5 sizeWithString:@"地址：" font:FONT maxSize:CGSizeMake(screenWidth, 20)];
        UILabel* addressTag = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressIV.frame) + 10, CGRectGetMinY(addressIV.frame), addrTSize.width, 20)];
        addressTag.text = @"地址：";
        addressTag.font = FONT;
        [self addSubview:addressTag];
        
        UILabel* addressL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressTag.frame), CGRectGetMinY(addressIV.frame), CGRectGetWidth(self.frame) - 60 - addrTSize.width, 20)];
        
        addressL.userInteractionEnabled = YES;
        UITapGestureRecognizer* addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapGesture:)];
        [addressL addGestureRecognizer:addressTap];
        
        UILongPressGestureRecognizer* addressLongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addressLongGesture:)];
        addressLongTap.minimumPressDuration = 1;
        [addressL addGestureRecognizer:addressLongTap];
        
        addressL.text = @"哈尔滨市松北区科技创新城133号";
        addressL.font = FONT;
        addressL.numberOfLines = 0;
        [self addSubview:addressL];
        _addressL = addressL;
        
        UIImageView* timeIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(addressIV.frame) + 25, 20, 20)];
        timeIV.layer.cornerRadius = 3;
//        timeIV.image = [UIImage imageNamed:@"pic_shijian.png"];
        _workTimeIV = timeIV;
        [self addSubview:timeIV];
        
        CGSize timeTSize = [StringMD5 sizeWithString:@"办公时间：" font:FONT maxSize:CGSizeMake(screenWidth,20)];
        UILabel* timeTag = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeIV.frame) + 10, CGRectGetMinY(timeIV.frame), timeTSize.width,20)];
        timeTag.text = @"办公时间：";
        timeTag.font = FONT;
        [self addSubview:timeTag];
        
        UILabel* timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeTag.frame), CGRectGetMinY(timeIV.frame), CGRectGetWidth(self.frame) - 60 - timeTSize.width, 20)];
        
        timeL.userInteractionEnabled = YES;
        UITapGestureRecognizer* timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeTapGesture:)];
        [timeL addGestureRecognizer:timeTap];
        
        UILongPressGestureRecognizer* timeLongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(timeLongGesture:)];
        timeLongTap.minimumPressDuration = 0.5;
        [timeL addGestureRecognizer:timeLongTap];
        
        timeL.text = @"每周一至周五8:00-18:00";
        timeL.font = FONT;
        timeL.numberOfLines = 0;
        [self addSubview:timeL];
        _workTimeL = timeL;

        
        UIImageView* phoneIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(timeIV.frame) + 25, 20, 20)];
        phoneIV.layer.cornerRadius = 3;
//        phoneIV.image = [UIImage imageNamed:@"pic_dianhua.png"];
        _phoneIV = phoneIV;
        [self addSubview:phoneIV];
        
        CGSize phoneTSize = [StringMD5 sizeWithString:@"服务电话：" font:FONT maxSize:CGSizeMake(screenWidth,20)];
        UILabel* phoneTag = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneIV.frame) + 10,CGRectGetMinY(phoneIV.frame),phoneTSize.width, 20)];
        phoneTag.text = @"服务电话：";
        phoneTag.font = FONT;
        [self addSubview:phoneTag];
    
        UILabel* phoneL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneTag.frame), CGRectGetMinY(phoneIV.frame), CGRectGetWidth(self.frame) - 60 - phoneTSize.width , 20)];
        
        phoneL.userInteractionEnabled = YES;
        UITapGestureRecognizer* phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTapGesture:)];
        [phoneL addGestureRecognizer:phoneTap];

        
        phoneL.text = @"151-1459-9422";
        phoneL.textAlignment = NSTextAlignmentLeft;
        phoneL.textColor = [UIColor redColor];
        phoneL.font = FONT;
        [self addSubview:phoneL];
        _phoneL = phoneL;
    }
    return self;
}


#pragma mark -设置社区服务数据
- (void)setServiceInfo:(NSDictionary *)serviceInfo
{
    _serviceInfo = serviceInfo;
    NSString* department = [_serviceInfo valueForKey:@"service_department"];
    NSString* phone = [_serviceInfo valueForKey:@"service_phone"];
    NSString* hours = [_serviceInfo valueForKey:@"service_office_hours"];
    NSString* address = [_serviceInfo valueForKey:@"service_address"];
    
    _addressL.text = address;
    _workTimeL.text = hours;
    _phoneL.text = phone;
    
    if([department isEqualToString:@"居委会"])
    {
        _titleIV.image = [UIImage imageNamed:@"pic_juweihui.png"];
        _addressIV.image = [UIImage imageNamed:@"pic_dizhi.png"];
        _workTimeIV.image = [UIImage imageNamed:@"pic_shijian.png"];
        _phoneIV.image = [UIImage imageNamed:@"pic_dianhua.png"];
        _phoneL.textColor = [UIColor redColor];
    }
    else if([department isEqualToString:@"卫生所"])
    {
        _titleIV.image = [UIImage imageNamed:@"pic_weishengsuo.png"];
        _addressIV.image = [UIImage imageNamed:@"pic_dizhi2.png"];
        _workTimeIV.image = [UIImage imageNamed:@"pic_shijian2.png"];
        _phoneIV.image = [UIImage imageNamed:@"pic_dianhua2.png"];
        _phoneL.textColor = [UIColor blueColor];

    }
    else if([department isEqualToString:@"派出所"])
    {
        _titleIV.image = [UIImage imageNamed:@"pic_paichusuo.png"];
        _addressIV.image = [UIImage imageNamed:@"pic_dizhi3.png"];
        _workTimeIV.image = [UIImage imageNamed:@"pic_shijian3.png"];
        _phoneIV.image = [UIImage imageNamed:@"dianhuayellow.png"];
        _phoneL.textColor = MainColor;
    }
    
}


#pragma mark -地址触摸手势
- (void)addressTapGesture: (UITapGestureRecognizer*) gesture
{
    [_delegate selectedServiceAddress:_addressL.text];
}

#pragma mark -地址长按手势
- (void)addressLongGesture: (UILongPressGestureRecognizer*) gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [_delegate selectedLongServiceAddress:_addressL.text];
    }
}

#pragma mark -时间触摸手势
- (void)timeTapGesture: (UITapGestureRecognizer*) gesture
{
    [_delegate selectedServiceTime:_workTimeL.text];
}

#pragma mark -时间长按手势
- (void)timeLongGesture: (UILongPressGestureRecognizer*) gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [_delegate selectedLongServiceTime:_workTimeL.text];
    }
}

#pragma mark -服务电话触摸手势
- (void)phoneTapGesture: (UITapGestureRecognizer*) gesture
{
    [_delegate selectedServicePhone:_phoneL.text];
}


@end
