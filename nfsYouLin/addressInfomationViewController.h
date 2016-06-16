//
//  addressInfomationViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/5/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface addressInfomationViewController :UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *addressTableView;
@property (strong, nonatomic) NSArray *addressArray;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UIButton *writeAddressBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelTip;
- (IBAction)writeAddressAction:(id)sender;
@end
