//
//  NeighborData.m
//  Neighbor2
//
//  Created by Macx on 16/5/27.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "NeighborData.h"

@implementation NeighborData

- (id) initWithDict: (NSDictionary*) dict
{
    self = [super init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

- (id) setWithDict:(NSDictionary*) dict
{
    if(self)
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
