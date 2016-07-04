//
//  BlackListViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/1.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *blackListTable;

@end
