//
//  FirstTabBarController.h
//  nfsYouLin
//
//  Created by Macx on 16/6/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTabBarController : UITabBarController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *noticeItem;



- (IBAction)noticeBar:(id)sender;

- (IBAction)addBar:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *nowAddressBtn;

- (void)addRedPoint;
- (void) cancelRedPoint;

- (void) refreshData;

- (void) setTableViewHidden;


@end
