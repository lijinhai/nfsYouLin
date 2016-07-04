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

@property (weak, nonatomic) IBOutlet UITextView *suggestTextView;
@property(nonatomic,retain) NSString *selectTypeValue;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitAction:(id)sender;

@end
