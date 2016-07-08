//
//  AboutYouLinViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/1.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "AboutYouLinViewController.h"
#import "aboutTermsViewController.h"
#import "UIViewLinkmanTouch.h"


@interface AboutYouLinViewController (){
    UIColor *_viewColor;
    UILabel *_checkVersionUpdate;
    aboutTermsViewController*  aboutTermsController;
}

@end

@implementation AboutYouLinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor = _viewColor;
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{

    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"";
    /*设置协议初始化*/
    _yinsiLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yinSiTouchUpInside)];
    [_yinsiLabel addGestureRecognizer:labelTapGestureRecognizer];
    /*添加检查更新的view*/
    _checkUpdateView = [[UIViewLinkmanTouch alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 40)];
    _checkUpdateView.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(versionUpdateAction)];
    
    [_checkUpdateView addGestureRecognizer:tapGesture];
    
    
    _checkVersionUpdate=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
    _checkVersionUpdate.text=@"检查版本更新";
    _checkVersionUpdate.font=[UIFont systemFontOfSize:15];
    [_checkUpdateView addSubview:_checkVersionUpdate];
    [self.view addSubview:_checkUpdateView];
    /*跳转页面初始化*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    aboutTermsController = [storyBoard instantiateViewControllerWithIdentifier:@"aboutController"];


}
/*检查版本更新*/
-(void)versionUpdateAction{


    NSLog(@"版本更新了么");
     //_checkUpdateView.backgroundColor=_viewColor;

}
/*跳转到隐私协议页面*/
- (void)yinSiTouchUpInside{

    /*跳转至关于优邻服务协议*/
    UIBarButtonItem* aboutYouLinItem = [[UIBarButtonItem alloc] initWithTitle:@"关于优邻服务协议" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:aboutYouLinItem];
    [self.navigationController pushViewController:aboutTermsController animated:YES];

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
