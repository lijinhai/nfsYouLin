//
//  PopChangeAddress.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopChangeAddress : UIView<UITableViewDataSource, UITableViewDelegate,cellDelegate>{
    
    UITableView *addressSettingTable;
    NSMutableArray *dataSource;
    
}
@property(nonatomic,retain) NSString *addressFlag;
@property(nonatomic,retain) NSMutableArray *changeAddressArray;
@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property (nonatomic ,readwrite) NSInteger celltag;
+ (instancetype)defaultPopupView:(NSString*) addrValue tFrame:(CGRect)frame;

@end
