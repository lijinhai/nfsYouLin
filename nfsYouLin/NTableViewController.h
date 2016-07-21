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

@interface NTableViewController : UITableViewController <cellDelegate>
@property (nonatomic,strong)NSMutableArray *neighborDataArray;
@property (strong, nonatomic) IBOutlet UITabBarItem *neighborTabBarItem;

@property (nonatomic,strong)NSString *xxxx;



@end
