//
//  PersonalInformationViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/4.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{

    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *personalInfoTable;
//@property (nonatomic, weak) UINavigationController *navigationController;
@end
