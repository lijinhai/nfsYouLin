//
//  iViewController.h
//  nfsYouLin
//
//  Created by Macx on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "multiTableViewCell.h"
#import "ShowImageView.h"

@interface iViewController : UITableViewController <cellDelegate>
@property (strong, nonatomic) IBOutlet UITabBarItem *iTabBarItem;

@end
