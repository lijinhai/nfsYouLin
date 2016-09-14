//
//  NewsDetailVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NewsDetailVC.h"

@interface NewsDetailVC ()

@end

@implementation NewsDetailVC
{
    UIWebView* _webView;
    UIView* _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton* rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 30, 7)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_fenxiang.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat Y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, Y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - Y)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 3)];
    _progressView.backgroundColor = [UIColor colorWithRed:51/255.0 green:181/255.0 blue:229/255.0 alpha:1];
    [_webView addSubview:_progressView];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.newsUrl]];
    [_webView loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UIWebViewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressView removeFromSuperview];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_progressView removeFromSuperview];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark -导航栏右侧按钮 分享等
- (void) rightClicked
{
    
}

@end
