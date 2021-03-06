//
//  DetailListView.h
//  nfsYouLin
//
//  Created by Macx on 16/9/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailListViewDelegate <NSObject>

- (void)seletedAction:(NSString*)action;

@end

@interface DetailListView : UIView<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)id<DetailListViewDelegate> delegate;
@property(assign, nonatomic) BOOL collectStatus;
- (id)initWithArray:(CGFloat)frameY array:(NSMutableArray*)nameArray;
@end
