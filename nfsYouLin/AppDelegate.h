//
//  AppDelegate.h
//  nfsYouLin
//
//  Created by jinhai on 16/5/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "FriendsVC.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "NeighborTVC.h"
#import "JPushNotification.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property(strong, nonatomic)JPushNotification* notification;
@property(strong, nonatomic)FriendsVC* friendVC;
//@property (strong, nonatomic)NeighborTVC* neighborVC;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *dbPath;
@property (strong, nonatomic) FMDatabase *db;

@end

