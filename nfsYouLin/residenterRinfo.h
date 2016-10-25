//
//  residenterRinfo.h
//  nfsYouLin
//
//  Created by jinhai on 16/10/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface residenterRinfo : NSObject
// 住户头像URL
@property(nonatomic,strong)NSString* headPicUrl;

// 住户昵称+小区名
@property(nonatomic,strong)NSString* nikeAndComm;

// 物业报修详情
@property(nonatomic,strong)NSString* repairDetailInfo;

// 报修时间长度
@property(nonatomic,strong)NSString* repairTime;

// 审核状态
@property(nonatomic,strong)NSString* auditStatus;

// 系统时间
@property(nonatomic,strong)NSString* systemTime;
@end
