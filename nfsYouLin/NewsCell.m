//
//  NewsCell.m
//  nfsYouLin
//
//  Created by Macx on 16/9/12.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"

@implementation NewsCell
{
    
    UIImageView* _mainTitleIV;
    UILabel* _mainTitleL;
    
    UILabel* _titleL;
    UIImageView* _titleIV;
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
        if([reuseIdentifier isEqualToString:@"otherId"])
        {
            UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth([UIScreen mainScreen].bounds) - 50 - 80, 50)];
            titleL.enabled = NO;
            titleL.numberOfLines = 0;
            _titleL = titleL;
            [self.contentView addSubview:titleL];
            
            
            UIImageView* titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame), 5, 50, 50)];
            _titleIV = titleIV;
            [self.contentView addSubview:titleIV];
        }
        else if([reuseIdentifier isEqualToString:@"titleId"])
        {
            self.contentView.layer.borderWidth = 1.5;
            self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            UIImageView* mainTitleIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth([UIScreen mainScreen].bounds) - 70 - 20, 130)];
            [self.contentView addSubview:mainTitleIV];
            
            UILabel* mainTitleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(mainTitleIV.frame), 50)];
            mainTitleL.backgroundColor = [UIColor blackColor];
            mainTitleL.alpha = 0.7;
            mainTitleL.textColor = [UIColor whiteColor];
            mainTitleL.numberOfLines = 2;
            [mainTitleIV addSubview:mainTitleL];
            
            _mainTitleL = mainTitleL;
            _mainTitleIV = mainTitleIV;
        }
    }
    
    return self;
}

- (void) setNewsInfo:(NSDictionary *)newsInfo
{
    _newsInfo = newsInfo;
    
    _titleL.text = [_newsInfo valueForKey:@"new_title"];
    NSString* iv = [_newsInfo valueForKey:@"new_small_pic"];
    [_titleIV sd_setImageWithURL:[NSURL URLWithString:iv] placeholderImage:[UIImage imageNamed:@"account.png"] options:SDWebImageAllowInvalidSSLCertificates];
}


- (void) setTitleNew:(NSDictionary *)titleNew
{
    _titleNew = titleNew;
    
    _mainTitleL.text = [_titleNew valueForKey:@"new_title"];
    NSString* iv = [_titleNew valueForKey:@"new_small_pic"];
    [_mainTitleIV sd_setImageWithURL:[NSURL URLWithString:iv] placeholderImage:[UIImage imageNamed:@"account.png"] options:SDWebImageAllowInvalidSSLCertificates];

}

@end

