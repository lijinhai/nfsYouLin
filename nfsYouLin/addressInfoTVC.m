//
//  addressInfoTVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/14.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "addressInfoTVC.h"
#import "StringMD5.h"
#import "HeaderFile.h"

@implementation addressInfoTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dataV:(NSDictionary *)dic
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
     
        // 审核状态
        CGSize audiSize = [StringMD5 sizeWithString:@"哈哈哈哈哈哈哈哈" font:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(CGRectGetWidth(self.contentView.frame),50)];
        UILabel* audiLabel = [[UILabel alloc] initWithFrame:CGRectMake(120,28, audiSize.width, audiSize.height)];
        audiLabel.font =[UIFont systemFontOfSize:10];
        self.audiL = audiLabel;
        // 审核
        UIImageView* iconView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 30, 10, 10)];
        iconView.layer.masksToBounds = YES;
        self.audiIV = iconView;
        if([[dic valueForKey:@"keyaudit"] isEqualToString:@"1"])
        {
            
            audiLabel.text = @"审核通过";
            audiLabel.textColor = UIColorFromRGB(0x00A600);
            iconView.image=[UIImage imageNamed:@"shenhetongguo"];
        }else{
            
            audiLabel.textColor =[UIColor redColor];
            audiLabel.text = @"等待审核";
            iconView.image=[UIImage imageNamed:@"dengdaishenhe"];
        }
        [self.contentView addSubview:iconView];
        [self.contentView addSubview:audiLabel];
        // 详细地址
        CGSize addressSize = [StringMD5 sizeWithString:@"哈哈哈哈哈哈哈哈" font:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(CGRectGetWidth(self.contentView.frame),50)];
        UILabel* addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,8, addressSize.width+150, addressSize.height)];
        
        addressLabel.font =[UIFont systemFontOfSize:12];
        addressLabel.enabled = NO;
        addressLabel.text=[dic valueForKey:@"keyaddress"];
        self.addressL = addressLabel;
        [self.contentView addSubview:addressLabel];
        
        // 选择
         UIButton* selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-20, 18, 20, 20)];
         selectBtn.layer.masksToBounds = YES;
         selectBtn.layer.cornerRadius = 10;
        if([[dic valueForKey:@"keyprimary"] isEqualToString:@"0"])
        {
            
            [selectBtn setImage:[UIImage imageNamed:@"btn_weixuanzhong_b"] forState:UIControlStateNormal];
        }else{
        
            [selectBtn setImage:[UIImage imageNamed:@"btn_xuanzhong_a"] forState:UIControlStateNormal];
        }
        [self.contentView addSubview:selectBtn];
        
        
    }
    return self;
}

@end
