//
//  UpdatePhotoView.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePhotoView : UIView

@property (nonatomic, weak)UIViewController *parentVC;
//@property (nonatomic, strong)UIView *bGView;
@property(nonatomic,retain) NSString *passValue;
+ (instancetype)defaultPopupView;
- (void)setInfoViewFrame:(BOOL)isDown;
@end
