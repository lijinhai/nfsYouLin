//
//  CreateTVC.h
//  Test3
//
//  Created by Macx on 16/8/10.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTVC : UITableViewCell

@property (assign, nonatomic)NSInteger where;

@property(strong, nonatomic) UILabel* startL;
@property(strong, nonatomic) UILabel* endL;
@property(strong, nonatomic) UILabel* addressL;


@property(assign, nonatomic) BOOL startB;
@property(assign, nonatomic) BOOL endB;
@property(assign, nonatomic) BOOL addressB;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
