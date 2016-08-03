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

@interface NeighborTVC : UITableViewController <cellDelegate>

- (id) init;

@property (nonatomic,strong)NSMutableArray *neighborDataArray;

@end
