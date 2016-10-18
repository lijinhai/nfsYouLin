//
//  NoticeBGView.h
//  nfsYouLin
//
//  Created by Macx on 2016/10/17.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeBGView : UIView

@property(strong, nonatomic)UIView* subView;

- (id) initWithFrame:(CGRect)frame subView:(UIView*)view;

@end
