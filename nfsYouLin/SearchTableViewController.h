//
//  SearchTableViewController.h
//  nfsYouLin
//
//  Created by Macx on 16/6/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCellDelegate.h"
#import "SearchBarView.h"
  

@interface SearchTableViewController : UITableViewController <cellDelegate,SearchBarViewDelegate>

@property (nonatomic,strong)NSMutableArray *neighborDataArray;
@end
