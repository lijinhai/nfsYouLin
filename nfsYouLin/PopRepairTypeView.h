//
//  PopRepairTypeView.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopRepairTypeView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *feedbackTypeTable;
    //UITableView *doorPlateTable;
    NSArray *dataSource;
}
@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property(nonatomic,retain) NSString *feedTypeValue;
+ (instancetype)defaultPopupView;
@end
