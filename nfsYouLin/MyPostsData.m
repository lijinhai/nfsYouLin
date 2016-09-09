//
//  MyPostsData.m
//  nfsYouLin
//
//  Created by jinhai on 16/8/26.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "MyPostsData.h"

@implementation MyPostsData

- (id) initWithDict: (NSDictionary*) dict
{
    self = [super init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

@end
