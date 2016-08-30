//
//  ApplyDetailCell.h
//  nfsYouLin
//
//  Created by Macx on 16/8/30.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyDetailCell : UITableViewCell

@property(strong, nonatomic)UIImageView* headIV;
@property(strong, nonatomic)UILabel* detailL;
@property(strong, nonatomic)NSDictionary* detailDict;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
