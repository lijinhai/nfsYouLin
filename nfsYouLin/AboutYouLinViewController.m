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
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"

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

    //项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    
    //appStore版本号
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",APP_URL]]] returningResponse:nil error:nil];
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"hsUpdateAppError:%@",error);
        return;
    }
    NSArray *array = appInfoDic[@"results"];
    NSDictionary *dic = array[0];
    NSString *appStoreVersion = dic[@"version"];
    NSString *releaseNotes = [dic objectForKey:@"releaseNotes"];
    NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"];
    NSLog(@"trackViewUrl is %@",trackViewUrl);
    //打印版本号
    NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
    //更新
    if([currentVersion floatValue] < [appStoreVersion floatValue])
    {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"更新");
            NSURL * url = [NSURL URLWithString:trackViewUrl];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        NSLog(@"不需要更新");
    }

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


@end
