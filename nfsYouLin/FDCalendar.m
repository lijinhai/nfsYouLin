//
//  FDCalendar.m
//  FDCalendarDemo
//
//  Created by jinhai on 16/7/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FDCalendar.h"
#import "FDCalendarItem.h"

#define Weekdays @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
static NSDateFormatter *dateFormattor;

@interface FDCalendar () <UIScrollViewDelegate, FDCalendarItemDelegate>{
    
    NSDate *currentDate;
    NSDate *endDate;
}

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) FDCalendarItem *leftCalendarItem;
@property (strong, nonatomic) FDCalendarItem *centerCalendarItem;
@property (strong, nonatomic) FDCalendarItem *rightCalendarItem;
@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation FDCalendar

- (instancetype)initWithCurrentDate:(NSDate *)date {
    if (self = [super init]) {
        self.backgroundColor =[UIColor clearColor];
        
        self.date = date;
        [self setupWeekHeader];
        [self setupCalendarItems];
        [self setupScrollView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, CGRectGetMaxY(self.scrollView.frame))];
        [self setCurrentDate:self.date];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame: self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
        
    }
    
    [self addSubview:_backgroundView];
    
    return _backgroundView;
}

#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date {
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"MM-yyyy"];
    }
    return [dateFormattor stringFromDate:date];
}


// 设置星期文字的显示
- (void)setupWeekHeader {
    NSInteger count = [Weekdays count];
    CGFloat offsetX =12;
    
    UIView *weekdayBackgroundView = [[UIView alloc] init];
    weekdayBackgroundView.backgroundColor = RGBAlpha(238, 232, 170, 0.6);
    weekdayBackgroundView.frame = CGRectMake(0, 10, 365, 20);
    [self addSubview:weekdayBackgroundView];
    
    for (int i = 0; i < count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, (DeviceWidth-20) / count, 20)];
         weekdayLabel.textAlignment = NSTextAlignmentCenter;
         weekdayLabel.text = Weekdays[i];
         weekdayLabel.font = [UIFont systemFontOfSize:14];
         weekdayLabel.backgroundColor = [UIColor clearColor];
         weekdayLabel.textColor       = RGB(255, 140, 0);
        [weekdayBackgroundView addSubview:weekdayLabel];
        offsetX += weekdayLabel.frame.size.width;
    }
}

// 设置包含日历的item的scrollView
- (void)setupScrollView {
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.scrollView setFrame:CGRectMake(0, 25, DeviceWidth, self.centerCalendarItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * 2, 0);
    [self addSubview:self.scrollView];
    
}

// 设置3个日历的item
- (void)setupCalendarItems {
    self.scrollView = [[UIScrollView alloc] init];
    /*发起网络请求，获取签到对象*/
    
    /*****/
    self.leftCalendarItem = [[FDCalendarItem alloc] init];
    self.leftCalendarItem.signedArray=@[@"12",@"13",@"14",@"9",@"8",@"20"];
    CGRect itemFrame = self.leftCalendarItem.frame;
    itemFrame.origin.x = 0;
    self.leftCalendarItem.frame = itemFrame;
    [self.scrollView addSubview:self.leftCalendarItem];
    
    itemFrame.origin.x = DeviceWidth;
    
    self.centerCalendarItem = [[FDCalendarItem alloc] init];
    self.centerCalendarItem.signedArray=@[@"1",@"15",@"16",@"19",@"18",@"20"];
    self.centerCalendarItem.frame = itemFrame;
    self.centerCalendarItem.delegate = self;
    [self.scrollView addSubview:self.centerCalendarItem];
    
    itemFrame.origin.x = DeviceWidth *2 ;
    
    self.rightCalendarItem = [[FDCalendarItem alloc] init];
    self.rightCalendarItem.signedArray=@[@"2",@"3",@"4",@"9",@"8",@"30"];
    self.rightCalendarItem.frame = itemFrame;
    [self.scrollView addSubview:self.rightCalendarItem];
}

// 设置当前日期，初始化
- (void)setCurrentDate:(NSDate *)date {
    
    self.rightCalendarItem.date = date;//当前月份
    self.centerCalendarItem.date = [self.rightCalendarItem previousMonthDate];//前一个月
    self.leftCalendarItem.date = [self.rightCalendarItem lastMonthDate];//前二个月
}



- (NSDate *)endMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -2;
    NSDate *endMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return endMonthDate;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
}

#pragma mark - FDCalendarItemDelegate

- (void)calendarItem:(FDCalendarItem *)item didSelectedDate:(NSDate *)date {
    self.date = date;
    [self setCurrentDate:self.date];
}

@end
