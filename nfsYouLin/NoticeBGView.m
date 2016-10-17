//
//  NoticeBGView.m
//  nfsYouLin
//
//  Created by Macx on 2016/10/17.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NoticeBGView.h"
#import "HeaderFile.h"

@implementation NoticeBGView


- (id) initWithFrame:(CGRect)frame subView:(UIView*)view
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        self.subView = view;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
      [UIView transitionWithView:self.subView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.subView.frame =CGRectMake(screenWidth, screenHeight * 0.5 + 50, screenWidth - 40, 100);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.subView removeFromSuperview];

    }];
}

@end
