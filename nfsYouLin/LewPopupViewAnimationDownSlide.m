//
//  LewPopupViewAnimationDownSlide.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "LewPopupViewAnimationDownSlide.h"

@implementation LewPopupViewAnimationDownSlide

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)showView:(UIView *)popupView overlayView:(UIView *)overlayView{
    
    CGSize sourceSize = overlayView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupStartRect;

    popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                sourceSize.height,
                                popupSize.width,
                                popupSize.height);
    CGRect popupEndRect =CGRectMake(20 ,
                                    (sourceSize.height - popupSize.height)-20,
                                    popupSize.width,
                                    popupSize.height);
    
    // Set starting properties
    UIView *sampleView=[[UIView alloc] initWithFrame:popupEndRect];
    sampleView.alpha=0.0f;
    popupView.frame = popupStartRect;
    popupView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [popupView addSubview:sampleView];
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
        popupView.frame = popupEndRect;
        
    } completion:nil];
    
    
}
- (void)dismissView:(UIView *)popupView overlayView:(UIView *)overlayView completion:(void (^)(void))completion{
    CGSize sourceSize = overlayView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect=CGRectMake(sourceSize.width ,
                         (sourceSize.height - popupSize.height)-20 ,
                         popupSize.width,
                         popupSize.height);
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionCurveLinear
        animations:^{
        popupView.frame = popupEndRect;
        overlayView.alpha = 0.0f;
        popupView.alpha = 0.0f;
            
    } completion:^(BOOL finished) {
        completion();
    }];
    
}

@end
