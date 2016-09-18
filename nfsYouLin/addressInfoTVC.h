//
//  addressInfoTVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/14.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addressInfoTVC : UITableViewCell
// 审核图片
@property(strong, nonatomic) UIImageView* audiIV;
// 审核状态
@property(strong, nonatomic) UILabel* audiL;
// 详细地址
@property(strong, nonatomic) UILabel* addressL;
// 选择状态图片
@property(strong, nonatomic) UIImageView* selectIV;

@property(strong, nonatomic) NSDictionary* dic;
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dataV:(NSDictionary *)dic;
@end
