//
//  multiTableViewCell.h
//  nfsYouLin
//
//  Created by Macx on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"
#import "NCellDelegate.h"

//@protocol cellDelegate <NSObject>
//
//- (void)showCircularImageViewWithImage:(UIImage*) image;
//@end


@interface multiTableViewCell : UITableViewCell <NSURLSessionDataDelegate>
@property(strong, nonatomic) UILabel* nameLabel;
@property(strong, nonatomic) UILabel* phoneLabel;
@property(strong, nonatomic) UIImageView* headIV;


// 签到按钮
@property(strong, nonatomic) UIButton* signButton;

/* 积分 */
@property(strong, nonatomic) UIControl* integralView;
@property(strong, nonatomic) UILabel* integralLabel;
@property(nonatomic, assign) NSInteger integralCount;
/* 	发布 */
@property(strong, nonatomic) UIControl* publishView;
@property(strong, nonatomic) UILabel* publishLable;
@property(nonatomic, assign) NSInteger publishCount;
/* 收藏 */
@property(strong, nonatomic) UIControl* favoriteView;
@property(strong, nonatomic) UILabel* favoriteLabel;
@property(nonatomic, assign) NSInteger favoriteCount;

@property (nonatomic,assign) id<cellDelegate> delegate;


@property (nonatomic, strong) Users* userData;

@end
