//
//  ConstellationView.h
//  nfsYouLin
//
//  Created by Macx on 16/9/23.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConstellationViewDelegate <NSObject>

- (void) selectedConstellation:(NSInteger)index;
@end


@interface ConstellationView : UIView

@property(strong, nonatomic)id <ConstellationViewDelegate> delegate;

- (id) initWithFrame:(CGRect)frame;
@end
