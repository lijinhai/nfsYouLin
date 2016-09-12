//
//  familyAddressViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/5/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface familyAddressViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
}
@property (strong, nonatomic) NSDictionary *names;
@property (strong, nonatomic) NSMutableArray *changeAddressArry;
@property (strong, nonatomic) NSMutableArray *floorAndplateAry;
@property (strong, nonatomic) NSMutableDictionary *floorAndplateDic;
@property (strong, nonatomic) NSArray *listtitle;
@property(nonatomic,retain) NSString *communityNameValue;
@property(nonatomic,retain) NSString *floorNumValue;
@property(nonatomic,retain) NSString *jumpflag;
@property(nonatomic,retain) UITextField *floorNumView;
@property (weak, nonatomic) IBOutlet UITableView *myfamilyAddressTableView;

@end
