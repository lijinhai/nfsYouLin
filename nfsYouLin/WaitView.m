//
//  WaitView.m
//  nfsYouLin
//
//  Created by Macx on 16/7/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "WaitView.h"

@implementation WaitView
{
    
}
- (id) initWithFrame:(CGRect)frame Title:(NSString *)title
{
    self = [super initWithFrame:CGRectMake((CGRectGetWidth(frame) - 120)/ 2, (CGRectGetHeight(frame) - 100)/ 2, 120, 100)];
    if(self)
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(35, 10, 50, 50)];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(indicator.frame), 120, 40)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    
    return self;
    
}

- (id)initWithRect:(NSString *)title
{
    self = [super init];
    if(self)
    {
        self.frame = CGRectMake(20,(CGRectGetHeight([UIScreen mainScreen].bounds) - 100) , CGRectGetWidth([UIScreen mainScreen].bounds) - 40, 50);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20, 0, 50, 50)];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(indicator.frame) ,0, CGRectGetWidth(self.frame) - 50, 50)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
    }
    return self;
}

@end
