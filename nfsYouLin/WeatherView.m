//
//  WeatherView.m
//  nfsYouLin
//
//  Created by Macx on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "WeatherView.h"
#import "HeaderFile.h"
#import "UIImageView+WebCache.h"

@implementation WeatherView
{
    UILabel* _addressL;
    UILabel* _temperatureL;
    UILabel* _infoL;
    UIImageView* _infoIV;
    UILabel* _tomorrowTL;
    UILabel* _afterTomTL;
    UILabel* _constellationL;
    UIImageView* _constellationIV;
    
    UIView* weatherV;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = BackgroundColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weatherGesture)];
        [self addGestureRecognizer:tapGesture];
        
        UIControl* bgV1 = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 260)];
        bgV1.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgV1];
        
        weatherV = [[UIView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(bgV1.frame) - 20, 240)];
//        weatherV.backgroundColor = [UIColor blueColor];
        [weatherV.layer addSublayer:[self shadowAsInverse]];
        weatherV.layer.cornerRadius = 3;
        [bgV1 addSubview:weatherV];
        
        UIImageView* addressIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(weatherV.frame) - 100, 10, 25, 25)];
        addressIV.image = [UIImage imageNamed:@"weizhi.png"];
        [weatherV addSubview:addressIV];
        
        UILabel* addressL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressIV.frame), 10, 75, 25)];
        addressL.text = @"哈尔滨";
        addressL.textColor = [UIColor whiteColor];
        addressL.textAlignment = NSTextAlignmentCenter;
        addressL.font = [UIFont systemFontOfSize:15];
        [weatherV addSubview:addressL];
        _addressL = addressL;
        
        UILabel* unitL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(weatherV.frame) - 115, CGRectGetMaxY(addressIV.frame) + 10, 30, 20)];
        unitL.text = @"°";
        unitL.textColor = [UIColor whiteColor];
        unitL.textAlignment = NSTextAlignmentCenter;
        unitL.font = [UIFont boldSystemFontOfSize:30];
        
        UILabel* temperatureL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(unitL.frame) - 15, CGRectGetWidth(weatherV.frame), 65)];
//        temperatureL.backgroundColor = [UIColor redColor];
        temperatureL.text = @"10";
        temperatureL.textColor = [UIColor whiteColor];
        temperatureL.textAlignment = NSTextAlignmentCenter;
        temperatureL.font = [UIFont systemFontOfSize:75];
        _temperatureL = temperatureL;
        [weatherV addSubview:temperatureL];
        [weatherV addSubview:unitL];

        UIView*  infoView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(weatherV.frame) * 0.5 - 50, CGRectGetMaxY(temperatureL.frame) + 20, 150, 20)];
        [weatherV addSubview:infoView];
        
        UIImageView* infoIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        infoIV.image = [UIImage imageNamed:@"cloud_lightning.png"];
        _infoIV = infoIV;
        [infoView addSubview:infoIV];
        
        UILabel* infoL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(infoIV.frame) + 10, 0, 120, 20)];
        infoL.text = @"阵雨   18°/23°";
        infoL.textColor = [UIColor whiteColor];
        infoL.font = [UIFont systemFontOfSize:15];
        _infoL = infoL;
        [infoView addSubview:infoL];
        
        UIView* hlineV = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(infoView.frame) + 20, CGRectGetWidth(weatherV.frame) - 50, 1)];
        hlineV.alpha = 0.5;
        hlineV.backgroundColor = [UIColor whiteColor];
        [weatherV addSubview:hlineV];
        
        UIView* vlineV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(weatherV.frame) * 0.5 - 0.5, CGRectGetMaxY(hlineV.frame) + 15, 1, 40)];
        vlineV.alpha = 0.5;
        vlineV.backgroundColor = [UIColor whiteColor];
        [weatherV addSubview:vlineV];
        
        UILabel* tomorrowL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hlineV.frame) + 10, CGRectGetWidth(weatherV.frame) * 0.5, 20)];
        tomorrowL.textColor = [UIColor whiteColor];
        tomorrowL.text = @"明天";
        tomorrowL.textAlignment = NSTextAlignmentCenter;
        tomorrowL.font = [UIFont systemFontOfSize:15];
        [weatherV addSubview:tomorrowL];
        
        UILabel* tomorrowTL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tomorrowL.frame) + 10, CGRectGetWidth(weatherV.frame) * 0.5, 20)];
        tomorrowTL.textColor = [UIColor whiteColor];
        tomorrowTL.text = @"14°/21°";
        tomorrowTL.textAlignment = NSTextAlignmentCenter;
        tomorrowTL.font = [UIFont systemFontOfSize:15];
        _tomorrowTL = tomorrowTL;
        [weatherV addSubview:tomorrowTL];

        
        UILabel* afterTomL  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vlineV.frame), CGRectGetMaxY(hlineV.frame) + 10, CGRectGetWidth(weatherV.frame) * 0.5, 20)];
        afterTomL.textColor = [UIColor whiteColor];
        afterTomL.text = @"后天";
        afterTomL.textAlignment = NSTextAlignmentCenter;
        afterTomL.font = [UIFont systemFontOfSize:15];
        [weatherV addSubview:afterTomL];
        
        UILabel* afterTomTL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vlineV.frame), CGRectGetMaxY(afterTomL.frame) + 10, CGRectGetWidth(weatherV.frame) * 0.5, 20)];
        afterTomTL.textColor = [UIColor whiteColor];
        afterTomTL.text = @"13°/21°";
        afterTomTL.textAlignment = NSTextAlignmentCenter;
        afterTomTL.font = [UIFont systemFontOfSize:15];
        _afterTomTL = afterTomTL;
        [weatherV addSubview:afterTomTL];
        
        UIControl* bgV2 = [[UIControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgV1.frame) + 2, CGRectGetWidth(self.frame), 70)];
        bgV2.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgV2];
        
        // 星座
        UILabel* constellationL = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(bgV2.frame) - 70, 70)];
        constellationL.text = @"【星座运势】 今天是你容易有深刻感悟的一天，深入思考就会发现";
        constellationL.textAlignment = NSTextAlignmentLeft;
        constellationL.numberOfLines = 0;
        constellationL.font = [UIFont systemFontOfSize:14];
        _constellationL = constellationL;
        [bgV2 addSubview:constellationL];
        
        UIImageView* constellationIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(constellationL.frame) , 5, 60, 60)];
        constellationIV.layer.masksToBounds = YES;
        constellationIV.layer.cornerRadius = 30;
        [constellationIV sd_setImageWithURL:[NSURL URLWithString:@"https://www.youlinzj.cn/media/youlin/res/default/xingzuo/08.png"] placeholderImage:[UIImage imageNamed:@"error.png"] options:SDWebImageAllowInvalidSSLCertificates];
        _constellationIV = constellationIV;
        [bgV2 addSubview:constellationIV];
    }
    return self;
}

- (void) setWeatherInfo:(NSDictionary *)weatherInfo
{
    _weatherInfo = weatherInfo;

    NSLog(@"weatherInfo = %@",_weatherInfo);
    /**
     *    "after_day_temperature" = 21;
     "after_night_temperature" = 13;
     constellation = "https://www.youlinzj.cn/media/youlin/res/default/xingzuo/08.png";
     "day_temperature" = 25;
     info = "\U6674";
     luck = " ssss2";
     "night_temperature" = 14;
     temperature = 17;
     "tomorrow_day_temperature" = 25;
     */
    _addressL.text = [_weatherInfo valueForKey:@"city_name"];
    _temperatureL.text = [_weatherInfo valueForKey:@"temperature"];
    
    NSString* info = [_weatherInfo valueForKey:@"info"];
    if([info rangeOfString:@"小雨"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"cloud_drizzle.png"];
    }
    else if([info rangeOfString:@"阵雨"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"cloud_lightning.png"];
    }
    else if([info rangeOfString:@"阴"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"cloud_sun.png"];
    }
    else if([info rangeOfString:@"雨"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"cloud_rain.png"];
    }
    else if([info rangeOfString:@"雪"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"cloud_snow.png"];
    }
    else if([info rangeOfString:@"雾"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"cloud_fog.png"];
    }
    else if([info rangeOfString:@"云"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"cloud.png"];
    }
    else if([info rangeOfString:@"冰雹"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"cloud_hail.png"];
    }
    else if([info rangeOfString:@"雷"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"cloud_lightning.png"];
    }
    else if([info rangeOfString:@"晴"].location != NSNotFound)
    {
        _infoIV.image = [UIImage imageNamed:@"sun.png"];
    }

    NSInteger dayT = [[weatherInfo valueForKey:@"day_temperature"] integerValue];
    NSInteger nightT = [[weatherInfo valueForKey:@"night_temperature"] integerValue];
    NSInteger lowT = dayT < nightT ? dayT : nightT;
    NSInteger highT = dayT < nightT ? nightT : dayT;
    NSString* infoStr = [NSString stringWithFormat:@"%@   %ld°/%ld°",info, lowT, highT];
    _infoL.text = infoStr;

    NSInteger dayTomorrowT = [[weatherInfo valueForKey:@"tomorrow_day_temperature"] integerValue];
    NSInteger nightTomorrowT = [[weatherInfo valueForKey:@"tomorrow_night_temperature"] integerValue];
    NSInteger lowTomorrowT = dayTomorrowT < nightTomorrowT ? dayTomorrowT : nightTomorrowT;
    NSInteger highTomorrowT = dayTomorrowT > nightTomorrowT ? dayTomorrowT : nightTomorrowT;
    NSString* tommottowStr = [NSString stringWithFormat:@"%ld°/%ld°",lowTomorrowT, highTomorrowT];
    _tomorrowTL.text = tommottowStr;
    
    NSInteger dayAfterT = [[weatherInfo valueForKey:@"after_day_temperature"] integerValue];
    NSInteger nightAfterT = [[weatherInfo valueForKey:@"after_night_temperature"] integerValue];
    NSInteger lowAfterT = dayAfterT < nightAfterT ? dayAfterT : nightAfterT;
    NSInteger highAfterT = dayAfterT > nightAfterT ? dayAfterT : nightAfterT;

    NSString* afterStr = [NSString stringWithFormat:@"%ld°/%ld°",lowAfterT, dayAfterT];
    _afterTomTL.text = afterStr;
    
    
    _constellationL.text = [[_weatherInfo valueForKey:@"luck"] substringWithRange:NSMakeRange(0, 30)];
    [_constellationIV sd_setImageWithURL:[NSURL URLWithString:[_weatherInfo valueForKey:@"constellation"]] placeholderImage:[UIImage imageNamed:@"error.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
}


#pragma mark -点击
- (void)weatherGesture
{
    NSInteger weatherId = [[_weatherInfo valueForKey:@"weatherId"] integerValue];
    [_deleagate intoWeatherDetail:weatherId];
}

- (CAGradientLayer *)shadowAsInverse
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0, 0, CGRectGetWidth(weatherV.frame), 240 );
    newShadow.frame = newShadowFrame;
    //添加渐变的颜色组合（颜色透明度的改变）
//    newShadow.colors = [NSArray arrayWithObjects:
//                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0] CGColor] ,
//                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.1] CGColor],
//                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.2] CGColor],
//                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.3] CGColor],
//                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.4] CGColor],
//                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.5] CGColor],
//                        nil];
    newShadow.colors = [NSArray arrayWithObjects:
                        (id)[[UIColor colorWithRed:0/255.0 green:91/255.0 blue:144/255.0 alpha:1] CGColor],
                        (id)[[UIColor colorWithRed:5/255.0 green:121/255.0 blue:177/255.0 alpha:1] CGColor],
                        (id)[[UIColor colorWithRed:10/255.0 green:153/255.0 blue:210/255.0 alpha:1] CGColor],
                        nil];
    
    return newShadow;
}

@end
