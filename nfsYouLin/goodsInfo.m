//
//  goodsInfo.m
//  nfsYouLin
//
//  Created by jinhai on 16/8/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "goodsInfo.h"

@implementation goodsInfo

- (id) initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
