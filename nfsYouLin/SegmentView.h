//
//  SegmentView.h
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIView

@property(strong, nonatomic) UIButton* neighborsBtn;
@property(strong, nonatomic) UIView* nLineView;

@property(strong, nonatomic) UIButton* chatBtn;
@property(strong, nonatomic) UIView* cLineView;

@property(strong, nonatomic) UIImageView* circle;

- (id) init;

- (void) setIsMessage:(BOOL)isMessage;

@end
