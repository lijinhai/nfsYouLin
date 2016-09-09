//
//  BackgroundV.m
//  nfsYouLin
//
//  Created by Macx on 16/8/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "BackgroundV.h"

@implementation BackgroundV
{
    UIView* subView;
}
- (id) initWithView:(UIView *)view
{
    self = [super init];
    if(self)
    {
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        subView = view;
    }
    
    return self;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [subView removeFromSuperview];
    [self removeFromSuperview];
}

@end
