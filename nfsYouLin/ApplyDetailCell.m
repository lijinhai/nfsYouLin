//
//  ApplyDetailCell.m
//  nfsYouLin
//
//  Created by Macx on 16/8/30.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ApplyDetailCell.h"
#import "UIImageView+WebCache.h"

@implementation ApplyDetailCell

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
        if([reuseIdentifier isEqualToString:@"manager"])
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSString* portrait = [defaults stringForKey:@"portrait"];
            NSString* nick = [defaults stringForKey:@"nick"];
            
            NSURL* iconUrl = [NSURL URLWithString:portrait];
            NSLog(@"nick = %@,portrait = %@",nick ,portrait);
            
            UIImageView* iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 46, 46)];
            iconIV.layer.masksToBounds = YES;
            iconIV.layer.cornerRadius = 23;
            [iconIV sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
            [self.contentView addSubview:iconIV];
            
            UILabel* nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconIV.frame) + 10, 0, CGRectGetWidth(self.contentView.frame) - 50, 50)];
            nameL.textColor = [UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:0 / 255.0 alpha:1];
            nameL.text = nick;
            nameL.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:nameL];
            
            UIImageView* managerIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 50, 0, 50, 50)];
            managerIV.image = [UIImage imageNamed:@"ic_ng_member_admin.png"];
            [self.contentView addSubview:managerIV];
           
        }
        else if([reuseIdentifier isEqualToString:@"other"])
        {
            UIImageView* headIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
            headIV.layer.masksToBounds = YES;
            headIV.layer.cornerRadius = 15;
            self.headIV = headIV;
            [self.contentView addSubview:headIV];
            
            UILabel* detailL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headIV.frame) + 5, 0, CGRectGetWidth(self.contentView.frame) - 50, 50)];
            detailL.textColor = [UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:0 / 255.0 alpha:1];
            detailL.textAlignment = NSTextAlignmentLeft;
            self.detailL = detailL;
            [self.contentView addSubview:detailL];
        }
        
    }
    return self;
}


- (void) setDetailDict:(NSDictionary *)detailDict
{
    _detailDict = detailDict;
    NSString* portrait = [detailDict valueForKey:@"userPortrait"];
    NSURL* headUrl = [NSURL URLWithString:portrait];
    [self.headIV sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
    NSString* userNick = [detailDict valueForKey:@"userNick"];
    NSString* totalNum = [detailDict valueForKey:@"total"];
    NSString* childNum = [detailDict valueForKey:@"enrollNeCount"];
    NSString* detail = [NSString stringWithFormat:@"%@  共%@人  (小孩： %@人)",userNick, totalNum,childNum];
    self.detailL.text = detail;
}

@end
