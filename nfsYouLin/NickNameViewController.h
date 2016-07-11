//
//  NickNameViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/4.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NickNameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nikeNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property(nonatomic,retain) NSString *nikeNameValue;

typedef void (^ReturnTextBlock)(NSString *showText);
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;

@end
