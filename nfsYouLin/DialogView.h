//
//  DialogView.h
//  nfsYouLin
//
//  Created by Macx on 16/7/15.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogView : UIView <UITextViewDelegate,UITextFieldDelegate>

@property(strong, nonatomic)UIView* backView;

@property(strong, nonatomic)UIButton* send;
@property(strong, nonatomic)UIButton* cancel;
@property(strong, nonatomic)UITextView* sayHiTV;

@property(strong, nonatomic)UITextView* deleteTV;
@property(strong, nonatomic)UIButton* deleteYes;
@property(strong, nonatomic)UIButton* deleteNo;


@property(strong, nonatomic)UIButton* applyYes;
@property(strong, nonatomic)UIButton* applyNo;
@property(strong, nonatomic)UITextField* adultTF;
@property(strong, nonatomic)UITextField* childTF;


@property(strong, nonatomic)UITextView* cancelApplyTV;
@property(strong, nonatomic)UIButton* cancelApplyYes;
@property(strong, nonatomic)UIButton* cancelApplyNo;

- (id) initWithFrame:(CGRect)frame View:(UIView*) view Flag:(NSString*) flag;



@end
