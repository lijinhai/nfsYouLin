//
//  NoticeVC.h
//  nfsYouLin
//
//  Created by Macx on 16/9/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCellDelegate.h"

@interface NoticeVC : UITableViewController <cellDelegate>

@property (nonatomic,strong)NSMutableArray *neighborDataArray;

@end
