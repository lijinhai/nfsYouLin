//
//  DetailListCell.m
//  nfsYouLin
//
//  Created by Macx on 16/9/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DetailListCell.h"

@implementation DetailListCell
{
    UILabel* _actionL;
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
        UILabel* actionL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, CGRectGetHeight(self.contentView.frame))];
        actionL.textColor = [UIColor whiteColor];
        actionL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:actionL];
        _actionL = actionL;
    }
    
    return self;
}

- (void)setAction:(NSString *)action
{
    _action = action;
    _actionL.text = _action;
}


@end
