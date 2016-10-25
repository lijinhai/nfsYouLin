//
//  AdministratorRTVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/10/18.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdministratorRTVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView* tableView;
@property (nonatomic,strong)NSMutableArray *userADAry;
@property (nonatomic,strong)NSMutableArray *neighborDataArray;
@end
