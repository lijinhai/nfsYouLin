//
//  JPushNotification.h
//  nfsYouLin
//
//  Created by Macx on 2016/10/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JPushNotificationDelegate <NSObject>

- (void) JPushNotificationWithDictory:(NSDictionary*)userInfo;

@end

@interface JPushNotification : NSObject

@property(strong, nonatomic) id<JPushNotificationDelegate> delegate;

- (void) JPshNotification:(NSDictionary*)userInfo;

@end
