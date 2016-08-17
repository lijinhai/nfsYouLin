//
//  PublishLimitVC.m
//  nfsYouLin
//
//  Created by Macx on 16/8/16.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PublishLimitVC.h"

@interface PublishLimitVC ()

@end

@implementation PublishLimitVC
{
    UIControl* control1;
    UIControl* control2;
    UIControl* control3;

    UIImageView* imageV1;
    UIImageView* imageV2;
    UIImageView* imageV3;

}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.which = 0;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.frame), 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel* communityL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.frame), 50)];
    communityL.text = self.communityName;
    communityL.enabled = NO;
    communityL.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:communityL];
    [self.view addSubview:bgView];
    
    
    
    // 本小区
    control1 = [[UIControl alloc] initWithFrame:CGRectMake(10, 50, 30, 50)];
    [control1 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    control1.tag = 0;
    imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 10, 10)];
    imageV1.image = [UIImage imageNamed:@"btn_xuanzhong.png"];
    imageV1.layer.masksToBounds = YES;
    imageV1.layer.cornerRadius = 5;
    [control1 addSubview:imageV1];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(control1.frame), 50, 60, 50)];
    label1.text = @"本小区";
    [bgView addSubview:label1];
    [bgView addSubview:control1];
    
    
    // 周边
    control2 = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame) + 20, 50, 30, 50)];
    [control2 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    control2.tag = 1;
    imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 10, 10)];
    imageV2.image = [UIImage imageNamed:@"btn_weixuanzhong.png"];
    imageV2.layer.masksToBounds = YES;
    imageV2.layer.cornerRadius = 5;

    [control2 addSubview:imageV2];
    
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(control2.frame), 50, 60, 50)];
    label2.text = @"周边";
    [bgView addSubview:label2];
    [bgView addSubview:control2];

    
    // 同城
    control3 = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame) + 20, 50, 30, 50)];
    [control3 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    control3.tag = 2;
    imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 10, 10)];
    imageV3.image = [UIImage imageNamed:@"btn_weixuanzhong.png"];
    imageV3.layer.masksToBounds = YES;
    imageV3.layer.cornerRadius = 5;
    [control3 addSubview:imageV3];
    
    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(control3.frame), 50, 60, 50)];
    label3.text = @"同城";
    [bgView addSubview:label3];
    [bgView addSubview:control3];

    
}


- (IBAction)Click:(id)sender
{
    UIControl* control = (UIControl*)sender;
    NSLog(@"Tag = %ld",control.tag);
    
    imageV1.image = [UIImage imageNamed:@"btn_weixuanzhong.png"];
    imageV2.image = [UIImage imageNamed:@"btn_weixuanzhong.png"];
    imageV3.image = [UIImage imageNamed:@"btn_weixuanzhong.png"];

    
    switch (control.tag) {
        case 0:
        {
            imageV1.image = [UIImage imageNamed:@"btn_xuanzhong.png"];
            break;
        }
        case 1:
        {
            imageV2.image = [UIImage imageNamed:@"btn_xuanzhong.png"];
            break;
        }
        case 2:
        {
            imageV3.image = [UIImage imageNamed:@"btn_xuanzhong.png"];
            break;
        }
            
        default:
            break;
    }
    
    self.which = control.tag;
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
