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
#import "MBProgressHUBTool.h"
#import "WaitView.h"

@interface AboutYouLinViewController (){
    UIColor *_viewColor;
    UILabel *_checkVersionUpdate;
    aboutTermsViewController*  aboutTermsController;
}

@end

@implementation AboutYouLinViewController{

    NSURLSessionDataTask *dataTask;
    UIView *backgroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.view.backgroundColor = _viewColor;
    WaitView* waitView = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"检查中..."];
    backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:waitView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{

    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"";
    /*设置协议初始化*/
    _yinsiLabel.frame = CGRectMake(0, screenHeight-65, screenWidth, 30);
    _yinsiLabel.textAlignment = NSTextAlignmentCenter;
    _yinsiLabel.userInteractionEnabled=YES;
    _youfanLabel.frame = CGRectMake(0, screenHeight-40, screenWidth, 30);
    _youfanLabel.textAlignment = NSTextAlignmentCenter;
    _youlinIV.center = CGPointMake(screenWidth/2, 90);
    _versionLab.center = CGPointMake(screenWidth/2, 150);
    _tipLab.center = CGPointMake(screenWidth/2, 190);
    
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
/*版本更新*/
-(void)versionUpdateAction{
    
    [self.parentViewController.view addSubview:backgroundView];
    dataTask=[[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",APP_URL]]] completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
              {
                  
                  NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
                  NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
                  if (data == nil) {
                      NSLog(@"你没有连接网络哦");
                      return;
                  }
                  NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                  if (error) {
                      NSLog(@"hsUpdateAppError:%@",error);
                      return;
                  }
                  NSArray *array = appInfoDic[@"results"];
                  NSDictionary *dic = array[0];
                  NSString *appStoreVersion = dic[@"version"];
                  //NSString *releaseNotes = [dic objectForKey:@"releaseNotes"];
                  NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"];
                  NSLog(@"trackViewUrl is %@",trackViewUrl);
                  //打印版本号
                  NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
                  //更新
                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                      //Do UI stuff here
                      [self updateUI];
                  }];

                   //[self performSelectorOnMainThread:@selector(updateUI) withObject:self.view waitUntilDone:NO];
                  if([currentVersion floatValue] < [appStoreVersion floatValue])
                  {
                      
                      UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] message:nil preferredStyle:UIAlertControllerStyleAlert];
                      alertVC.view.tintColor = [UIColor blackColor];
                      UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                          NSLog(@"取消");
                      }];
                      
                      UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          NSURL * url = [NSURL URLWithString:trackViewUrl];
                          [[UIApplication sharedApplication] openURL:url];
                      }];
                      [alertVC addAction:cancelAction];
                      [alertVC addAction:OKAction];
                      [self presentViewController:alertVC animated:YES completion:nil];
                  }else{
                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                          //Do UI stuff here
                       [MBProgressHUBTool textToast:self.view Tip:@"已经是最新版本！"];
                      }];
                  }
            
              }];
    
    [dataTask resume];
    
}
-(void)updateUI{

[backgroundView removeFromSuperview];

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
