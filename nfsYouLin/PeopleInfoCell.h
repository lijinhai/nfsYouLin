//
//  PeopleInfoCell.h
//  nfsYouLin
//
//  Created by Macx on 16/9/9.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleInfoCell : UITableViewCell

@property(strong, nonatomic) UILabel* contentL;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
