//
//  GoodsLevelV.h
//  nfsYouLin
//
//  Created by Macx on 16/8/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsLevelDelegate <NSObject>

- (void)didSelectedLevel:(NSInteger)level;

@end

@interface GoodsLevelV : UIView<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)id <GoodsLevelDelegate> delegate;
- (id)init;
@end
