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


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic)FriendsVC* friendVC;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *dbPath;
@property (strong, nonatomic) FMDatabase *db;

@end

