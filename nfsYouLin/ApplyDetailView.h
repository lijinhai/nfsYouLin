//
//  ApplyDetailView.h
//  nfsYouLin
//
//  Created by Macx on 16/7/15.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyDetailView : UIControl


@property(strong ,nonatomic) UILabel* applyLabel;
@property(strong ,nonatomic) UILabel* applyNum;

- (id) init;

- (void) initApplyView: (CGPoint)point;

@end
