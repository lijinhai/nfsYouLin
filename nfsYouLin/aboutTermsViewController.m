//
//  aboutTermsViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "aboutTermsViewController.h"

@interface aboutTermsViewController ()

@end

@implementation aboutTermsViewController
@synthesize youlinServiceInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url=[[NSURL alloc]initWithString:@"http://123.57.9.62/yl/privacy_clause/"];
    //_request=[NSURLRequest requestWithURL:url];
    youlinServiceInfo.delegate=self;
      [youlinServiceInfo setScalesPageToFit:YES];
    [youlinServiceInfo loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)viewWillAppear:(BOOL)animated
{
    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"";

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authenticated);
    @try {
        if (!_authenticated) {
            _authenticated = NO;
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:_request] resume];
            return NO;
        }

    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    return YES;
}


#pragma mark - NURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if ([challenge previousFailureCount] == 0)
    {
        _authenticated = YES;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");
    
    _authenticated = YES;
    [youlinServiceInfo loadRequest:_request];
    
    [_urlConnection cancel];
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
@end
