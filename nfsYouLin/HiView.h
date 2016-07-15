//
//  HiView.h
//  nfsYouLin
//
//  Created by Macx on 16/7/15.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiView : UIView <UITextViewDelegate>

@property(strong, nonatomic)UIView* backView;
@property(strong, nonatomic)UIButton* send;
@property(strong, nonatomic)UIButton* cancel;
@property(strong, nonatomic)UITextView* textView;


- (id) initWithFrame:(CGRect)frame View:(UIView*) view;



@end
