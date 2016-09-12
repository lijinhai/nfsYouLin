//
//  ICollectVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/8/24.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCellDelegate.h"
@interface ICollectVC : UITableViewController<cellDelegate>
@property (nonatomic,strong)NSMutableArray *neighborDataArray;
@property (nonatomic,strong)NSString *userIdStr;//用户ID或者查询用户ID
@end
