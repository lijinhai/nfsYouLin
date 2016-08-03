//
//  DiscoveryViewCell.m
//  nfsYouLin
//
//  Created by Macx on 16/8/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DiscoveryViewCell.h"

@implementation DiscoveryViewCell

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
        self.circle = [[UIImageView alloc] initWithFrame:CGRectMake(45, 32, 6, 6)];
        self.circle.layer.masksToBounds = YES;
        self.circle.layer.cornerRadius = 3;
        self.circle.image = [UIImage imageNamed:@"hongdian"];
        


    }
    return self;
}


- (void) setMessage:(BOOL)isMessage
{
    if(isMessage)
    {
        [self.textLabel addSubview:self.circle];
    }
    else
    {
        [self.circle removeFromSuperview];
    }
}


@end
