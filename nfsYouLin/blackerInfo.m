//
//  blackerInfo.m
//  nfsYouLin
//
//  Created by jinhai on 16/8/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "blackerInfo.h"

@implementation blackerInfo

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
