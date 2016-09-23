//
//  WeatherView.h
//  nfsYouLin
//
//  Created by Macx on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIControl

@property(strong, nonatomic)NSDictionary* weatherInfo;

- (id) initWithFrame:(CGRect)frame;

@end
