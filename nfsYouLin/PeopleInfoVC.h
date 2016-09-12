//
//  PeopleInfoVC.h
//  nfsYouLin
//
//  Created by Macx on 16/9/8.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleInfoVC : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property(assign, nonatomic)NSInteger peopleId;

@property(strong, nonatomic)NSString* icon;

@property(strong, nonatomic)NSString* displayName;

@end
