//
//  PublicLimitTVC.m
//  Test3
//
//  Created by Macx on 16/8/10.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PublicLimitTVC.h"

@implementation PublicLimitTVC

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame), 7, 60, CGRectGetHeight(self.contentView.frame))];
        self.limitLabel.text = @"本小区";
        self.limitLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.limitLabel];
    }
    
    return self;
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
