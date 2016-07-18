//
//  ApplyDetailView.m
//  nfsYouLin
//
//  Created by Macx on 16/7/15.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ApplyDetailView.h"
#import "StringMD5.h"

@implementation ApplyDetailView

- (id) init
{
    self = [super init];
    if(self)
    {
        self.applyLabel = [[UILabel alloc] init];
        self.applyLabel.text = @"我要报名";
        self.applyLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:0 / 255.0 alpha:1];
        self.applyLabel.font = [UIFont systemFontOfSize:10];
        self.applyNum = [[UILabel alloc] init];
        self.applyNum.text = @"0";
        self.applyNum.textAlignment = NSTextAlignmentCenter;
        self.applyNum.font = [UIFont systemFontOfSize:10];
        self.applyNum.textColor = [UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:0 / 255.0 alpha:1];


    }
    return self;
}

- (void) initApplyView: (CGPoint)point
{
    self.frame = CGRectMake(point.x, point.y, 70, 30);
 
    CGSize labelSize = [StringMD5 sizeWithString:@"报名详情" font:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.applyLabel.frame = CGRectMake(5, (30 - labelSize.height) / 2 , labelSize.width, labelSize.height);
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.applyLabel.frame) + 5, 5, 1, CGRectGetHeight(self.frame) - 10)];
    line.backgroundColor = [UIColor whiteColor];

    
      self.applyNum.frame = CGRectMake(CGRectGetMaxX(line.frame), CGRectGetMinY(self.applyLabel.frame), CGRectGetWidth(self.frame) - CGRectGetMaxX(line.frame), CGRectGetHeight(self.applyLabel.frame));
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:self.applyLabel];
    [self addSubview:line];
    [self addSubview:self.applyNum];

}

@end
