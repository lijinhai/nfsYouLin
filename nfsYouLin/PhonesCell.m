//
//  PhonesCell.m
//  nfsYouLin
//
//  Created by Macx on 16/9/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PhonesCell.h"
#import "HeaderFile.h"
@implementation PhonesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.phoneL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        self.phoneL.textAlignment = NSTextAlignmentCenter;
        self.phoneL.textColor = MainColor;
        [self.contentView addSubview:self.phoneL];
    }
    return self;
}

@end
