//
//  blackerInfo.h
//  nfsYouLin
//
//  Created by jinhai on 16/8/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface blackerInfo : NSObject


// 头像URL
@property(nonatomic,strong)NSString* headUrl;

// 昵称
@property(nonatomic,strong)NSString* nickStr;

// 地址
@property(nonatomic,strong)NSString* addressStr;

// 职业
@property(nonatomic,strong)NSString* vocationStr;

- (id) initWithDict:(NSDictionary*)dict;
@end
