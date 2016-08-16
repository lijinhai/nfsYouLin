//
//  multiTableViewCell.m
//  nfsYouLin
//
//  Created by Macx on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "multiTableViewCell.h"
#import "UIViewLinkmanTouch.h"
#import "SignIntegralViewController.h"
#import "StringMD5.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"
#import "AppDelegate.h"
#import "SqliteOperation.h"

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
        /*获取用户积分*/
        [self getUserIntegral:[SqliteOperation getUserId]];
        self.integralView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width / 3 - 1 , 80)];
        self.integralView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.integralView.bounds.size.width + 1 , 20.0f, 1.0f, 40)];
        [lineView setBackgroundColor:[UIColor blackColor]];
        UILabel* lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.integralView.bounds.size.width, 50) ];
        lable1.text = @"积分";
        lable1.enabled = NO;
        lable1.textAlignment = NSTextAlignmentCenter;
        self.integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.integralView.bounds.size.width, 30)];
        self.integralLabel.tag=222;
        self.integralLabel.textAlignment = NSTextAlignmentCenter;

        // 设置文字控件的宽度按照上一级视图（topView）的比例进行缩放
        [lable1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.integralLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        // 设置View控件的宽度按照父视图的比例进行缩放，距离父视图顶部、左边距和右边距的距离不变
        [self.integralView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        [lineView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        [self.integralView addSubview:lable1];
        [self.integralView addSubview:self.integralLabel];
        //[self.integralView addTarget:self action:@selector(touchDownIntegral) forControlEvents:UIControlEventTouchDown];
        //[self.integralView addTarget:self action:@selector(touchCancelIntegral) forControlEvents:UIControlEventTouchUpInside ];
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
            //[self.view2 addSubview:lineView2];
        [self.publishView addSubview:self.publishLable];
        //[self.publishView addTarget:self action:@selector(touchDownPublish) forControlEvents:UIControlEventTouchDown];
        //[self.publishView addTarget:self action:@selector(touchCancelPublish) forControlEvents:UIControlEventTouchUpInside ];
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
        [self.contentView addSubview:self.favoriteView];
    }
    else if([reuseIdentifier isEqualToString:@"cellZero"])
    {
        // 处理头像
        
        self.headIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 60, 60)];
        self.headIV.layer.masksToBounds = YES;
        self.headIV.layer.cornerRadius = 30;
        self.headIV.userInteractionEnabled = YES;
        self.headIV.tag=521;
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction:)];
        [self.headIV addGestureRecognizer:tapGesture];
        [self.contentView addSubview:self.headIV];
        
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(70, 25, 400, 50)];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
        self.nameLabel.text = @"姓名";
        self.nameLabel.tag=1314;
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 120, 15)];
        self.phoneLabel.text = @"15114599422";
        self.phoneLabel.enabled = NO;
        [self.nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        
        [view addSubview:self.nameLabel];
        [view addSubview:self.phoneLabel];
    
        [self.contentView addSubview:view];
    }
    
    
    return self;
}

-(void)getUserIntegral:(long) userid{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* myId = [NSString stringWithFormat:@"%ld",userid];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@",myId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1024",hashString]];
    NSDictionary* parameter = @{@"user_id" : myId,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"usercredit",
                                @"salt" : @"1024",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.integralCount=[[responseObject objectForKey:@"credit"] intValue];
        self.integralLabel.text = [NSString stringWithFormat:@"%ld",self.integralCount];
        self.integralLabel.tag=1024;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];
}

/*获取父view的UIViewController*/
//- (UIViewController *)viewController
//{
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        UIResponder *nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)nextResponder;
//        }
//    }
//    return nil;
//}


- (void) headTapAction: (UITapGestureRecognizer*) recognizer
{
    [_delegate showCircularImageViewWithImage:self.headIV.image];
}

- (void) setUserData:(Users *)userData
{
    
    _userData = userData;
   
    if(_userData)
    {
  
        NSURL* url = [NSURL URLWithString:_userData.userPortrait];

        [self.headIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
        
        CGSize phoneSize = [StringMD5 sizeWithString:_userData.phoneNum font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        CGSize nameSize = [StringMD5 sizeWithString:_userData.userName font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.nameLabel.frame = CGRectMake(0, 0, nameSize.width, nameSize.height);
         self.phoneLabel.frame = CGRectMake(0, nameSize.height, phoneSize.width, phoneSize.height);
        self.phoneLabel.text = _userData.phoneNum;
        self.nameLabel.text = _userData.userName;

        
    }
}


@end
