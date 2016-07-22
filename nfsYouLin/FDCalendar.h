//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by jinhai on 16/7/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDCalendar : UIView

@property (nonatomic, strong) NSMutableArray *nowMonthSignedArray;
@property (nonatomic, strong) NSMutableArray *previousMonthSignedArray;
@property (nonatomic, strong) NSMutableArray *lastMonthSignedArray;
@property (nonatomic, strong) NSMutableDictionary *dic;

- (instancetype)initWithCurrentDate:(NSDate *)date signArray:(NSMutableArray *)datearray;

@end
