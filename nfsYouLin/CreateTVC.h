//
//  CreateTVC.h
//  Test3
//
//  Created by Macx on 16/8/10.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateTVCDelegate <NSObject>

- (void) getPrice:(NSInteger)price;

@end

@interface CreateTVC : UITableViewCell<UITextFieldDelegate>

@property(strong, nonatomic)id<CreateTVCDelegate> delegate;
@property (assign, nonatomic)NSInteger where;

@property(strong, nonatomic) UILabel* startL;
@property(strong, nonatomic) UILabel* endL;
@property(strong, nonatomic) UILabel* addressL;

@property(assign, nonatomic) NSInteger level;

@property(assign, nonatomic) BOOL startB;
@property(assign, nonatomic) BOOL endB;
@property(assign, nonatomic) BOOL addressB;
@property(assign, nonatomic) BOOL priceB;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
