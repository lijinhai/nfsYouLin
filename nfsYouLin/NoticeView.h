//
//  NoticeView.h
//  nfsYouLin
//
//  Created by Macx on 2016/10/17.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeViewDelegate <NSObject>

- (void) seletedNotice:(NSInteger) tag;

@end

@interface NoticeView : UIView

@property(strong, nonatomic)id <NoticeViewDelegate> delegate;

- (id) initWithFrame:(CGRect)frame;

- (void) initButton;

@end
