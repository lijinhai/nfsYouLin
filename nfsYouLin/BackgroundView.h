//
//  BackgroundView.h
//  nfsYouLin
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundView : UIView


@property (strong, nonatomic) UIView* topOfView;

- (id) initWithFrame:(CGRect)frame view:(UIView*) topView;
@end
