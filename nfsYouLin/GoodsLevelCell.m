//
//  GoodsLevelCell.m
//  nfsYouLin
//
//  Created by Macx on 16/8/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "GoodsLevelCell.h"

@implementation GoodsLevelCell

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
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:222/255.0 blue:31/255.0 alpha:1];

    if(self)
    {
        UILabel* levelL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) / 2, CGRectGetHeight(self.contentView.frame))];
        levelL.textColor = [UIColor whiteColor];
        levelL.textAlignment = NSTextAlignmentCenter;
        self.levelL = levelL;
        [self.contentView addSubview:levelL];
    }
    return self;
}

@end
