//
//  InviteRecordCell.m
//  nfsYouLin
//
//  Created by Macx on 16/9/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "InviteRecordCell.h"

@implementation InviteRecordCell
{
    UILabel* _dateL;
    UILabel* _timeL;
    UILabel* _phoneL;
    UILabel* _stateL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UILabel* dateL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) / 3, 25)];
        dateL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:dateL];
        _dateL = dateL;
        
        UILabel* timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, CGRectGetWidth(dateL.frame), 25)];
        timeL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeL];
        _timeL = timeL;
        
        UILabel* phoneL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateL.frame), 0, CGRectGetWidth(dateL.frame), 50)];
        phoneL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:phoneL];
        _phoneL = phoneL;
        
        UILabel* stateL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneL.frame), 0, CGRectGetWidth(phoneL.frame), 50)];
        stateL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:stateL];
        _stateL = stateL;
    }
    return self;
}

- (void) setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    
    NSInteger interval = [[_infoDict valueForKey:@"inv_time"] integerValue] / 1000;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSString* dateStr = [formatter stringFromDate:date];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* timeStr = [formatter stringFromDate:date];
    _dateL.text = dateStr;
    _timeL.text = timeStr;
    _phoneL.text = [_infoDict valueForKey:@"inv_phone"];
    NSInteger status =[[_infoDict valueForKey:@"inv_status"] integerValue];
    switch (status) {
        case 1:
            _stateL.text = @"邀请中";
            break;
        case 2:
            _stateL.text = @"邀请成功";
            break;
        case 3:
            _stateL.text = @"邀请失败";
            break;
            
        default:
            break;
    }
}

@end
