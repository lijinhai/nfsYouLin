//
//  BackgroundView.m
//  nfsYouLin
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "BackgroundView.h"

@implementation BackgroundView

- (id) initWithFrame:(CGRect)frame view:(UIView*) topView
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.topOfView = topView;
    }
    return self;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"BackgroundView touchesBegan!");
    if(_topOfView)
    {
        [_topOfView removeFromSuperview];
    }
    
    [self removeFromSuperview];
}

@end
