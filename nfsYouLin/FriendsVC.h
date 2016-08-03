//
//  FriendsVC.h
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCellDelegate.h"

@interface FriendsVC : UIViewController <UITableViewDelegate,UITableViewDataSource,EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource,cellDelegate>

@property(strong, nonatomic) UITableView* tableView;


@property(strong, nonatomic) NSMutableArray* friendsArray;
@property(strong, nonatomic) NSMutableArray* conversationArr;

// true 附近邻居   false 聊天记录
@property(assign, nonatomic)BOOL listFlag;


@property (weak, nonatomic) id<EaseConversationListViewControllerDelegate> ecdelegate;
@property (weak, nonatomic) id<EaseConversationListViewControllerDataSource> ecdataSource;


- (id) init;
- (void)playSoundAndVibration;
- (void)showNotificationWithMessage:(EMMessage *)message;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
-(void)setupUnreadMessageCount;

@end
