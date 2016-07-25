//
//  FriendViewCell.h
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friends.h"

@interface FriendViewCell : UITableViewCell

// 头像
@property(strong, nonatomic) UIImageView* iconIV;
// 昵称
@property(strong, nonatomic) UILabel* nickL;
// 门牌地址
@property(strong, nonatomic) UILabel* addressL;
// 职业
@property(strong, nonatomic) UILabel* professionL;


@property(strong, nonatomic)Friends* friendsData;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
