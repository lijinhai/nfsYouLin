//
//  FriendViewCell.m
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FriendViewCell.h"
#import "UIImageView+WebCache.h"
#import "StringMD5.h"

@implementation FriendViewCell

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
        UILabel* addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 10,CGRectGetMaxY(nick.frame), addressSize.width, addressSize.height)];
        
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


- (void) setFriendsData:(Friends *)friendsData
{
    _friendsData = friendsData;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:_friendsData.iconAddr] placeholderImage:[UIImage imageNamed:@"account.png"] options:SDWebImageAllowInvalidSSLCertificates];
    self.nickL.text = friendsData.nick;
    CGSize profrssionSize;
    NSInteger status = [friendsData.publicStatus integerValue];
    switch (status) {
        case 1:
        {
            self.addressL.text = @"未公开";
            profrssionSize = [StringMD5 sizeWithString:@"未公开" font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(80,50)];
            self.professionL.text = @"未公开";
             self.professionL.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 15 - profrssionSize.width, 30, profrssionSize.width, profrssionSize.height);
            break;
        }
        case 2:
        {
            self.addressL.text = friendsData.houseAddr;
            profrssionSize = [StringMD5 sizeWithString:@"未公开" font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(80,50)];
            self.professionL.text = @"未公开";
            self.professionL.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 15 - profrssionSize.width, 30, profrssionSize.width, profrssionSize.height);
            break;
        }
        case 3:
        {
            self.addressL.text = @"未公开";
            if([friendsData.profession isEqual:[NSNull null]])
            {
                self.professionL.text = @"未设置";
                profrssionSize = [StringMD5 sizeWithString:@"未设置" font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(80,50)];
            }
            else
            {
                self.professionL.text = friendsData.profession;
                profrssionSize = [StringMD5 sizeWithString:friendsData.profession font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(80,50)];
            }
            self.professionL.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 15 - profrssionSize.width, 30, profrssionSize.width, profrssionSize.height);
            break;
        }
        case 4:
        {
            self.addressL.text = _friendsData.houseAddr;
            if([friendsData.profession isEqual:[NSNull null]])
            {
                self.professionL.text = @"未设置";
                profrssionSize = [StringMD5 sizeWithString:@"未设置" font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(80,50)];
            }
            else
            {
                self.professionL.text = friendsData.profession;
                profrssionSize = [StringMD5 sizeWithString:friendsData.profession font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(80,50)];
            }
            self.professionL.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 15 - profrssionSize.width, 30, profrssionSize.width, profrssionSize.height);
            break;
        }

        default:
        {
            break;
        }
    }

}


@end
