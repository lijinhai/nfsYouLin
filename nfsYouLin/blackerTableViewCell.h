//
//  blackerTableViewCell.h
//  nfsYouLin
//
//  Created by jinhai on 16/8/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "blackerInfo.h"

@interface blackerTableViewCell : UITableViewCell


// 头像
@property(strong, nonatomic) UIImageView* iconIV;
// 昵称
@property(strong, nonatomic) UILabel* nickL;
// 门牌地址
@property(strong, nonatomic) UILabel* addressL;
// 职业
@property(strong, nonatomic) UILabel* professionL;


@property(strong, nonatomic)blackerInfo* blackerData;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
