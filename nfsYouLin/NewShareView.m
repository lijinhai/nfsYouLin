//
//  NewShareView.m
//  nfsYouLin
//
//  Created by Macx on 16/9/14.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NewShareView.h"
#import "HeaderFile.h"

@implementation NewShareView
{
    UIView *_contentView;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self initContent];
    }
    
    return self;
}


- (void)initContent
{
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];

    if (_contentView == nil)
    {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
        titleL.font = [UIFont systemFontOfSize:20];
        titleL.text = @"新闻分享";
        titleL.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:titleL];
        
        UIButton* friendBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth * 0.5 - 35 - 60, CGRectGetMaxY(titleL.frame) + 10, 60, 60)];
        friendBtn.backgroundColor = [UIColor whiteColor];
        [friendBtn addTarget:self action:@selector(friendClicked) forControlEvents:UIControlEventTouchUpInside];
        [friendBtn setBackgroundImage:[UIImage imageNamed:@"icon_youlin.png"] forState:UIControlStateNormal];
        
        UILabel* friendL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(friendBtn.frame), CGRectGetMaxY(friendBtn.frame) + 10, 60, 30)];
        friendL.textAlignment = NSTextAlignmentCenter;
        friendL.text = @"优邻好友";
        friendL.font = [UIFont systemFontOfSize:14];
        friendL.enabled = NO;
        [_contentView addSubview:friendL];
        
        UIButton* neighbotBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth * 0.5 + 35, CGRectGetMaxY(titleL.frame) + 10, 60, 60)];
        neighbotBtn.backgroundColor = [UIColor whiteColor];
        [neighbotBtn addTarget:self action:@selector(neighborClicked) forControlEvents:UIControlEventTouchUpInside];
        [neighbotBtn setBackgroundImage:[UIImage imageNamed:@"pic_linjuquan.png"] forState:UIControlStateNormal];
        
        UILabel* neighborL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(neighbotBtn.frame), CGRectGetMaxY(neighbotBtn.frame) + 10, 60, 30)];
        neighborL.textAlignment = NSTextAlignmentCenter;
        neighborL.text = @"邻居圈";
        neighborL.font = [UIFont systemFontOfSize:14];
        neighborL.enabled = NO;
        [_contentView addSubview:neighborL];
        
        [_contentView addSubview:friendBtn];
        [_contentView addSubview:neighbotBtn];
        [self addSubview:_contentView];
        
        
        UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(friendL.frame) + 7, screenWidth - 16, 40)];
        cancelBtn.backgroundColor = MainColor;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.layer.cornerRadius = 6;
        [_contentView addSubview:cancelBtn];
    }
}


- (void)showInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    [_contentView setFrame:CGRectMake(0, screenHeight, screenWidth, 216)];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [_contentView setFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    } completion:nil];
}

- (void)disMissView
{
    [_contentView setFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0;
                         [_contentView setFrame:CGRectMake(0, screenHeight, screenWidth, 216)];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                     }];
}

- (void)cancelClicked
{
    [self disMissView];
}

- (void)friendClicked
{
    [_delegate shareToFriends];
}

- (void)neighborClicked
{
    [_delegate shareToNeighbors];
}

@end
