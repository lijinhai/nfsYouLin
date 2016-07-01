//
//  PopupFeedBackTypeView.h
//  nfsYouLin
//
//  Created by jinhai on 16/6/30.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupFeedBackTypeView : UIView<UITableViewDelegate,UITableViewDataSource>
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
