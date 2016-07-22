//
//  FDCalendarItem.h
//  FDCalendarDemo
//
//  Created by jinhai on 16/7/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DeviceWidth 365
//[UIScreen mainScreen].bounds.size.width

@protocol FDCalendarItemDelegate;

@interface FDCalendarItem : UIView

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSString *oneDateString;
@property (strong, nonatomic) NSString *twoDateString;
@property (strong, nonatomic) NSString *threeDateString;

@property (nonatomic, strong) NSMutableArray *signedArray;
@property (weak, nonatomic) id<FDCalendarItemDelegate> delegate;
- (NSDate *)previousMonthDate;
- (NSDate *)lastMonthDate;
@end

@protocol FDCalendarItemDelegate <NSObject>

- (void)calendarItem:(FDCalendarItem *)item didSelectedDate:(NSDate *)date;

@end
