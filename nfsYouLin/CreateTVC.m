//
//  CreateTVC.m
//  Test3
//
//  Created by Macx on 16/8/10.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "CreateTVC.h"

@implementation CreateTVC
{
    UILabel* limitLabel;
    
    CGFloat startW;
    CGFloat endW;
    CGFloat addressW;

    UIImageView* startIV;
    UIImageView* endIV;
    UIImageView* addressIV;

}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        if([reuseIdentifier isEqualToString:@"limit"])
        {
            limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame), 2, 60, CGRectGetHeight(self.contentView.frame))];
            limitLabel.font = [UIFont systemFontOfSize:15];

            limitLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:limitLabel];
        }
        else if([reuseIdentifier isEqualToString:@"start"])
        {
            
            startW = CGRectGetWidth(self.contentView.frame);
            UILabel* startL = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, startW, CGRectGetHeight(self.contentView.frame))];
//            startL.backgroundColor = [UIColor blueColor];
            startL.font = [UIFont systemFontOfSize:15];
            startL.text = @"开始时间";
            startL.enabled = NO;
            startL.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:startL];
            self.startL = startL;
            
            UIImageView* emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) + 5, 15, 20, 20)];
            emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
            emptyIV.layer.masksToBounds = YES;
            emptyIV.layer.cornerRadius = 10;
            [self.contentView addSubview:emptyIV];
            startIV = emptyIV;
            
            UIImageView* timeIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(emptyIV.frame) + 5, 15, 20, 20)];
            timeIV.layer.masksToBounds = YES;
            timeIV.layer.cornerRadius = 10;
            timeIV.image = [UIImage imageNamed:@"pic_shijina.png"];
            [self.contentView addSubview:timeIV];
        }
        else if([reuseIdentifier isEqualToString:@"end"])
        {
            endW = CGRectGetWidth(self.contentView.frame);
            UILabel* endL = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, endW, CGRectGetHeight(self.contentView.frame))];
            endL.font = [UIFont systemFontOfSize:15];
            endL.text = @"结束时间";
            endL.enabled = NO;
            endL.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:endL];
            self.endL = endL;
            
            UIImageView* emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) + 5, 15, 20, 20)];
            emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
            emptyIV.layer.masksToBounds = YES;
            emptyIV.layer.cornerRadius = 10;
            [self.contentView addSubview:emptyIV];
            endIV = emptyIV;
            
            UIImageView* timeIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(emptyIV.frame) + 5, 15, 20, 20)];
            timeIV.layer.masksToBounds = YES;
            timeIV.layer.cornerRadius = 10;
            timeIV.image = [UIImage imageNamed:@"pic_shijina.png"];
            [self.contentView addSubview:timeIV];
        }
        else if([reuseIdentifier isEqualToString:@"address"])
        {
            addressW = CGRectGetWidth(self.contentView.frame);
            UILabel* addressL = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, addressW, CGRectGetHeight(self.contentView.frame))];
            addressL.font = [UIFont systemFontOfSize:15];
            addressL.numberOfLines = 2;
            addressL.text = @"详细地址";
            addressL.enabled = NO;
            addressL.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:addressL];
            self.addressL = addressL;
            
            UIImageView* emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) + 30, 15, 20, 20)];
            emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
            emptyIV.layer.masksToBounds = YES;
            emptyIV.layer.cornerRadius = 10;
            [self.contentView addSubview:emptyIV];
            addressIV = emptyIV;
        }

        
    }
    
    return self;
}

- (void) setWhere:(NSInteger )where
{
    _where = where;
    switch (where) {
        case 0:
            limitLabel.text = @"本小区";
            break;
        case 1:
            limitLabel.text = @"周边";
            break;
        case 2:
            limitLabel.text = @"同城";
            break;
            
        default:
            break;
    }
}


- (void) setStartB:(BOOL)startB
{
    _startB = startB;
    if(_startB)
    {
        CGRect rect = self.startL.frame;
        rect.size.width = startW + 20;
        self.startL.frame = rect;
        startIV.hidden = YES;
    }
    else
    {
        CGRect rect = self.startL.frame;
        rect.size.width = startW - 5;
        self.startL.frame = rect;
        startIV.hidden = NO;
    }
}


- (void)setEndB:(BOOL)endB
{
    _endB = endB;
    if(_endB)
    {
        CGRect rect = self.endL.frame;
        rect.size.width = endW + 20;
        self.endL.frame = rect;
        endIV.hidden = YES;
    }
    else
    {
        CGRect rect = self.endL.frame;
        rect.size.width = endW - 5;
        self.endL.frame = rect;
        endIV.hidden = NO;
    }
    
}

- (void)setAddressB:(BOOL)addressB
{
    _addressB = addressB;
    if(_addressB)
    {
        CGRect rect = self.addressL.frame;
        rect.size.width = addressW - 40;
        self.addressL.frame = rect;
        addressIV.hidden = YES;
    }
    else
    {
        CGRect rect = self.addressL.frame;
        rect.size.width = addressW - 75;
        self.addressL.frame = rect;
        addressIV.hidden = NO;
    }
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
