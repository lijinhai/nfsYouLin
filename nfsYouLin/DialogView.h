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

// 确定
@property(strong, nonatomic)UIButton* OKbtn;
// 取消
@property(strong, nonatomic)UIButton* NOBtn;
@property(strong, nonatomic)UILabel* titleL;

@property(strong, nonatomic)UIButton* applyYes;
@property(strong, nonatomic)UIButton* applyNo;
@property(strong, nonatomic)UITextField* adultTF;
@property(strong, nonatomic)UITextField* childTF;


@property(strong, nonatomic)UITextView* cancelApplyTV;
@property(strong, nonatomic)UIButton* cancelApplyYes;
@property(strong, nonatomic)UIButton* cancelApplyNo;

//删除报修
// 删除一个
@property(strong, nonatomic)UIControl *OneCtl;
@property(strong, nonatomic)UILabel* OneLab;
// 删除全部
@property(strong, nonatomic)UIControl *AllCtl;
@property(strong, nonatomic)UILabel* AllLab;
// 更新维修状态
@property(strong, nonatomic)UITextView* repairTV;
@property(strong, nonatomic)UIButton* repairYes;
@property(strong, nonatomic)UIButton* repairNo;




- (id) initWithFrame:(CGRect)frame View:(UIView*) view Flag:(NSString*) flag;



@end
