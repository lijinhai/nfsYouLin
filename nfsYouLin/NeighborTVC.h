//
//  NeighborTableViewController.h
//  Neighbor2
//
//  Created by Macx on 16/5/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowImageView.h"
#import "NeighborTableViewCell.h"
#import "NeighborDataFrame.h"
#import "JPushNotification.h"

@interface NeighborTVC : UIViewController <JPushNotificationDelegate, cellDelegate,UITableViewDelegate,UITableViewDataSource>

- (id) init;

@property(nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray *neighborDataArray;
// 上拉刷新
@property (assign, nonatomic)BOOL refresh;

- (NeighborData*) readInformation:(NSInteger)topicId;

- (void) handleTopicNotification:(NSDictionary *)userInfo;

@end
