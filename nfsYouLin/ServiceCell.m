//
//  ServiceCell.m
//  nfsYouLin
//
//  Created by Macx on 16/9/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ServiceCell.h"
#import "HeaderFile.h"

@implementation ServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _serviceView = [[ServiceView alloc] initWithFrame:CGRectMake(20, 20, screenWidth - 40, 250)];
        [self.contentView addSubview:_serviceView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _serviceView.backgroundColor = [UIColor whiteColor];;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _serviceView.backgroundColor = [UIColor whiteColor];;
}

@end
