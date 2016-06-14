//
//  aboutTermsViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/5/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface aboutTermsViewController : UIViewController<UIWebViewDelegate,NSURLConnectionDelegate>{
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
    BOOL _authenticated;
}
@property (weak, nonatomic) IBOutlet UIWebView *youlinServiceInfo;

@end
