//
//  MBProgressHUBTool.m
//  nfsYouLin
//
//  Created by Macx on 16/7/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "MBProgressHUBTool.h"

@implementation MBProgressHUBTool


+ (void)textToast:(UIView *)view  Tip:(NSString *)tips
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Set the annular determinate mode to show task progress.navigationController.view
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor=[UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.minSize=CGSizeMake(50, 50);
    hud.label.text = NSLocalizedString(tips, @"HUD message title");
    
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font= [UIFont systemFontOfSize:15];
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:3.f];
}
@end
