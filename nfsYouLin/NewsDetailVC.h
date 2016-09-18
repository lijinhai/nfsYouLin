//
//  NewsDetailVC.h
//  nfsYouLin
//
//  Created by Macx on 16/9/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewShareView.h"

@interface NewsDetailVC : UIViewController<UIWebViewDelegate,NewShareDelegate>


@property(strong ,nonatomic) NSString* newsUrl;

@property(strong ,nonatomic) NSString* newsTitle;
@property(strong, nonatomic) NSString* newsImage;
@property(assign, nonatomic) NSInteger newsId;
@end
