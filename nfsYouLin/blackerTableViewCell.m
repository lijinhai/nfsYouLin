//
//  blackerTableViewCell.m
//  nfsYouLin
//
//  Created by jinhai on 16/8/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//
#define SCREEN_WIDTH   ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)
#import "blackerTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "StringMD5.h"

@implementation blackerTableViewCell

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
    NSLog(@"initWithStyle is ***********");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        // 头像
        UIImageView* iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 25;
        self.iconIV = iconView;
        [self.contentView addSubview:iconView];
        
        // 昵称
        CGSize nickSize = [StringMD5 sizeWithString:@"哈哈哈哈哈哈哈哈" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)  / 2,40)];
        UILabel* nick = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 10, 20, nickSize.width, 20)];
        nick.font =[UIFont systemFontOfSize:15];
        self.nickL = nick;
        [self.contentView addSubview:nick];
        
        // 地址
        CGSize addressSize = [StringMD5 sizeWithString:@"哈哈哈哈哈哈哈哈" font:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(CGRectGetWidth(self.contentView.frame) - 200,50)];
        UILabel* addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 10,CGRectGetMaxY(nick.frame)+2, addressSize.width, addressSize.height)];
        
        addressLabel.font =[UIFont systemFontOfSize:10];
        addressLabel.enabled = NO;
        self.addressL = addressLabel;
        [self.contentView addSubview:addressLabel];
        
        // 职业
        UILabel* professionL = [[UILabel alloc] init];
        professionL.font = [UIFont systemFontOfSize:12];
        self.professionL = professionL;
        [self.contentView addSubview:professionL];
        
        
    }
    return self;
}


- (void) setBlackerData:(blackerInfo *)blackerData
{

    _blackerData = blackerData;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:_blackerData.headUrl] placeholderImage:[UIImage imageNamed:@"account.png"] options:SDWebImageAllowInvalidSSLCertificates];
    self.nickL.text = _blackerData.nickStr;
    self.addressL.text = _blackerData.addressStr;
    CGSize profrssionSize;
    self.professionL.text = _blackerData.vocationStr;
    profrssionSize= [self.professionL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil]];
    self.professionL.frame = CGRectMake(SCREEN_WIDTH-profrssionSize.width-15, 30, profrssionSize.width, profrssionSize.height);
    
}

@end
