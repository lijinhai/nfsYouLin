//
//  JPushNotification.m
//  nfsYouLin
//
//  Created by Macx on 2016/10/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "JPushNotification.h"



@implementation JPushNotification


- (void) JPshNotification:(NSDictionary*)userInfo
{
    [_delegate JPushNotificationWithDictory:userInfo];
}


@end
