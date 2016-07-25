//
//  SegmentView.m
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "SegmentView.h"

@implementation SegmentView
{
    UIColor *color;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 50);
        self.backgroundColor = [UIColor lightGrayColor];
        color = [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
        self.neighborsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 4 ) ];
        [self.neighborsBtn setTitle:@"附近邻居:0" forState:UIControlStateNormal];
        self.neighborsBtn.backgroundColor = [UIColor whiteColor];
        [self.neighborsBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
        self.nLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.neighborsBtn.frame), CGRectGetWidth(self.neighborsBtn.frame), 3)];
        self.nLineView.backgroundColor = [UIColor whiteColor];
        
        self.chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.neighborsBtn.frame), 0, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 4 ) ];
        [self.chatBtn setTitle:@"聊天记录" forState:UIControlStateNormal];
        self.chatBtn.backgroundColor = [UIColor whiteColor];
        [self.chatBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
        
        self.cLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nLineView.frame), CGRectGetMaxY(self.chatBtn.frame), CGRectGetWidth(self.neighborsBtn.frame), 3)];
        self.cLineView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.neighborsBtn];
        [self addSubview:self.nLineView];
        [self addSubview:self.chatBtn];
        [self addSubview:self.cLineView];
        
    }
    
    return self;
}


@end
