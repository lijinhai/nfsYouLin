//
//  NewShareView.h
//  nfsYouLin
//
//  Created by Macx on 16/9/14.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewShareDelegate <NSObject>

- (void) shareToFriends;
- (void) shareToNeighbors;

@end

@interface NewShareView : UIView

@property(strong, nonatomic) id<NewShareDelegate> delegate;

- (void)showInView:(UIView *)view;

- (void)disMissView;
@end
