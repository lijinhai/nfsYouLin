//
//  NewsNeighborVC.h
//  nfsYouLin
//
//  Created by Macx on 16/9/18.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsNeighborVC : UIViewController<UITextViewDelegate>


@property(strong, nonatomic) UIScrollView* scrollView;
@property(strong, nonatomic) UIScrollView* bgView;

@property(strong, nonatomic) UITextView* titleTV;
@property(strong, nonatomic) UILabel* titlePlaceholder;

@property(strong, nonatomic) UITextView* contentTV;
@property(strong, nonatomic) UILabel* contentPlaceholder;

@property(strong, nonatomic) NSURL* newsUrl;
@property(strong, nonatomic) NSString* newsTitle;
@property(assign, nonatomic) NSInteger newsId;

@end
