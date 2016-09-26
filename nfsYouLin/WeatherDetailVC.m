//
//  WeatherDetailVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/23.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "WeatherDetailVC.h"
#import "ConstellationView.h"
#import "StringMD5.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"
#import "WeatherCell.h"

@interface WeatherDetailVC ()<UITableViewDelegate,UITableViewDataSource,ConstellationViewDelegate>

@end

@implementation WeatherDetailVC
{
    UILabel* _cityL;
    UILabel* _temperatureL;
    UILabel* _weatherL;
    UILabel* _updateTimeL;
    
    UIImageView* _todayDayTIV;
    UILabel* _todayDayTL;
    UIImageView* _todayNighTIV;
    UILabel* _todayNightTL;
    
    UILabel* _humidityL;
    UILabel* _rayL;
    UILabel* _clothesL;
    UILabel* _airL;
    UILabel* _carL;
    UILabel* _sportL;
    
    UILabel* _allL;
    UILabel* _healthL;
    UILabel* _moneyL;
    UILabel* _loveL;
    UILabel* _otherColL;
    UILabel* _luckColorL;
    UILabel* _luckNumL;
    
    UILabel* _weekHealthL;
    UILabel* _weekWorkTL;
    UILabel* _weekWorkL;
    UILabel* _weekLoveTL;
    UILabel* _weekLoveL;
    UILabel* _weekMoneyTL;
    UILabel* _weekMoneyL;
    
    UIScrollView* _bgView;
    NSInteger cellNum;
    UITableView* weatherTV;
    UIView* infoView;
    UIView* weekView;
    
    NSMutableArray* constellationArr;
    NSMutableArray* weekWeatherArr;

    UIActivityIndicatorView* indicatorView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    cellNum = 1;
    
    _bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), screenWidth, screenHeight)];
    _bgView.bounces = NO;
    [_bgView.layer addSublayer:[self shadowAsInverse:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) * 2.5)]];
    
    UILabel* cityL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
    cityL.textColor = [UIColor whiteColor];
    cityL.font = [UIFont systemFontOfSize:18];
    cityL.textAlignment = NSTextAlignmentCenter;
//    cityL.text = @"哈尔滨";
    [_bgView addSubview:cityL];
    _cityL = cityL;
    
    UILabel* temperatureL = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.frame), 100)];
    temperatureL.textColor = [UIColor whiteColor];
    temperatureL.font = [UIFont systemFontOfSize:80];
    temperatureL.textAlignment = NSTextAlignmentCenter;
//    temperatureL.text = @"18°";
    [_bgView addSubview:temperatureL];
    _temperatureL = temperatureL;
    
    UILabel* weatherL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(temperatureL.frame), CGRectGetWidth(self.view.frame), 25)];
    weatherL.textColor = [UIColor whiteColor];
    weatherL.font = [UIFont systemFontOfSize:20];
    weatherL.textAlignment = NSTextAlignmentCenter;
//    weatherL.text = @"晴转多云";
    [_bgView addSubview:weatherL];
    _weatherL = weatherL;
    
    UILabel* updateTimeL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weatherL.frame) + 8, CGRectGetWidth(self.view.frame), 20)];
    updateTimeL.textColor = [UIColor whiteColor];
    updateTimeL.font = [UIFont systemFontOfSize:15];
    updateTimeL.textAlignment = NSTextAlignmentCenter;
//    updateTimeL.text = @"更新时间:  9:00";
    [_bgView addSubview:updateTimeL];
    _updateTimeL = updateTimeL;

    UIView* hLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(updateTimeL.frame) + 100, CGRectGetWidth(self.view.frame), 0.5)];
    hLine1.backgroundColor = [UIColor whiteColor];
    hLine1.alpha = 0.5;
    [_bgView addSubview:hLine1];
    
    UIView* vLine1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 , CGRectGetMaxY(hLine1.frame) + 10, 0.5, 100)];
    vLine1.backgroundColor = [UIColor whiteColor];
    vLine1.alpha = 0.5;
    [_bgView addSubview:vLine1];
    
    UIView* hLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(vLine1.frame) + 10, CGRectGetWidth(self.view.frame), 0.5)];
    hLine2.backgroundColor = [UIColor whiteColor];
    hLine2.alpha = 0.5;
    [_bgView addSubview:hLine2];

    
    UILabel* todayL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(hLine1.frame), CGRectGetWidth(self.view.frame) * 0.25, 120)];
    todayL.textColor = [UIColor whiteColor];
    todayL.font = [UIFont systemFontOfSize:14];
    todayL.textAlignment = NSTextAlignmentCenter;
    todayL.text = @"今天";
    [_bgView addSubview:todayL];
    
    UILabel* todayDayL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(todayL.frame), CGRectGetMinY(vLine1.frame), 30, 14)];
    todayDayL.textColor = [UIColor whiteColor];
    todayDayL.font = [UIFont systemFontOfSize:14];
    todayDayL.textAlignment = NSTextAlignmentCenter;
    todayDayL.text = @"白天";
    [_bgView addSubview:todayDayL];
    
    UIImageView* todayDayTIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(todayL.frame), CGRectGetMaxY(todayDayL.frame) + 22, 25, 25)];
//    todayDayTIV.image = [UIImage imageNamed:@"sun.png"];
    [_bgView addSubview:todayDayTIV];
    _todayDayTIV = todayDayTIV;

    UILabel* todayDayTL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(todayDayL.frame), CGRectGetMaxY(vLine1.frame) - 14, 30, 14)];
    todayDayTL.textColor = [UIColor whiteColor];
    todayDayTL.font = [UIFont systemFontOfSize:14];
    todayDayTL.textAlignment = NSTextAlignmentCenter;
//    todayDayTL.text = @"22°";
    [_bgView addSubview:todayDayTL];
    _todayDayTL = todayDayTL;

 
    UILabel* todayNightL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vLine1.frame), CGRectGetMinY(vLine1.frame), CGRectGetWidth(self.view.frame) * 0.25, 14)];
    todayNightL.textColor = [UIColor whiteColor];
    todayNightL.font = [UIFont systemFontOfSize:14];
    todayNightL.textAlignment = NSTextAlignmentRight;
    todayNightL.text = @"晚上";
    [_bgView addSubview:todayNightL];
    
    
    UIImageView* todayNighTIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(todayNightL.frame) - 25, CGRectGetMinY(todayDayTIV.frame), 25, 25)];
//    todayNighTIV.image = [UIImage imageNamed:@"sun.png"];
    [_bgView addSubview:todayNighTIV];
    _todayNighTIV = todayNighTIV;
    
    UILabel* todayNightTL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vLine1.frame), CGRectGetMaxY(vLine1.frame) - 14, CGRectGetWidth(self.view.frame) * 0.25, 14)];
    todayNightTL.textColor = [UIColor whiteColor];
    todayNightTL.font = [UIFont systemFontOfSize:14];
    todayNightTL.textAlignment = NSTextAlignmentRight;
//    todayNightTL.text = @"10°";
    [_bgView addSubview:todayNightTL];
    _todayNightTL = todayNightTL;
    
    weatherTV = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hLine2.frame), CGRectGetWidth(self.view.frame), 50) style:UITableViewStylePlain];
    weatherTV.bounces = NO;
    weatherTV.delegate = self;
    weatherTV.dataSource = self;
    weatherTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    weatherTV.separatorColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.5];
    weatherTV.backgroundColor = [UIColor clearColor];
    if ([weatherTV respondsToSelector:@selector(setSeparatorInset:)]) {
        [weatherTV setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([weatherTV respondsToSelector:@selector(setLayoutMargins:)]) {
        [weatherTV setLayoutMargins:UIEdgeInsetsZero];
    }
    [_bgView addSubview:weatherTV];
    
    infoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weatherTV.frame), CGRectGetWidth(self.view.frame), 550)];
    infoView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:infoView];
  
    // 湿度
    UILabel* humidityTL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    humidityTL.text = @"湿度:";
    humidityTL.textAlignment = NSTextAlignmentRight;
    humidityTL.textColor = [UIColor whiteColor];
    humidityTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:humidityTL];
    
    UILabel* humidityL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, 10, CGRectGetWidth(self.view.frame) - 5, 20)];
//    humidityL.text = @"%10";
    humidityL.textColor = [UIColor whiteColor];
    humidityL.textAlignment = NSTextAlignmentLeft;
    humidityL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:humidityL];
    _humidityL = humidityL;
    
    // 紫外线
    UILabel* rayTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(humidityTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    rayTL.text = @"紫外线:";
    rayTL.textAlignment = NSTextAlignmentRight;
    rayTL.textColor = [UIColor whiteColor];
    rayTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:rayTL];
    
    UILabel* rayL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(humidityTL.frame), CGRectGetWidth(self.view.frame) - 5, 20)];
//    rayL.text = @"中等";
    rayL.textColor = [UIColor whiteColor];
    rayL.textAlignment = NSTextAlignmentLeft;
    rayL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:rayL];
    _rayL = rayL;
    
    // 穿衣指数
    UILabel* clothesTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rayTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    clothesTL.text = @"穿衣指数:";
    clothesTL.textAlignment = NSTextAlignmentRight;
    clothesTL.textColor = [UIColor whiteColor];
    clothesTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:clothesTL];
    
    UILabel* clothesL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(rayTL.frame), CGRectGetWidth(self.view.frame) - 5, 20)];
//    clothesL.text = @"较舒适";
    clothesL.textColor = [UIColor whiteColor];
    clothesL.textAlignment = NSTextAlignmentLeft;
    clothesL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:clothesL];
    _clothesL = clothesL;

    // 空调指数air
    UILabel* airTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(clothesTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    airTL.text = @"空调指数:";
    airTL.textAlignment = NSTextAlignmentRight;
    airTL.textColor = [UIColor whiteColor];
    airTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:airTL];
    
    UILabel* airL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(clothesTL.frame), CGRectGetWidth(self.view.frame) - 5, 20)];
//    airL.text = @"较少开启";
    airL.textColor = [UIColor whiteColor];
    airL.textAlignment = NSTextAlignmentLeft;
    airL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:airL];
    _airL = airL;
    
    // 洗车指数car
    UILabel* carTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(airTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    carTL.text = @"洗车指数:";
    carTL.textAlignment = NSTextAlignmentRight;
    carTL.textColor = [UIColor whiteColor];
    carTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:carTL];
    
    UILabel* carL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(airTL.frame), CGRectGetWidth(self.view.frame) - 5, 20)];
//    carL.text = @"较适宜";
    carL.textColor = [UIColor whiteColor];
    carL.textAlignment = NSTextAlignmentLeft;
    carL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:carL];
    _carL = carL;
    
    // 运动指数
    UILabel* sportTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(carL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    sportTL.text = @"运动指数:";
    sportTL.textAlignment = NSTextAlignmentRight;
    sportTL.textColor = [UIColor whiteColor];
    sportTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:sportTL];
    
    UILabel* sportL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(carL.frame), CGRectGetWidth(self.view.frame) - 5, 20)];
//    sportL.text = @"较适宜";
    sportL.textColor = [UIColor whiteColor];
    sportL.textAlignment = NSTextAlignmentLeft;
    sportL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:sportL];
    _sportL = sportL;
    
    UIView* hLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sportL.frame) + 10, CGRectGetWidth(self.view.frame), 0.5)];
    hLine3.backgroundColor = [UIColor whiteColor];
    hLine3.alpha = 0.5;
    [infoView addSubview:hLine3];
    
    // 星座
    UILabel* constellationL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(hLine3.frame) + 10, 40, 20)];
    constellationL.text = @"星座";
    constellationL.textColor = [UIColor whiteColor];
    constellationL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:constellationL];
    
    ConstellationView* constellationView = [[ConstellationView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(constellationL.frame) + 10, CGRectGetWidth(self.view.frame), 150)];
    constellationView.backgroundColor = [UIColor clearColor];
    constellationView.delegate = self;
    [infoView addSubview:constellationView];
    
    // 今日运势
    UILabel* luckTL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 - 50, CGRectGetMaxY(constellationView.frame), 100, 20)];
    luckTL.text = @"今日运势";
    luckTL.textColor = [UIColor whiteColor];
    luckTL.textAlignment = NSTextAlignmentCenter;
    luckTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:luckTL];
    
    UIView* hLine4 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(constellationView.frame) + 10, CGRectGetWidth(self.view.frame) * 0.5- 70, 0.5)];
    hLine4.backgroundColor = [UIColor whiteColor];
    hLine4.alpha = 0.5;
    [infoView addSubview:hLine4];
    
    UIView* hLine5 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(luckTL.frame) ,CGRectGetMaxY(constellationView.frame) + 10, CGRectGetWidth(self.view.frame) * 0.5 - 70, 0.5)];
    hLine5.backgroundColor = [UIColor whiteColor];
    hLine5.alpha = 0.5;
    [infoView addSubview:hLine5];

    // 综合指数
    UILabel* allTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(luckTL.frame) + 10, CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    allTL.text = @"综合指数:";
    allTL.textAlignment = NSTextAlignmentRight;
    allTL.textColor = [UIColor whiteColor];
    allTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:allTL];
    
    UILabel* allL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(luckTL.frame) + 10, CGRectGetWidth(self.view.frame) - 5, 20)];
//    allL.text = @"%20";
    allL.textColor = [UIColor whiteColor];
    allL.textAlignment = NSTextAlignmentLeft;
    allL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:allL];
    _allL = allL;
    
    // 健康指数
    UILabel* healthTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(allTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    healthTL.text = @"健康指数:";
    healthTL.textAlignment = NSTextAlignmentRight;
    healthTL.textColor = [UIColor whiteColor];
    healthTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:healthTL];
    
    UILabel* healthL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(allTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
//    healthL.text = @"%76";
    healthL.textColor = [UIColor whiteColor];
    healthL.textAlignment = NSTextAlignmentLeft;
    healthL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:healthL];
    _healthL = healthL;
    
    // 财运指数
    UILabel* moneyTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(healthTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    moneyTL.text = @"财运指数:";
    moneyTL.textAlignment = NSTextAlignmentRight;
    moneyTL.textColor = [UIColor whiteColor];
    moneyTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:moneyTL];
    
    UILabel* moneyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(healthL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
//    moneyL.text = @"%60";
    moneyL.textColor = [UIColor whiteColor];
    moneyL.textAlignment = NSTextAlignmentLeft;
    moneyL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:moneyL];
    _moneyL = moneyL;
    
    // 爱情指数
    UILabel* loveTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    loveTL.text = @"爱情指数:";
    loveTL.textAlignment = NSTextAlignmentRight;
    loveTL.textColor = [UIColor whiteColor];
    loveTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:loveTL];
    
    UILabel* loveL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(moneyL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
//    loveL.text = @"%20";
    loveL.textColor = [UIColor whiteColor];
    loveL.textAlignment = NSTextAlignmentLeft;
    loveL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:loveL];
    _loveL = loveL;
    
    // 速配星座
    UILabel* otherColTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loveTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    otherColTL.text = @"速配星座:";
    otherColTL.textAlignment = NSTextAlignmentRight;
    otherColTL.textColor = [UIColor whiteColor];
    otherColTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:otherColTL];
    
    UILabel* otherColL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(loveL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
//    otherColL.text = @"白羊座";
    otherColL.textColor = [UIColor whiteColor];
    otherColL.textAlignment = NSTextAlignmentLeft;
    otherColL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:otherColL];
    _otherColL = otherColL;
    
    // 幸运颜色
    UILabel* luckColorTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(otherColTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    luckColorTL.text = @"幸运颜色:";
    luckColorTL.textAlignment = NSTextAlignmentRight;
    luckColorTL.textColor = [UIColor whiteColor];
    luckColorTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:luckColorTL];
    
    UILabel* luckColorL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(otherColL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
//    luckColorL.text = @"浅蓝色";
    luckColorL.textColor = [UIColor whiteColor];
    luckColorL.textAlignment = NSTextAlignmentLeft;
    luckColorL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:luckColorL];
    _luckColorL = luckColorL;
    
    // 幸运数字
    UILabel* luckNumTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(luckColorTL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
    luckNumTL.text = @"幸运数字:";
    luckNumTL.textAlignment = NSTextAlignmentRight;
    luckNumTL.textColor = [UIColor whiteColor];
    luckNumTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:luckNumTL];
    
    UILabel* luckNumL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(luckColorL.frame), CGRectGetWidth(self.view.frame) * 0.5 - 5, 20)];
//    luckNumL.text = @"1";
    luckNumL.textColor = [UIColor whiteColor];
    luckNumL.textAlignment = NSTextAlignmentLeft;
    luckNumL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:luckNumL];
    _luckNumL = luckNumL;
    
    // 本周运势
    UILabel* weekLuckTL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 - 50, CGRectGetMaxY(luckNumL.frame) + 10, 100, 20)];
    weekLuckTL.text = @"本周运势";
    weekLuckTL.textColor = [UIColor whiteColor];
    weekLuckTL.textAlignment = NSTextAlignmentCenter;
    weekLuckTL.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:weekLuckTL];
    
    UIView* hLine6 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(luckNumL.frame) + 20, CGRectGetWidth(self.view.frame) * 0.5- 70, 0.5)];
    hLine6.backgroundColor = [UIColor whiteColor];
    hLine6.alpha = 0.5;
    [infoView addSubview:hLine6];
    
    UIView* hLine7 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weekLuckTL.frame) ,CGRectGetMaxY(luckNumL.frame) + 20, CGRectGetWidth(self.view.frame) * 0.5 - 70, 0.5)];
    hLine7.backgroundColor = [UIColor whiteColor];
    hLine7.alpha = 0.5;
    [infoView addSubview:hLine7];

    // 周 运
    weekView = [[UIView alloc] init];
    weekView.backgroundColor = [UIColor clearColor];
    
    NSString* string;
    // 周 健康
    UILabel* weekHealthTL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 45, 20)];
    weekHealthTL.text = @"健康:";
    weekHealthTL.textColor = [UIColor whiteColor];
    weekHealthTL.textAlignment = NSTextAlignmentCenter;
    weekHealthTL.font = [UIFont systemFontOfSize:16];
    [weekView addSubview:weekHealthTL];

    string = @"水逆出行，要小心交通意外。性能量高，要小心纵欲引发身体不适。";
    CGSize weekHealthSize = [StringMD5 sizeWithString:string font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 70, MAXFLOAT)];
    UILabel* weekHealthL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weekHealthTL.frame), 11, CGRectGetWidth(self.view.frame) - 65, weekHealthSize.height)];
    weekHealthL.text = string;
    weekHealthL.numberOfLines = 0;
    weekHealthL.font = [UIFont systemFontOfSize:14];
    weekHealthL.textColor = [UIColor whiteColor];
    [weekView addSubview:weekHealthL];
    _weekHealthL = weekHealthL;
    
    // 周 工作
    UILabel* weekWorkTL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(weekHealthL.frame) + 10, 45, 20)];
    weekWorkTL.text = @"工作:";
    weekWorkTL.textColor = [UIColor whiteColor];
    weekWorkTL.textAlignment = NSTextAlignmentCenter;
    weekWorkTL.font = [UIFont systemFontOfSize:16];
    [weekView addSubview:weekWorkTL];
    _weekWorkTL = weekWorkTL;
    
    string = @"水逆结束，太阳和金星相继转宫，合作关系中的误会被化解，但你们的合作也暂告一段落了。接下来，会有一些自己想独立私下去开展的计划，你还挺有狗屎运的";
    CGSize weekWorkSize = [StringMD5 sizeWithString:string font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 70, MAXFLOAT)];
    UILabel* weekWorkL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weekWorkTL.frame), CGRectGetMaxY(weekHealthL.frame) + 10, CGRectGetWidth(self.view.frame) - 65, weekWorkSize.height)];
    weekWorkL.text = string;
    weekWorkL.numberOfLines = 0;
    weekWorkL.font = [UIFont systemFontOfSize:14];
    weekWorkL.textColor = [UIColor whiteColor];
    [weekView addSubview:weekWorkL];
    _weekWorkL = weekWorkL;
    
    // 周 爱情
    UILabel* weekLoveTL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(weekWorkL.frame) + 10, 45, 20)];
    weekLoveTL.text = @"爱情:";
    weekLoveTL.textColor = [UIColor whiteColor];
    weekLoveTL.textAlignment = NSTextAlignmentCenter;
    weekLoveTL.font = [UIFont systemFontOfSize:16];
    [weekView addSubview:weekLoveTL];
    _weekLoveTL = weekLoveTL;
    string = @"和伴侣之间的误会化解，之前的相互折磨让彼此都疲惫不堪。接下来，会进入冷静期，换一种轻松的相处方式。子晴小提醒，一起去旅行，是重新燃起爱的好机会";
    CGSize weekLoveSize = [StringMD5 sizeWithString:string font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 70, MAXFLOAT)];
    UILabel* weekLoveL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weekLoveTL.frame), CGRectGetMaxY(weekWorkL.frame) + 10, CGRectGetWidth(self.view.frame) - 65, weekLoveSize.height)];
    weekLoveL.text = string;
    weekLoveL.numberOfLines = 0;
    weekLoveL.font = [UIFont systemFontOfSize:14];
    weekLoveL.textColor = [UIColor whiteColor];
    [weekView addSubview:weekLoveL];
    _weekLoveL = weekLoveL;
    
    // 周 财运
    UILabel* weekMoneyTL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(weekLoveL.frame) + 10, 45, 20)];
    weekMoneyTL.text = @"财运:";
    weekMoneyTL.textColor = [UIColor whiteColor];
    weekMoneyTL.textAlignment = NSTextAlignmentCenter;
    weekMoneyTL.font = [UIFont systemFontOfSize:16];
    [weekView addSubview:weekMoneyTL];
    _weekMoneyTL = weekMoneyTL;
    
    string = @"赌运开始没落，所以要见好就收了。正财运开始上升，乖乖回去上班赚钱吧！";
    CGSize weekMoneySize = [StringMD5 sizeWithString:string font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 70, MAXFLOAT)];
    UILabel* weekMoneyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weekMoneyTL.frame), CGRectGetMaxY(weekLoveL.frame) + 10, CGRectGetWidth(self.view.frame) - 65, weekMoneySize.height)];
    weekMoneyL.text = string;
    weekMoneyL.numberOfLines = 0;
    weekMoneyL.font = [UIFont systemFontOfSize:14];
    weekMoneyL.textColor = [UIColor whiteColor];
    [weekView addSubview:weekMoneyL];
    _weekMoneyL = weekMoneyL;

    weekView.frame = CGRectMake(0, CGRectGetMaxY(infoView.frame), CGRectGetWidth(self.view.frame), CGRectGetMaxY(weekMoneyL.frame));
    [_bgView addSubview:weekView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 20, screenHeight / 2, 40, 40)];
    indicatorView.hidesWhenStopped = YES;
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicatorView.color = MainColor;
    [indicatorView startAnimating];
    [self.view addSubview:indicatorView];
    
    [self weatherDetailNet];
}


#pragma mark -UITableDelegate UITableDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherCell* cell;
    if(cellNum == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"no"];
        if(cell == nil)
        {
            cell = [[WeatherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"no"];
        }
        cell.title = @"查看未来几天";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(cellNum == 4)
    {
        
        if(indexPath.row == 3)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"no"];
            if(cell == nil)
            {
                cell = [[WeatherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"no"];
            }
            cell.title = @"收起";
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"yes"];
            if(cell == nil)
            {
                cell = [[WeatherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"yes"];
            }
            cell.weatherInfo = [weekWeatherArr objectAtIndex:indexPath.row];
        }
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect tvRect = weatherTV.frame;
    CGRect infoRect = infoView.frame;
    CGRect weekRect = weekView.frame;
    
    if(cellNum == 1)
    {
        cellNum = 4;
        tvRect.size.height = 200;
    }
    else if(cellNum == 4)
    {
        if(indexPath.row == 3)
        {
            cellNum = 1;
            tvRect.size.height = 50;
        }
    }
    weatherTV.frame = tvRect;
    infoRect.origin.y = CGRectGetMaxY(weatherTV.frame);
    infoView.frame = infoRect;
    weekRect.origin.y = CGRectGetMaxY(infoRect);
    weekView.frame = weekRect;
    _bgView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(weekView.frame) + 20 + CGRectGetMaxY(self.navigationController.navigationBar.frame));
    [weatherTV reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

}


- (CAGradientLayer *)shadowAsInverse:(CGRect) frame;
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = frame;
    newShadow.colors = [NSArray arrayWithObjects:
                        (id)[[UIColor colorWithRed:0/255.0 green:91/255.0 blue:144/255.0 alpha:1] CGColor],
                        (id)[[UIColor colorWithRed:5/255.0 green:121/255.0 blue:177/255.0 alpha:1] CGColor],
                        (id)[[UIColor colorWithRed:10/255.0 green:153/255.0 blue:210/255.0 alpha:1] CGColor],
                        nil];
    
    return newShadow;
}

#pragma mark -constellationViewDelegate
- (void) selectedConstellation:(NSInteger)index
{
    NSDictionary* dict = [constellationArr objectAtIndex:index];
    [self weekLoadView:dict];
}

#pragma mark 获取天气详情网络请求
- (void) weatherDetailNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    /**
     tag=getweaorzodinfo&apitype=comsrv&access=9527&weaorzod_id=253&community_id=1
     */
    NSDictionary* parameter = @{@"community_id" : communityId,
                                @"weaorzod_id" : [NSNumber numberWithInteger:self.weatherId],
                                @"apitype" : @"comsrv",
                                @"salt" : @"1",
                                @"tag" : @"getweaorzodinfo",
                                @"hash" : hashString,
                                @"keyset" : @"community_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取天气详情网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            constellationArr = [responseObject valueForKey:@"zodiac_detail"];
            NSDictionary* constellationDict = [constellationArr objectAtIndex:0];
            [self weekLoadView:constellationDict];
            
            NSDictionary* lifeInfo = [[[responseObject valueForKey:@"weaher_detail"] valueForKey:@"life"] valueForKey:@"info"];
            
            _airL.text = [[lifeInfo valueForKey:@"kongtiao"] objectAtIndex:0];
            _clothesL.text = [[lifeInfo valueForKey:@"chuanyi"] objectAtIndex:0];
            _sportL.text = [[lifeInfo valueForKey:@"yundong"] objectAtIndex:0];
            _rayL.text = [[lifeInfo valueForKey:@"ziwaixian"] objectAtIndex:0];
            _carL.text = [[lifeInfo valueForKey:@"xiche"] objectAtIndex:0];
            
            NSDictionary* todayDict = [[[responseObject valueForKey:@"weaher_detail"] valueForKey:@"weather"] objectAtIndex:0];
            NSString* dayStr = [[[todayDict valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:2];
            NSString* nightStr = [[[todayDict valueForKey:@"info"] valueForKey:@"night"] objectAtIndex:2];
            _todayDayTL.text = [NSString stringWithFormat:@"%@°",dayStr];
            _todayNightTL.text = [NSString stringWithFormat:@"%@°",nightStr];
            
            NSString* dayWeatherStr = [[[todayDict valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:1];
            _todayDayTIV.image = [self loadWeatherImage:dayWeatherStr];
            
            NSString* nightWeatherStr = [[[todayDict valueForKey:@"info"] valueForKey:@"night"] objectAtIndex:1];
            _todayNighTIV.image = [self loadWeatherImage:nightWeatherStr];
            
            NSArray* weekArray = [[responseObject valueForKey:@"weaher_detail"] valueForKey:@"weather"];
            weekWeatherArr = [NSMutableArray arrayWithObjects:[weekArray objectAtIndex:1],[weekArray objectAtIndex:2],[weekArray objectAtIndex:3], nil];
            
            NSDictionary* realInfo = [[responseObject valueForKey:@"weaher_detail"] valueForKey:@"realtime"];
            _cityL.text = [realInfo valueForKey:@"city_name"];
            _temperatureL.text = [NSString stringWithFormat:@"%@°",[[realInfo valueForKey:@"weather"] valueForKey:@"temperature"] ];
            _weatherL.text = [[realInfo valueForKey:@"weather"] valueForKey:@"info"];
            _humidityL.text = [NSString stringWithFormat:@"%@%%",[[realInfo valueForKey:@"weather"] valueForKey:@"humidity"]];
            NSInteger dateUptime = [[[realInfo valueForKey:@"weather"] valueForKey:@"dataUptime"] integerValue];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:dateUptime];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            _updateTimeL.text = [NSString stringWithFormat:@"更新时间：%@",[formatter stringFromDate:date]];
        }
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        [self.view addSubview:_bgView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        return;
    }];

}

#pragma mark 本周运势控件加载
- (void) weekLoadView:(NSDictionary*)dict
{
    _allL.text = [dict valueForKey:@"all"];
    _healthL.text = [dict valueForKey:@"health"];
    _moneyL.text = [dict valueForKey:@"money"];
    _loveL.text = [dict valueForKey:@"love"];
    _otherColL.text = [dict valueForKey:@"QFriend"];
    _luckColorL.text = [dict valueForKey:@"color"];
    _luckNumL.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"number"]];
    
    NSString* string = [[dict valueForKey:@"week"] valueForKey:@"health"];
    CGRect healthRect = _weekHealthL.frame;
    CGSize healthSize = [StringMD5 sizeWithString:string font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 70, MAXFLOAT)];
    _weekHealthL.text = string;
    _weekHealthL.frame = CGRectMake(healthRect.origin.x, healthRect.origin.y, CGRectGetWidth(self.view.frame) - 65, healthSize.height);
    [_weekHealthL sizeToFit];
    
    string = [[dict valueForKey:@"week"] valueForKey:@"work"];
    CGSize workSize = [StringMD5 sizeWithString:string font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 70, MAXFLOAT)];
    _weekWorkTL.frame = CGRectMake(20, CGRectGetMaxY(_weekHealthL.frame) + 10, 45, 20);
    _weekWorkL.frame = CGRectMake(CGRectGetMaxX(_weekWorkTL.frame), CGRectGetMaxY(_weekHealthL.frame) + 10, CGRectGetWidth(self.view.frame) - 65, workSize.height);
    _weekWorkL.text = string;
    [_weekWorkL sizeToFit];
    [_weekWorkTL sizeToFit];


    string = [[dict valueForKey:@"week"] valueForKey:@"love"];
    CGSize loveSize = [StringMD5 sizeWithString:string font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 70, MAXFLOAT)];
    _weekLoveTL.frame = CGRectMake(20, CGRectGetMaxY(_weekWorkL.frame) + 10, 45, 20);
    _weekLoveL.frame = CGRectMake(CGRectGetMaxX(_weekLoveTL.frame), CGRectGetMaxY(_weekWorkL.frame) + 10, CGRectGetWidth(self.view.frame) - 65, loveSize.height);
    _weekLoveL.text = string;
    [_weekLoveL sizeToFit];
    [_weekLoveTL sizeToFit];

    string = [[dict valueForKey:@"week"] valueForKey:@"money"];
    CGSize moneySize = [StringMD5 sizeWithString:string font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 70, MAXFLOAT)];
    _weekMoneyTL.frame = CGRectMake(20, CGRectGetMaxY(_weekLoveL.frame) + 10, 45, 20);
    _weekMoneyL.frame = CGRectMake(CGRectGetMaxX(_weekMoneyTL.frame), CGRectGetMaxY(_weekLoveL.frame) + 10, CGRectGetWidth(self.view.frame) - 65, moneySize.height);
    _weekMoneyL.text = string;
    [_weekMoneyL sizeToFit];
    [_weekMoneyTL sizeToFit];

    weekView.frame = CGRectMake(0, CGRectGetMaxY(infoView.frame), CGRectGetWidth(self.view.frame), CGRectGetMaxY(_weekMoneyL.frame));
    _bgView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(weekView.frame) + 20 + CGRectGetMaxY(self.navigationController.navigationBar.frame));

    
}

#pragma mark - 加载天气图片
- (UIImage *) loadWeatherImage:(NSString*) info
{
    UIImage* image;
    if([info rangeOfString:@"小雨"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"cloud_drizzle.png"];
    }
    else if([info rangeOfString:@"阵雨"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"cloud_lightning.png"];
    }
    else if([info rangeOfString:@"阴"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"cloud_sun.png"];
    }
    else if([info rangeOfString:@"雨"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"cloud_rain.png"];
    }
    else if([info rangeOfString:@"雪"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"cloud_snow.png"];
    }
    else if([info rangeOfString:@"雾"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"cloud_fog.png"];
    }
    else if([info rangeOfString:@"云"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"cloud.png"];
    }
    else if([info rangeOfString:@"冰雹"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"cloud_hail.png"];
    }
    else if([info rangeOfString:@"雷"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"cloud_lightning.png"];
    }
    else if([info rangeOfString:@"晴"].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"sun.png"];
    }

    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
