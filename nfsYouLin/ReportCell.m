//
//  ReportCell.m
//  nfsYouLin
//
//  Created by Macx on 16/9/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ReportCell.h"

@implementation ReportCell
{
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
        _selectedIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 30, 15, 20, 20)];
        _selectedIV.layer.masksToBounds = YES;
        _selectedIV.layer.cornerRadius = 10;
        _selectedIV.image = [UIImage imageNamed:@"btn_sex_duihao.png"];
        _selectedIV.hidden = YES;
        [self.contentView addSubview:_selectedIV];
    }
    
    return self;
}


@end
