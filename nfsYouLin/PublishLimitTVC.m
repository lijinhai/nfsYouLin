//
//  PublishLimitTVC.m
//  Test3
//
//  Created by Macx on 16/8/10.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PublishLimitTVC.h"

@implementation PublishLimitTVC
{
    UILabel* limitLabel;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame), 7, 60, CGRectGetHeight(self.contentView.frame))];
        limitLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:limitLabel];
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
