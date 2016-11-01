//
//  PushNoticeCell.m
//  nfsYouLin
//
//  Created by Macx on 2016/10/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PushNoticeCell.h"
#import "HeaderFile.h"
#import "UIImageView+WebCache.h"
#import "JSONKit.h"

@implementation PushNoticeCell
{
    UIImageView* iconIV;
    UILabel* titleL;
    UILabel* contentL;
    UILabel* dateL;
    
    UIView* badge;
}


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [self.contentView addSubview:iconIV];
        
        badge = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconIV.frame) - 8, CGRectGetMinY(iconIV.frame), 8, 8)];
        badge.backgroundColor = [UIColor redColor];
        badge.layer.cornerRadius = 4;
        badge.layer.masksToBounds = YES;
        [self.contentView addSubview:badge];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconIV.frame) + 10, 10, 150, 30)];
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:titleL];
        
        dateL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 70, 10, 60, 30)];
        dateL.textAlignment = NSTextAlignmentLeft;
        dateL.font = [UIFont systemFontOfSize:12];
        dateL.enabled = NO;
        [self.contentView addSubview:dateL];
        
        contentL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleL.frame), CGRectGetMaxY(titleL.frame), screenWidth - 100 - CGRectGetMaxX(iconIV.frame) - 20, 20)];
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.font = [UIFont systemFontOfSize:13];
        contentL.enabled = NO;
        [self.contentView addSubview:contentL];
        
    }
    
    return self;
}

- (void) setNoticeDict:(NSDictionary *)noticeDict
{
    _noticeDict = noticeDict;
    
    NSInteger type = [[_noticeDict valueForKey:@"type"] integerValue];
    NSLog(@"type == %ld",type);
    if(type == 0)
    {
        [badge removeFromSuperview];
    }
    else
    {
        [self.contentView addSubview:badge];
    }
    
    NSString* contentStr = [_noticeDict valueForKey:@"content"];
    NSDictionary* content =  (NSDictionary*)[contentStr objectFromJSONString];
    NSInteger pushTime;
    NSLog(@"content = %@",content);

    NSInteger pushType = [[content valueForKey:@"pushType"] integerValue];
    
    switch (pushType) {
        case 0:
            break;
        case 1:
            break;
        case 2:
        {
            titleL.text = [content valueForKey:@"title"];
            contentL.text = [content valueForKey:@"content"];
            pushTime = [[content valueForKey:@"pushTime"] integerValue];
            break;
        }
        case 3:
        {
            titleL.text = [content valueForKey:@"pushTitle"];
            contentL.text = [content valueForKey:@"pushContent"];
            pushTime = [[content valueForKey:@"pushTime"] integerValue];
            break;
        }
        case 4:
            break;
        case 5:
            break;
        case 6:
        {
            titleL.text = [content valueForKey:@"title"];
            contentL.text = [content valueForKey:@"message"];
            pushTime = [[content valueForKey:@"pushTime"] integerValue];
            break;
        }
        default:
            break;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日";
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:pushTime / 1000];
    NSString *dateStr = [formatter stringFromDate:date];
    dateL.text = dateStr;
    NSLog(@"dateStr = %@",dateStr);
    
    NSURL* iconUrl = [NSURL URLWithString:[content valueForKey:@"userAvatar"]];
    [iconIV sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
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
