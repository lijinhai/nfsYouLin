//
//  IntegralRulesViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/28.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralRulesViewController :UIViewController<UIWebViewDelegate,NSURLConnectionDelegate>{
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
    BOOL _authenticated;
}

@property (weak, nonatomic) IBOutlet UIWebView *integralRulesWebView;

@end
