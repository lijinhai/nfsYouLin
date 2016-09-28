//
//  WeatherCell.m
//  nfsYouLin
//
//  Created by Macx on 16/9/26.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "WeatherCell.h"

@implementation WeatherCell
{
    UILabel* _titleL;
    UIImageView* _titleIV;
    
    UILabel* _weekL;
    UILabel* _weatherL;
    UILabel* _windL;
    UILabel* _lowTL;
    UILabel* _highTL;
}


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        if([reuseIdentifier isEqualToString:@"yes"])
        {
            UILabel* weekL = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 45, 20)];
            weekL.textColor = [UIColor whiteColor];
            weekL.textAlignment = NSTextAlignmentCenter;
            weekL.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:weekL];
            _weekL = weekL;
            
            UIView* line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weekL.frame) + 5, 15, 0.5, 20)];
            line1.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:line1];
            
            UILabel* weatherL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line1.frame) + 5, 15, 60, 20)];
            weatherL.textColor = [UIColor whiteColor];
            weatherL.textAlignment = NSTextAlignmentLeft;
            weatherL.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:weatherL];
            _weatherL = weatherL;
            
            UILabel* windL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5 - 35, 15, 70, 20)];
            windL.textColor = [UIColor whiteColor];
            windL.textAlignment = NSTextAlignmentCenter;
            windL.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:windL];
            _windL = windL;
            
            UILabel* lowTL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 90, 15, 30, 20)];
            lowTL.textColor = [UIColor whiteColor];
            lowTL.textAlignment = NSTextAlignmentLeft;
            lowTL.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:lowTL];
            _lowTL = lowTL;
            
            UIView* line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lowTL.frame) + 5, 15, 0.5, 20)];
            line2.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:line2];
            
            UILabel* highTL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line2.frame) + 5, 15, 30, 20)];
            highTL.textColor = [UIColor whiteColor];
            highTL.textAlignment = NSTextAlignmentRight;
            highTL.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:highTL];
            _highTL = highTL;

        }
        else if([reuseIdentifier isEqualToString:@"no"])
        {
            UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5 - 45, 0, 90, 20)];
            titleL.textColor = [UIColor whiteColor];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:titleL];
            _titleL = titleL;
            
            UIImageView* titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5 - 10, 25, 20, 20)];
            titleIV.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:titleIV];
            _titleIV = titleIV;
        }
        
    }
    return self;
}

- (void) setWeatherInfo:(NSDictionary *)weatherInfo
{
    _weatherInfo = weatherInfo;
    
    _weekL.text = [NSString stringWithFormat:@"星期%@",[_weatherInfo valueForKey:@"week"]];

    _weatherL.text = [[[_weatherInfo valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:1];
    _windL.text = [[[_weatherInfo valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:3];
    
    NSInteger dayT = [[[[_weatherInfo valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:2] integerValue];
    NSInteger nightT = [[[[_weatherInfo valueForKey:@"info"] valueForKey:@"night"] objectAtIndex:2] integerValue];
    NSInteger lowT = dayT < nightT ? dayT : nightT;
    NSInteger highT = dayT > nightT ? dayT : nightT;
    _lowTL.text = [NSString stringWithFormat:@"%ld°",lowT];
    _highTL.text = [NSString stringWithFormat:@"%ld°",highT];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if([_title isEqualToString:@"查看未来几天"])
    {
        _titleIV.image = [UIImage imageNamed:@"icon_jiantou_xia.png"];
    }
    else if([_title isEqualToString:@"收起"])
    {
        _titleIV.image = [UIImage imageNamed:@"icon_jiantou_shang.png"];
    }
    
    _titleL.text = _title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
