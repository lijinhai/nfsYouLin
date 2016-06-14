//
//  multiTableViewCell.m
//  nfsYouLin
//
//  Created by Macx on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "multiTableViewCell.h"

@implementation multiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self.publishCount = 0;
    self.integralCount = 0;
    self.favoriteCount = 0;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if([reuseIdentifier isEqualToString:@"cellOne"])
    {
        self.integralView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width / 3 - 1 , 80)];
        self.integralView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.integralView.bounds.size.width + 1 , 20.0f, 1.0f, 40)];
        [lineView setBackgroundColor:[UIColor blackColor]];
        UILabel* lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.integralView.bounds.size.width, 50) ];
        lable1.text = @"积分";
        lable1.enabled = NO;
        lable1.textAlignment = NSTextAlignmentCenter;
        self.integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.integralView.bounds.size.width, 30)];
        self.integralLabel.textAlignment = NSTextAlignmentCenter;
        self.integralLabel.text = [NSString stringWithFormat:@"%ld",self.integralCount];
        // 设置文字控件的宽度按照上一级视图（topView）的比例进行缩放
        [lable1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.integralLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        // 设置View控件的宽度按照父视图的比例进行缩放，距离父视图顶部、左边距和右边距的距离不变
        [self.integralView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        [lineView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        [self.integralView addSubview:lable1];
        [self.integralView addSubview:self.integralLabel];
        [self.integralView addTarget:self action:@selector(touchDownIntegral) forControlEvents:UIControlEventTouchDown];
        [self.integralView addTarget:self action:@selector(touchCancelIntegral) forControlEvents:UIControlEventTouchUpInside ];
        [self.contentView addSubview:self.integralView];
        [self.contentView addSubview:lineView];
        
        
        self.publishView = [[UIControl alloc] initWithFrame:CGRectMake(self.integralView.bounds.size.width + 2, 0, self.contentView.bounds.size.width / 3 - 1, 80)];
        self.publishView.backgroundColor = [UIColor whiteColor];
        UILabel* lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.publishView.bounds.size.width, 50) ];
        lable2.text = @"我发的";
        lable2.enabled = NO;
        lable2.textAlignment = NSTextAlignmentCenter;
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(self.integralView.bounds.size.width + self.publishView.bounds.size.width + 2, 20.0f, 1.0f, 40)];
        
        [lineView2 setBackgroundColor:[UIColor blackColor]];
        
        self.publishLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.publishView.bounds.size.width, 30)];
        self.publishLable.textAlignment = NSTextAlignmentCenter;
        self.publishLable.text = [NSString stringWithFormat:@"%ld",self.publishCount];
        
        
        // 设置文字控件的宽度按照上一级视图（topView）的比例进行缩放
        [lable2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.publishLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        // 设置View控件的宽度按照父视图的比例进行缩放，距离父视图顶部、左边距和右边距的距离不变
        [self.publishView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        [lineView2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        [self.publishView addSubview:lable2];
        ////        [self.view2 addSubview:lineView2];
        [self.publishView addSubview:self.publishLable];
        [self.publishView addTarget:self action:@selector(touchDownPublish) forControlEvents:UIControlEventTouchDown];
        [self.publishView addTarget:self action:@selector(touchCancelPublish) forControlEvents:UIControlEventTouchUpInside ];
        [self.contentView addSubview:self.publishView];
        [self.contentView addSubview:lineView2];
        
        
        
        self.favoriteView = [[UIControl alloc] initWithFrame:CGRectMake(2 * (self.integralView.bounds.size.width) + 3, 0, self.contentView.bounds.size.width / 3 , 80)];
        self.favoriteView.backgroundColor = [UIColor whiteColor];
        UILabel* lable3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.favoriteView.bounds.size.width, 50) ];
        lable3.text = @"收藏";
        lable3.enabled = NO;
        lable3.textAlignment = NSTextAlignmentCenter;
        self.favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.favoriteView.bounds.size.width, 30)];
        self.favoriteLabel.textAlignment = NSTextAlignmentCenter;
        self.favoriteLabel.text = [NSString stringWithFormat:@"%ld",self.favoriteCount];
        
        // 设置文字控件的宽度按照上一级视图（topView）的比例进行缩放
        [lable3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.favoriteLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        // 设置View控件的宽度按照父视图的比例进行缩放，距离父视图顶部、左边距和右边距的距离不变
        [self.favoriteView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        
        [self.favoriteView addSubview:lable3];
        [self.favoriteView addSubview:self.favoriteLabel];
        [self.favoriteView addTarget:self action:@selector(touchDownFavorite) forControlEvents:UIControlEventTouchDown];
        [self.favoriteView addTarget:self action:@selector(touchCancelFavorite) forControlEvents:UIControlEventTouchUpInside ];
        [self.contentView addSubview:self.favoriteView];


    }
    else if([reuseIdentifier isEqualToString:@"cellZero"])
    {
        /*处理头像*/
        self.imageView.image = [UIImage imageNamed:@"account.png"];
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction:)];
        [self.imageView addGestureRecognizer:tapGesture];

        
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(100, self.contentView.frame.size.height, 400, self.contentView.frame.size.height)];
        [self.imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
        self.nameLabel.text = @"姓名";
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 120, 15)];
        self.phoneLabel.text = @"15114599422";
        self.phoneLabel.enabled = NO;
        [self.nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        self.signButton = [[UIButton alloc] initWithFrame:CGRectMake(200, -10, 40, 40)];
        self.signButton.layer.cornerRadius = self.signButton.frame.size.width / 2;
        self.signButton.layer.masksToBounds = YES;
        [self.signButton setBackgroundImage:[UIImage imageNamed:@"btn_qiandao.png"] forState:UIControlStateNormal];
        [view addSubview:self.nameLabel];
        [view addSubview:self.phoneLabel];
        [view addSubview:self.signButton];
        [self.contentView addSubview:view];
    }
    return self;
}


- (void) touchDownIntegral
{
    self.integralView.backgroundColor = [UIColor lightGrayColor];
}

- (void)touchCancelIntegral
{
//    self.view1.backgroundColor = _viewColor;
    self.integralCount += 3;
    self.integralLabel.text = [NSString stringWithFormat:@"%ld",self.integralCount];
    self.integralView.backgroundColor = [UIColor whiteColor];
}


- (void) touchDownPublish
{
    self.publishView.backgroundColor = [UIColor lightGrayColor];
}

- (void)touchCancelPublish
{
    //    self.view1.backgroundColor = _viewColor;
    self.publishCount += 3;
    self.publishLable.text = [NSString stringWithFormat:@"%ld",self.publishCount];
    self.publishView.backgroundColor = [UIColor whiteColor];
}

- (void) touchDownFavorite
{
    self.favoriteView.backgroundColor = [UIColor lightGrayColor];
}

- (void)touchCancelFavorite
{
    //    self.view1.backgroundColor = _viewColor;
    self.favoriteCount += 3;
    self.favoriteLabel.text = [NSString stringWithFormat:@"%ld",self.favoriteCount];
    self.favoriteView.backgroundColor = [UIColor whiteColor];
}


- (void) headTapAction: (UITapGestureRecognizer*) recognizer
{
    [_delegate showCircularImageViewWithImage:self.imageView.image];
}

@end
