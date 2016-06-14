//
//  PopupView.h
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView<UITableViewDataSource, UITableViewDelegate>
{

    UITableView *floorOrPlateDataTable;
    //UITableView *doorPlateTable;
    NSArray *dataSource; 
}
@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property(nonatomic,retain) NSDictionary *floororPlateDic;
@property(nonatomic,retain) NSArray *floorOrPlateNumAry;
+ (instancetype)defaultPopupView:(NSInteger) tagValue;
@end
