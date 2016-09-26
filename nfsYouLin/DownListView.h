//
//  DownListView.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerMPVC.h"

@interface DownListView : UIView<UITableViewDelegate, UITableViewDataSource>

@property(assign, nonatomic) NSInteger selectId;
@property(nonatomic, strong) NSString* defaultSV;
@property (nonatomic, weak)SellerMPVC *parentVC;
- (id)initWithArray:(CGRect)frame array:(NSMutableArray*)nameArray;
//- (NSString*)seletedAction:(NSString*)action;
@end
