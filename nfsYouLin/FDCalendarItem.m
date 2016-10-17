//
//  FDCalendarItem.m
//  FDCalendarDemo
//
//  Created by jinhai on 16/7/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FDCalendarItem.h"
#import "HeaderFile.h"
#import "DeviceType.h"

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface FDCalendarCell : UICollectionViewCell

- (UILabel *)dayLabel;
- (UILabel *)signDayLabel;

@end

@implementation FDCalendarCell {
    UILabel *_dayLabel;
    UILabel *_signDayLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:15];
        _dayLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 3);
        [self addSubview:_dayLabel];
    }
    return _dayLabel;
}

- (UILabel *)signDayLabel {
    if (!_signDayLabel) {
        _signDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
        _signDayLabel.textAlignment = NSTextAlignmentCenter;
        CGPoint point = _dayLabel.center;
        if([[DeviceType iphoneType] isEqualToString:@"iPhone Simulator"]){
            
          _signDayLabel.font = [UIFont boldSystemFontOfSize:9];
             point.y += 15;
        }else{
        
          NSInteger typeNum = [[[DeviceType iphoneType] substringWithRange:NSMakeRange(7,1)] intValue];
          NSLog(@"device type is %ld",typeNum);
            if(typeNum > 5)
            {
                
                _signDayLabel.font = [UIFont boldSystemFontOfSize:9];
                point.y += 15;
            }else{
            
                _signDayLabel.font = [UIFont boldSystemFontOfSize:7];
                point.y += 12;
            }
        
        }

        _signDayLabel.center = point;
        [self addSubview:_signDayLabel];
    }
    return _signDayLabel;
}

@end

#define CollectionViewHorizonMargin 5
#define CollectionViewVerticalMargin 5


typedef NS_ENUM(NSUInteger, FDCalendarMonth) {
    FDCalendarMonthPrevious = 0,
    FDCalendarMonthCurrent = 1,
    FDCalendarMonthLast = 2,
};

@interface FDCalendarItem () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation FDCalendarItem{

    CGSize cellS;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupCollectionView];
        [self setFrame:CGRectMake(0, 0, screenWidth-40, self.collectionView.frame.size.height + CollectionViewVerticalMargin * 2)];//DeviceWidth
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.collectionView reloadData];
}

#pragma mark - Public 

// 获取date的上上个月日期
- (NSDate *)lastMonthDate{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -2;
    //NSLog(@"begin month");
    NSDate *lastMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    //NSLog(@"end month");
    return lastMonthDate;
}

// 获取date的上个月日期
- (NSDate *)previousMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *previousMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return previousMonthDate;
}

// 获取date的上上个月
- (NSDate *)lastMonth{
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -2;
    NSDate *lastMonth = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
    return lastMonth;
}

// 获取date的上个月
- (NSDate *)previousMonth {

    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *previousMonth = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
    return previousMonth;
}

#pragma mark - date
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


#pragma mark - Private

// collectionView显示日期单元，设置其属性
- (void)setupCollectionView {
    CGFloat itemWidth = (screenWidth - CollectionViewHorizonMargin * 2) / 7;//DeviceWidth
    CGFloat itemHeight = itemWidth;
    NSLog(@"view 宽度 = %f",screenWidth-40);
    
    NSLog(@"(screenWidth - 40 - 36 - 33)/7 is %f",(screenWidth - 40 - 36 - 33)/7);
    cellS = CGSizeMake((screenWidth - 40 - 36 - 33)/7, (screenWidth - 40 - 36 - 33)/7);
    NSLog(@"itemWidth = %f",itemWidth);
    
    
    UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
    flowLayot.sectionInset = UIEdgeInsetsZero;
    flowLayot.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayot.minimumLineSpacing = 0;
    flowLayot.minimumInteritemSpacing = 0;
    
    CGRect collectionViewFrame = CGRectMake(CollectionViewHorizonMargin, CollectionViewVerticalMargin, screenWidth - 40 -CollectionViewHorizonMargin * 2, itemHeight * 6);//DeviceWidth
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayot];
    [self addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[FDCalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
}

// 获取date当前月的第一天是星期几
- (NSInteger)weekdayOfFirstDayInDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    [components setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:components];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDate];
    return firstComponents.weekday - 1;
}

// 获取date当前月的总天数
- (NSInteger)totalDaysInMonthOfDate:(NSDate *)date {
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

// 获取某月day的日期
- (NSDate *)dateOfMonth:(FDCalendarMonth)calendarMonth WithDay:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date;
    
    switch (calendarMonth) {
        case FDCalendarMonthPrevious:
            date = [self previousMonthDate];
            break;
            
        case FDCalendarMonthCurrent:
            date = self.date;
            break;
            
        case FDCalendarMonthLast:
            date = [self lastMonthDate];
            break;
        default:
            break;
    }
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:day];
    NSDate *dateOfDay = [calendar dateFromComponents:components];
    return dateOfDay;
}



#pragma mark - UICollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"CalendarCell";
    FDCalendarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.dayLabel.textColor = [UIColor blackColor];
    cell.signDayLabel.textColor = [UIColor grayColor];
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    NSInteger totalDaysOfMonth = [self totalDaysInMonthOfDate:self.date];
    NSInteger totalDaysOfLastMonth = [self totalDaysInMonthOfDate:[self previousMonthDate]];
    
    if (indexPath.row < firstWeekday) {    // 小于这个月的第一天
        NSInteger day = totalDaysOfLastMonth - firstWeekday + indexPath.row + 1;
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
        cell.dayLabel.textColor = [UIColor grayColor];
        
    } else if (indexPath.row >= totalDaysOfMonth + firstWeekday) {    // 大于这个月的最后一天
        NSInteger day = indexPath.row - totalDaysOfMonth - firstWeekday + 1;
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
        cell.dayLabel.textColor = [UIColor grayColor];
        
        
    } else {    // 属于这个月
        NSInteger day = indexPath.row - firstWeekday + 1;
        cell.dayLabel.text= [NSString stringWithFormat:@"%ld", day];

        if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self.date]&&[self month:self.date]==[self month:[NSDate date]]) {
            cell.backgroundColor = RGB(255, 140, 0);
            cell.layer.cornerRadius = cell.frame.size.height / 2;
            cell.layer.borderWidth = 1.0;
            cell.layer.borderColor =  RGBAlpha(255, 140, 0, 1.0).CGColor;
            cell.dayLabel.textColor = [UIColor whiteColor];
            cell.signDayLabel.text =@"已签";
            cell.signDayLabel.textColor=RGB(65,105,225);
            
        }else if(day != [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self.date]&&[self month:self.date]==[self month:[NSDate date]]){
           //&&day!=[_signedArray objectAtIndex:i]
            if([self checkSignedDay:day])
            {
                //cell.backgroundColor = RGB(255, 140, 0);
                cell.layer.cornerRadius = cell.frame.size.height / 2;
                cell.layer.borderWidth = 1.0;
                cell.layer.borderColor =  RGBAlpha(255, 140, 0, 1.0).CGColor;
                cell.signDayLabel.text =@"已签";
                cell.signDayLabel.textColor=RGB(65,105,225);
                
            }else{
            
                cell.signDayLabel.text =@"未签";
                cell.signDayLabel.textColor=[UIColor grayColor];

            }
            
        }else if([self month:self.date]==[self month:[self previousMonth]]){
        
        
            if([self checkSignedDay:day])
            {
                //cell.backgroundColor = RGB(255, 140, 0);
                cell.layer.cornerRadius = cell.frame.size.height / 2;
                cell.layer.borderWidth = 1.0;
                cell.layer.borderColor =  RGBAlpha(255, 140, 0, 1.0).CGColor;
                cell.signDayLabel.text =@"已签";
                cell.signDayLabel.textColor=RGB(65,105,225);
                
            }else{
                
                cell.signDayLabel.text =@"未签";
                cell.signDayLabel.textColor=[UIColor grayColor];
                
            }

        
        }else if([self month:self.date]==[self month:[self lastMonth]]){
        
        
            if([self checkSignedDay:day])
            {
                //cell.backgroundColor = RGB(255, 140, 0);
                cell.layer.cornerRadius = cell.frame.size.height / 2;
                cell.layer.borderWidth = 1.0;
                cell.layer.borderColor =  RGBAlpha(255, 140, 0, 1.0).CGColor;
                cell.signDayLabel.text =@"已签";
                cell.signDayLabel.textColor=RGB(65,105,225);
                
            }else{
                
                cell.signDayLabel.text =@"未签";
                cell.signDayLabel.textColor=[UIColor grayColor];
                
            }

        
        }
        
        if ([[NSCalendar currentCalendar] isDate:[NSDate date] equalToDate:self.date toUnitGranularity:NSCalendarUnitMonth] && ![[NSCalendar currentCalendar] isDateInToday:self.date]) {
            
            // 将当前日期的那天高亮显示
            if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]]) {
                cell.dayLabel.textColor = [UIColor blueColor];
            }
        }
        
    }
    
    return cell;
}

/*检查是否签到*/
-(BOOL) checkSignedDay:(NSInteger)day
{
  
    for(int i=0;i<[self.signedArray count];i++)
    {
        //NSLog(@"signArray object is %@",[_signedArray objectAtIndex:i]);
        if([[NSString stringWithFormat: @"%ld", day] isEqualToString:[_signedArray objectAtIndex:i]]){
            //NSLog(@"begin signed");
            return YES;
            
        }else{
        
            continue;
        }
        
    }

    return NO;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return cellS;
    //CGSizeMake(40, 40);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}
@end
