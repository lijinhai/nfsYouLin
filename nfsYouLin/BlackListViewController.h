//
//  BlackListViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/1.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
//UIScrollViewDelegate
@interface BlackListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *blackListTable;
@property(nonatomic,retain) NSMutableArray *blackListAry;
@property(nonatomic,retain) NSMutableArray *blackerAry;
@end
