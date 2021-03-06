//
//  FDCalendar.m
//  FDCalendarDemo
//
//  Created by jinhai on 16/7/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FDCalendar.h"
#import "FDCalendarItem.h"
#import "HeaderFile.h"

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

- (instancetype)initWithCurrentDate:(NSDate *)date  signArray:(NSMutableArray *)datearray {
    if (self = [super init]) {
        self.backgroundColor =[UIColor clearColor];
        
        self.date = date;
        [self getMonthArray:datearray];
        [self getSignMonthArray:datearray];
        [self setupWeekHeader];
        [self setupCalendarItems:[_dateMutablearray count]];
        [self setupScrollView:[_dateMutablearray count]];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, CGRectGetMaxY(self.scrollView.frame))];
        [self setCurrentDate:self.date];
    }
    return self;
}


- (void) getMonthArray:(NSMutableArray *)datearray{

    /*获取签到的年月*/
    NSMutableArray *arrayStr=[[NSMutableArray alloc] init];
    for(int i=0;i<[datearray count];i++)
    {
        NSArray *array = [[datearray objectAtIndex:i] componentsSeparatedByString:@"."];
        NSString *yearAndMonthStr=[NSString stringWithFormat:@"%@%@%@",array[0],@".",array[1]];
        [arrayStr addObject:yearAndMonthStr];
    }
    
    _dateMutablearray = [@[] mutableCopy];
    for (int i = 0; i < arrayStr.count; i ++) {
        
        NSString *string = arrayStr[i];
        
        NSMutableArray *tempArray = [@[] mutableCopy];
        
        [tempArray addObject:string];
        
        for (int j = i+1; j < arrayStr.count; j ++) {
            
            NSString *jstring = arrayStr[j];
            
            if([string isEqualToString:jstring]){
                
                [tempArray addObject:jstring];
                
                [arrayStr removeObjectAtIndex:j];
                j -= 1;
                
            }
            
        }
        
        [_dateMutablearray addObject:tempArray[0]];
    }
    
    
}

-(void) getSignMonthArray:(NSMutableArray *)datearray{
    
    _nowMonthSignedArray=[[NSMutableArray alloc] init];
    _previousMonthSignedArray=[[NSMutableArray alloc] init];
    _lastMonthSignedArray=[[NSMutableArray alloc] init];

    for(int i=0;i<[datearray count];i++)
    {
        NSArray *array = [[datearray objectAtIndex:i] componentsSeparatedByString:@"."];
        NSString *submonthStr=[NSString stringWithFormat:@"%@%@%@",array[0],@".",array[1]];

        if([_dateMutablearray count]==1)
        {
            [_nowMonthSignedArray addObject:array[2]];
    
        }else if([_dateMutablearray count]==2){
            
                if([submonthStr isEqualToString:_dateMutablearray[0]])
                {
                    
                    [_nowMonthSignedArray addObject:array[2]];
    
                }else{
    
                    
                    [_previousMonthSignedArray addObject:array[2]];
    
                }
            
        }else if([_dateMutablearray count]==3)
                {
                        
                        if([submonthStr isEqualToString:_dateMutablearray[0]])
                        {
                            
                           [_nowMonthSignedArray addObject:array[2]];
    
                        }else if([submonthStr isEqualToString:_dateMutablearray[1]]){
    
                            
                            [_previousMonthSignedArray addObject:array[2]];
    
                        }else if([submonthStr isEqualToString:_dateMutablearray[2]])
                        {
                            
                            [_lastMonthSignedArray addObject:array[2]];
                        }
                    
                }
    
            }
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
    CGFloat offsetX = 8;
    
    UIView *weekdayBackgroundView = [[UIView alloc] init];
    weekdayBackgroundView.backgroundColor = RGBAlpha(238, 232, 170, 0.6);
    weekdayBackgroundView.frame = CGRectMake(0, 10, screenWidth-40, 20);
    [self addSubview:weekdayBackgroundView];
    
    for (int i = 0; i < count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, (DeviceWidth-56) / count, 20)];
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
- (void)setupScrollView:(NSInteger) frameNum {
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
   [self.scrollView setFrame:CGRectMake(0, 25, DeviceWidth, self.centerCalendarItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(frameNum * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * (frameNum-1), 0);
    [self addSubview:self.scrollView];
    
}

// 设置3个日历的item
- (void)setupCalendarItems:(NSInteger) calendarNum {
    self.scrollView = [[UIScrollView alloc] init];
    if(calendarNum==3)
    {
        self.leftCalendarItem = [[FDCalendarItem alloc] init];
        self.leftCalendarItem.signedArray=_lastMonthSignedArray;
        CGRect itemFrame = self.leftCalendarItem.frame;
        itemFrame.origin.x = 0;
        self.leftCalendarItem.frame = itemFrame;
        [self.scrollView addSubview:self.leftCalendarItem];
        
        itemFrame.origin.x = DeviceWidth;
        self.centerCalendarItem = [[FDCalendarItem alloc] init];
        self.centerCalendarItem.signedArray=_previousMonthSignedArray;
        self.centerCalendarItem.frame = itemFrame;
        self.centerCalendarItem.delegate = self;
        [self.scrollView addSubview:self.centerCalendarItem];
        
        itemFrame.origin.x = DeviceWidth *2 ;
        self.rightCalendarItem = [[FDCalendarItem alloc] init];
        self.rightCalendarItem.signedArray=self.nowMonthSignedArray;
        self.rightCalendarItem.frame = itemFrame;
        [self.scrollView addSubview:self.rightCalendarItem];
    
    }else if(calendarNum==2){
    
        self.centerCalendarItem = [[FDCalendarItem alloc] init];
        CGRect itemFrame = self.centerCalendarItem.frame;
        itemFrame.origin.x = 0;
        self.centerCalendarItem.signedArray=_previousMonthSignedArray;
        self.centerCalendarItem.frame = itemFrame;
        self.centerCalendarItem.delegate = self;
        [self.scrollView addSubview:self.centerCalendarItem];
        
        itemFrame.origin.x = DeviceWidth ;
        self.rightCalendarItem = [[FDCalendarItem alloc] init];
        self.rightCalendarItem.signedArray=self.nowMonthSignedArray;
        self.rightCalendarItem.frame = itemFrame;
        [self.scrollView addSubview:self.rightCalendarItem];
    
    }else if(calendarNum==1){
    
       self.rightCalendarItem = [[FDCalendarItem alloc] init];
       CGRect itemFrame = self.rightCalendarItem.frame;
       itemFrame.origin.x = 0 ;
       self.rightCalendarItem.signedArray=self.nowMonthSignedArray;
        self.rightCalendarItem.frame = itemFrame;
        [self.scrollView addSubview:self.rightCalendarItem];
    
    }
    
   
}
-(NSMutableArray *) getStringByDate:(NSMutableArray *)datearray{
    
    NSMutableArray *monthStr=[[NSMutableArray alloc] init];
    for (int i=0;i<[datearray count];i++){
        
        
        NSString *datestring = [NSString stringWithFormat:@"%@",[datearray objectAtIndex:i]];
        NSDateFormatter * dm = [[NSDateFormatter alloc]init];
        [dm setDateFormat:@"yyyy.MM"];
        NSDate * newdate = [dm dateFromString:datestring];
        [monthStr addObject:newdate];
       
    }
    return monthStr;
}
// 设置当前日期，初始化
- (void)setCurrentDate:(NSDate *)date {
    
    NSMutableArray *monthAry=[self getStringByDate:_dateMutablearray];
    if([_dateMutablearray count]==3)
    {
     self.rightCalendarItem.date = date;//当前月份
     self.centerCalendarItem.date =[monthAry objectAtIndex:1];
     self.leftCalendarItem.date =[monthAry objectAtIndex:2];
        
    }else if([_dateMutablearray count]==2)
    {
        self.rightCalendarItem.date = date;//当前月份
        self.centerCalendarItem.date = [monthAry objectAtIndex:1];//前一个月
    
    }else if([_dateMutablearray count]==1){
    
      self.rightCalendarItem.date = date;//当前月份

    }
        
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
