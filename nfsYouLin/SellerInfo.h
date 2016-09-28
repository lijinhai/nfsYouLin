//
//  SellerInfo.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerInfo : NSObject

// 商家图片URL
@property(nonatomic,strong)NSString* sellerPicUrl;

// 商家名字
@property(nonatomic,strong)NSString* sellerName;

// 商家位置
@property(nonatomic,strong)NSString* sellerPosition;

// 商家距离
@property(nonatomic,strong)NSString* sellerDistance;

// 商家评级
@property(nonatomic,strong)NSString* sellerLevel;

// 商家唯一标示
@property(nonatomic,strong)NSString* sellerUuid;

- (id) initWithDict:(NSDictionary*)dict;
@end
