//
//  residenterRinfo.m
//  nfsYouLin
//
//  Created by jinhai on 16/10/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "residenterRinfo.h"

@implementation residenterRinfo

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
