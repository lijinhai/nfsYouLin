//
//  SellerCVCell.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerInfo.h"

@interface SellerCVCell : UICollectionViewCell

// 商家图片
@property(strong, nonatomic) UIImageView* sellerIV;
// 商家名称
@property(strong, nonatomic) UILabel* sellerNL;
// 商家位置
@property(strong, nonatomic) UILabel* sellerPL;
// 商家距离
@property(strong, nonatomic) UILabel* sellerDL;
// 商家评分
@property(strong, nonatomic) UILabel* sellerLL;
// 兑换商品列表
@property(strong, nonatomic) NSMutableArray* sellersArray;
@property(strong, nonatomic) SellerInfo* sellerData;

- (id)initWithFrame:(CGRect)frame;

@end
