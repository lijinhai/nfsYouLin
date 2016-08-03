//
//  GoodsCollectionViewCell.h
//  nfsYouLin
//
//  Created by jinhai on 16/8/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsInfo.h"

@interface GoodsCollectionViewCell : UICollectionViewCell

// 商品图片
@property(strong, nonatomic) UIImageView* iconIV;
// 商品名称
@property(strong, nonatomic) UILabel* nameL;
// 积分数值
@property(strong, nonatomic) UILabel* pointsVL;
// 商品数量
@property(strong, nonatomic) UILabel* countL;

// 兑换商品列表
@property(strong, nonatomic) NSMutableArray* goodsArray;
@property(strong, nonatomic)goodsInfo* goodsData;

- (id)initWithFrame:(CGRect)frame;
@end
