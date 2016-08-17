//
//  FeedbackViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/6/28.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (strong, nonatomic) UITableView *otherTableView;

@property(nonatomic,retain) NSString *selectTypeValue;

@end
