//
//  redrawTextField.h
//  nfsYouLin
//
//  Created by jinhai on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface redrawTextField : UIView
@property (nonatomic,readwrite) CGFloat redValue;
@property (nonatomic,readwrite) CGFloat blueValue;
@property (nonatomic,readwrite) CGFloat greenValue;


- (id)init:(CGRect)frame addTextField:(UITextField *)inputInfoText;
@end
