//
//  PhonesView.h
//  nfsYouLin
//
//  Created by Macx on 16/9/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhonesDelegate <NSObject>

-(void) selectedPhone:(NSString*)phone;

@end

@interface PhonesView : UIView<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)id<PhonesDelegate> delegate;
- (id) init;
- (void)reloadView:(CGRect)frame array:(NSMutableArray*)phoneArr;
@end
