//
//  ReportVC.h
//  nfsYouLin
//
//  Created by Macx on 16/9/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(assign, nonatomic)NSInteger topicId;
@property(assign, nonatomic)NSInteger senderId;
@end
