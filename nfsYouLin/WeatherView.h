//
//  WeatherView.h
//  nfsYouLin
//
//  Created by Macx on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeatherDelegate <NSObject>

- (void) intoWeatherDetail:(NSInteger) weatherId;

@end

@interface WeatherView : UIControl

@property(strong, nonatomic)NSDictionary* weatherInfo;
@property(strong, nonatomic)id <WeatherDelegate> deleagate;

- (id) initWithFrame:(CGRect)frame;

@end
