//
//  PeopleInfoCell.m
//  nfsYouLin
//
//  Created by Macx on 16/9/9.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PeopleInfoCell.h"

@implementation PeopleInfoCell
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
        
        _contentL = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 80, 50)];
        [self.contentView addSubview:_contentL];
    }
    
    return self;
}

@end
