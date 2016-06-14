//
//  LewPopupViewAnimationRight.m
//  nfsYouLin
//
//  Created by jinhai on 16/6/8.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "LewPopupViewAnimationRight.h"

@implementation LewPopupViewAnimationRight

- (void)showView:(UIView *)popupView overlayView:(UIView *)overlayView{
    
    popupView.transform = CGAffineTransformMakeTranslation(200,0);
    
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromRight
     |UIViewAnimationOptionCurveLinear  animations:^{
        popupView.transform = CGAffineTransformMakeTranslation(0,0);
    } completion:nil];
}

- (void)dismissView:(UIView *)popupView overlayView:(UIView *)overlayView completion:(void (^)(void))completion{
    
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        overlayView.alpha = 0.0;
        popupView.transform = CGAffineTransformMakeTranslation(200,0);
    } completion:^(BOOL finished) {
        completion();
    }];
    
}
@end

