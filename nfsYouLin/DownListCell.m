//
//  DownListCell.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DownListCell.h"
#import "HeaderFile.h"

@implementation DownListCell
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
        _actionL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth/2-10, CGRectGetHeight(self.contentView.frame))];
        NSLog(@"_actionL 宽度 %f",CGRectGetWidth(_actionL.frame));
        _actionL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_actionL];
    }
    
    return self;
}

- (void)setAction:(NSString *)action
{
    _action = action;
    if([_defaultV isEqualToString:action])
    {
        
        _actionL.textColor = UIColorFromRGB(0xFFBA02);
    }else{
        
        _actionL.textColor = UIColorFromRGB(0x000000);
    }
    _actionL.text = _action;
}


@end
