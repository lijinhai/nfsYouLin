//
//  GoodsCollectionViewCell.m
//  nfsYouLin
//
//  Created by jinhai on 16/8/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "StringMD5.h"
@implementation GoodsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        // 商品图片
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        // 商品名称
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 60, 20)];
        _nameL.font=[UIFont systemFontOfSize:14];
        // 积分数值
        _pointsVL = [[UILabel alloc] init];
        _pointsVL.font=[UIFont systemFontOfSize:14];
        // 商品数量
        _countL =[[UILabel alloc] init];
        _countL.textColor=[UIColor lightGrayColor];
        _countL.font=[UIFont systemFontOfSize:13];
        // 送达时间
        UILabel *sendTimeL=[[UILabel alloc] initWithFrame:CGRectMake(120, 50, 80, 22)];
        sendTimeL.backgroundColor=[UIColor redColor];
        sendTimeL.textColor=[UIColor whiteColor];
        sendTimeL.font=[UIFont systemFontOfSize:14];
        sendTimeL.textAlignment=NSTextAlignmentCenter;
        NSString* weedDayStr=[self getWeekTime];
        if([weedDayStr isEqualToString:@"星期六"]||[weedDayStr isEqualToString:@"星期日"]||[weedDayStr isEqualToString:@"星期五"])
        {
            
            sendTimeL.text=@"下周五送达";
        }else{
        
            sendTimeL.text=@"本周五送达";
        }
        UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        line.backgroundColor=[UIColor lightGrayColor];
        
        [self.contentView addSubview:line];
        [self.contentView addSubview:_iconIV];
        [self.contentView addSubview:_nameL];
        [self.contentView addSubview:sendTimeL];
        [self.contentView addSubview:_pointsVL];
        [self.contentView addSubview:_countL];
    }
    return self;
}



- (NSString *)getWeekTime
{
    NSString *weekDayStr = nil;
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger weekDay = [comp weekday];
    switch (weekDay) {
        case 1:
            weekDayStr = @"星期日";
            break;
        case 2:
            weekDayStr = @"星期一";
            break;
        case 3:
            weekDayStr = @"星期二";
            break;
        case 4:
            weekDayStr = @"星期三";
            break;
        case 5:
            weekDayStr = @"星期四";
            break;
        case 6:
            weekDayStr = @"星期五";
            break;
        case 7:
            weekDayStr = @"星期六";
            break;
        default:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
    
}


-(void) setGoodsData:(goodsInfo *)goodsData{

    _goodsData=goodsData;
    float scale=0.6;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:_goodsData.goodsPicUrl] placeholderImage:nil options:(SDWebImageAllowInvalidSSLCertificates) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconIV.frame = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
        self.iconIV.center=CGPointMake(55, 40);
    }];
      self.nameL.text=_goodsData.goodsName;
    
      self.pointsVL.text=[NSString stringWithFormat:@"%@%@",_goodsData.exchangePoints,@"积分"];
      CGSize sizep = [self.pointsVL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
      self.pointsVL.frame=CGRectMake(self.frame.size.width-sizep.width-10, 10, sizep.width, 20);
      self.pointsVL.textAlignment=NSTextAlignmentLeft;
    
      self.countL.text=[NSString stringWithFormat:@"%@%@",@"× ",_goodsData.exchangeNums];
      CGSize sizec = [self.pointsVL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
      self.countL.frame=CGRectMake(self.frame.size.width-sizec.width-9, 40, sizec.width, 20);
      self.countL.textAlignment=NSTextAlignmentRight;
      
}
@end
