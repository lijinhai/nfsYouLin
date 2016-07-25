//
//  FriendsVC.h
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsVC : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UITableView* tableView;


@property(strong, nonatomic) NSMutableArray* friendsArray;

@end
