//
//  DialogView.h
//  nfsYouLin
//
//  Created by Macx on 16/7/15.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogView : UIView <UITextViewDelegate>

@property(strong, nonatomic)UIView* backView;
@property(strong, nonatomic)UIButton* send;
@property(strong, nonatomic)UIButton* cancel;
@property(strong, nonatomic)UITextView* textView;

@property(strong, nonatomic)UIButton* deleteYes;
@property(strong, nonatomic)UIButton* deleteNo;

- (id) initWithFrame:(CGRect)frame View:(UIView*) view Flag:(NSString*) flag;



@end
