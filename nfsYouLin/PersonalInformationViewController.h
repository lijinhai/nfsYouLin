//
//  PersonalInformationViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/4.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"

@interface PersonalInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{

    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *personalInfoTable;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UILabel *sexLabel;
@property (strong, nonatomic) UILabel *birthdayLabel;
@property (strong, nonatomic) UILabel *professionLabel;
@property (strong, nonatomic) UISwitch *switchFamliyAddressButton;
@property(nonatomic,retain) NSString *statusValue;
//@property (nonatomic, weak) UINavigationController *navigationController;
@end
