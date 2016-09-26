//
//  ConstellationView.m
//  nfsYouLin
//
//  Created by Macx on 16/9/23.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ConstellationView.h"
#import "HeaderFile.h"

@implementation ConstellationView
{
    
    UIButton* _btn1;
    UIButton* _btn2;
    UIButton* _btn3;
    UIButton* _btn4;
    UIButton* _btn5;
    
    CGRect frame1;
    CGRect frame2;
    CGRect frame3;
    CGRect frame4;
    CGRect frame5;
    CGRect rightZero;
    CGRect leftZero;
    
    NSMutableArray<UIButton*> *buttons;
    NSMutableDictionary* rectDict;
}


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UISwipeGestureRecognizer* leftGesture = [[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(swipeGesture:)];
        leftGesture.numberOfTouchesRequired = 1;
        leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftGesture];
        
        
        UISwipeGestureRecognizer* rightGesture = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(swipeGesture:)];
        rightGesture.numberOfTouchesRequired = 1;
        rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightGesture];
        
        CGFloat ivW = CGRectGetWidth(frame) / 5 + 10;
        CGFloat ivH = ivW + 30;
        CGFloat ivY = 10;
        leftZero = CGRectMake(-ivW, ivY + 10, ivW - 20, ivH - 20);
        rightZero = CGRectMake(CGRectGetMaxX(frame) + ivW, ivY + 10, ivW - 20, ivH - 20);
        frame3 = CGRectMake((CGRectGetWidth(frame) - ivW) * 0.5, ivY, ivW, ivH);
        frame2 = CGRectMake(CGRectGetMinX(frame3) - ivW + 20, ivY + 5, ivW - 10, ivH - 10);
        frame1 = CGRectMake(CGRectGetMinX(frame2)  - ivW + 30, ivY + 10, ivW - 20, ivH - 20);
        frame4 = CGRectMake(CGRectGetMaxX(frame3) - 10, ivY + 5, ivW - 10, ivH - 10);
        frame5 = CGRectMake(CGRectGetMaxX(frame4) - 10, ivY + 10, ivW - 20, ivH - 20);

        buttons = [NSMutableArray array];

        for(NSInteger i = 0; i < 12;i ++)
        {
            UIButton* button = [[UIButton alloc] init];
            button.tag = i;
            button.backgroundColor = [UIColor whiteColor];
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"xingzuo_%ld.png",i + 1]];
            button.layer.cornerRadius = 5;
            button.layer.borderWidth = 1.5;
            button.layer.borderColor = [BackgroundColor CGColor];
            button.layer.shadowColor = [[UIColor blackColor] CGColor];
            button.layer.shadowRadius = 1;
            button.layer.shadowOffset = CGSizeMake(0, 1);
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateHighlighted];
            [button setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 15, 0)];
            [buttons addObject:button];
            [self addSubview:button];
        }
        
        [self leftMoving];
        [self endLeftMove];

    }
    return self;
}

#pragma mark -向左移动
- (void) leftMoving
{
    for (UIButton* button in buttons) {
        
        switch (button.tag) {
            case 1:
            {
                [button addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
                button.frame = frame1;
                _btn1 = button;
                break;
            }
            case 2:
            {
                [button addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
                button.frame = frame2;
                _btn2 = button;
                break;
            }
            case 3:
            {
                button.frame = frame3;
                _btn3 = button;
                break;
            }
            case 4:
            {
                [button addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
                button.frame = frame4;
                _btn4 = button;
                break;
            }
            case 5:
            {
                [button addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
                button.frame = frame5;
                button.alpha = 0.5;
                _btn5 = button;
                break;
            }
            default:
            {
                button.frame = leftZero;
                button.alpha = 0.0;
                break;
            }
        }
    }
    
}

#pragma mark -正在向左移动星座 点击向左移动
- (void)leftClicked
{
    for (UIButton* button in buttons) {
        [button removeTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
        [button removeTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
        if(button.tag != 0)
        {
            button.tag -= 1;
        }
        else
        {
            button.tag = 11;
        }
        if(CGRectGetMinX(button.frame) < 0)
        {
            [button removeFromSuperview];
            button.alpha = 0;
            button.frame = rightZero;
            [self addSubview:button];
        }
    }
    
    [UIView animateWithDuration:.5 animations:^{
        [self leftMoving];
    } completion:^(BOOL finished) {
        [self endLeftMove];
    }];
}

#pragma mark -向左移动结束
- (void) endLeftMove
{
    [self addSubview:_btn1];
    [self addSubview:_btn5];
    [self addSubview:_btn2];
    [self addSubview:_btn4];
    [self addSubview:_btn3];
    _btn5.alpha = 1.0;
    [self endMoving];
}


#pragma mark -向右移动
- (void) rightMoving
{
    
    for (UIButton* button in buttons) {
        switch (button.tag) {
            case 1:
            {
                [button addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
                button.frame = frame1;
                button.alpha = 0.5;
                _btn1 = button;
                break;
            }
            case 2:
            {
                [button addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
                button.frame = frame2;
                _btn2 = button;
                break;
            }
            case 3:
            {
                button.frame = frame3;
                _btn3 = button;
                break;
            }
            case 4:
            {
                [button addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
                button.frame = frame4;
                _btn4 = button;
                break;
            }
            case 5:
            {
                [button addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
                button.frame = frame5;
                _btn5 = button;
                break;
            }
            default:
            {
                button.frame = rightZero;
                button.alpha = 0.0;
                break;
            }
        }
    }
    
}


#pragma mark -正在向右移动 点击向右移动
- (void)rightClicked
{
    for (UIButton* button in buttons) {
        [button removeTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
        [button removeTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
        
        if(button.tag != 11)
        {
            button.tag += 1;
        }
        else
        {
            button.tag = 0;
        }
        for (UIImageView* button in buttons)
        {
            if(CGRectGetMaxX(button.frame) > CGRectGetWidth(self.frame))
            {
                [button removeFromSuperview];
                button.alpha = 0.0;
                button.frame = leftZero;
                [self addSubview:button];
            }
        }
        
    }
    
    [UIView animateWithDuration:.5 animations:^{
        [self rightMoving];
    } completion:^(BOOL finished) {
        [self endRightMove];
    }];
    
}

#pragma mark -向右移动结束
- (void) endRightMove
{
    [self addSubview:_btn1];
    [self addSubview:_btn5];
    [self addSubview:_btn2];
    [self addSubview:_btn4];
    [self addSubview:_btn3];
    _btn1.alpha = 1.0;
    [self endMoving];
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)gesture{
    
    if(gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self rightClicked];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self leftClicked];
    }
}

- (void) endMoving
{
    NSInteger index = [buttons indexOfObject:_btn3];
    [_delegate selectedConstellation:index];
}

@end
