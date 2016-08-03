//
//  goodsInfo.h
//  nfsYouLin
//
//  Created by jinhai on 16/8/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodsInfo : NSObject


// 图片URL
@property(nonatomic,strong)NSString* goodsPicUrl;
// 兑换数量
@property(nonatomic,strong)NSString* exchangeNums;

// 兑换积分
@property(nonatomic,strong)NSString* exchangePoints;

// 商品名称
@property(nonatomic,strong)NSString* goodsName;



- (id) initWithDict:(NSDictionary*)dict;
@end
