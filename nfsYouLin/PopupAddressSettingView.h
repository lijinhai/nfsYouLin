//
//  PopupAddressSettingView.h
//  nfsYouLin
//
//  Created by jinhai on 16/6/8.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupAddressSettingView : UIView<UITableViewDataSource, UITableViewDelegate>{
    
    UITableView *addressSettingTable;
    NSMutableArray *dataSource;
    
}
@property(nonatomic,retain) NSString *addressFlag;
@property(nonatomic,retain) NSMutableArray *changeAddressArray;
@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property (nonatomic ,readwrite) NSInteger celltag;
+ (instancetype)defaultPopupView:(NSInteger) flagValue tFrame:(CGRect)frame;
@end
