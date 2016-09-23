//
//  RepairVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCellDelegate.h"

@interface RepairVC : UIViewController<cellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *neighborDataArray;
@property (nonatomic,strong)UITableView* tableView;
@property (nonatomic,strong)NSString *userIdStr;//用户ID或者查询用户ID
@end
