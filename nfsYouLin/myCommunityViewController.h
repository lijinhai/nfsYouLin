//
//  myCommunityViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/5/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myCommunityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
 NSIndexPath *_selectedIndexPath;
}
@property (strong, nonatomic) NSDictionary *names;
@property (strong, nonatomic) NSMutableArray *listname;
@property (strong, nonatomic) NSMutableArray *commMutableAry;
@property (strong, nonatomic) NSString *cityName;

@property (strong, nonatomic) IBOutlet UITableView *communityTable;
@end
