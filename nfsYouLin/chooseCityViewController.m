//
//  chooseCityViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "chooseCityViewController.h"
#import "myCommunityViewController.h"
#import "StringMD5.h"

@interface chooseCityViewController ()

@end

@implementation chooseCityViewController{

    myCommunityViewController *myCommunityController;
    UINavigationController *loginNC;
    
    UIImageView* _backIV;
    UILabel* _backLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cityName.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cityNameTouchUpInside:)];
    [_cityName addGestureRecognizer:labelTapGestureRecognizer];
    
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    loginNC = [storyBoard instantiateViewControllerWithIdentifier:@"viewID"];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(selectNextAction)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    self.navigationItem.title=@"";
    
    [self createBackItemBtn];
    
    
    /*跳转至选择小区界面*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myCommunityController = [storyBoard instantiateViewControllerWithIdentifier:@"myCommunityController"];
}
-(void) selectNextAction{
    /*添加相关逻辑判断*/
    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"我的小区" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:myCommunityController animated:YES];

}
-(void) cityNameTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    label.backgroundColor=[UIColor lightGrayColor];
    label.alpha=0.3;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createBackItemBtn
{
    CGSize size = [StringMD5 sizeWithString:@"请选择城市" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UIControl* view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 25 + size.width, self.navigationController.navigationBar.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    _backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.frame.size.height / 4, 20, view.frame.size.height / 2)];
    _backIV.image = [UIImage imageNamed:@"mm_title_back.png"];
    _backLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backIV.frame) + 5, 0, size.width, view.frame.size.height)];
    
    _backLabel.text = @"请选你城市";
    _backLabel.textColor = [UIColor whiteColor];
    [view addSubview:_backIV];
    [view addSubview:_backLabel];
    
    [view addTarget:self action:@selector(changeAlpha) forControlEvents:UIControlEventTouchDown];
    [view addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftItem;

}

- (void) loginAction
{
    NSLog(@"login Action");
    [self presentViewController:loginNC animated:YES completion:nil];
    _backLabel.alpha = 1.0;
    _backIV.alpha = 1.0;

}

- (void) changeAlpha
{
    _backLabel.alpha = 0.2;
    _backIV.alpha = 0.2;
}

@end
