//
//  NoticeMessageView.m
//  nfsYouLin
//
//  Created by Macx on 16/9/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NoticeMessageView.h"

@implementation NoticeMessageView

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer.state != 0)
    {
        return YES;
    } else {
        return NO;
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(_bgView)
    {
        [_bgView removeFromSuperview];
    }
    [self removeFromSuperview];
}
@end
