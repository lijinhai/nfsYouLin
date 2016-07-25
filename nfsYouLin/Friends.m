//
//  Friends.m
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "Friends.h"

@implementation Friends

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
