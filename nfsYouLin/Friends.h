//
//  Friends.h
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friends : NSObject

// 邻居昵称
@property(nonatomic,strong)NSString* nick;
// 门牌号
@property(nonatomic,strong)NSString* houseAddr;

// 头像地址
@property(nonatomic,strong)NSString* iconAddr;

// 信息公开状态
@property(nonatomic,strong)NSString* publicStatus;

// 职业
@property(nonatomic,strong)NSString* profession;


// userId
@property(nonatomic,assign)NSInteger userId;


- (id) initWithDict:(NSDictionary*)dict;

@end
