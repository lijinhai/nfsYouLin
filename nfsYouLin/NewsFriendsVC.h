//
//  NewsFriendsVC.h
//  nfsYouLin
//
//  Created by Macx on 16/9/18.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendViewCell.h"
#import "NCellDelegate.h"

@interface NewsFriendsVC : UIViewController<UITableViewDelegate,UITableViewDataSource,cellDelegate>

@property(assign, nonatomic)NSInteger newsId;

- (id) init;
@end
