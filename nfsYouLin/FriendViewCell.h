//
//  FriendViewCell.h
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friends.h"
#import "NCellDelegate.h"

@protocol FriendViewDelegate <NSObject>

-(void) longPressGesture:(NSInteger)blackId row:(NSInteger)row section:(NSInteger)section;

@end

@interface FriendViewCell : UITableViewCell<cellDelegate>

@property(strong, nonatomic) id<FriendViewDelegate> delegate;
@property(strong, nonatomic) id<cellDelegate> celldelegate;

@property(assign, nonatomic) NSInteger row;
@property(assign, nonatomic) NSInteger section;

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
