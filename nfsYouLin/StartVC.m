//
//  StartVC.m
//  nfsYouLin
//
//  Created by Macx on 16/7/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "StartVC.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "FirstTabBarController.h"
#import "LoginNC.h"



@interface StartVC ()

@end

@implementation StartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    __block FirstTabBarController* _firstTBC;
    __block LoginNC* _loginNC;
    
    _firstTBC = [storyBoard instantiateViewControllerWithIdentifier:@"viewID"];
     _loginNC = [storyBoard instantiateViewControllerWithIdentifier:@"loginNCID"];
    
    
    // 验证账户可用性 网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    NSLog(@"手机序列号: %@",identifierNumber);
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"imei%@addr_cache0",identifierNumber]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    NSDictionary* parameter = @{@"imei" : identifierNumber,
                                @"apitype" : @"users",
                                @"tag" : @"token",
                                @"addr_cache" : @"0",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"imei:addr_cache:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            [self presentViewController:_firstTBC animated:YES completion:nil];
        }
        else if([flag isEqualToString:@"no"])
        {
            NSString* shareInfo = [StringMD5 replaceUnicode:[responseObject valueForKey:@"share_info"]];
            NSLog(@"shareInfo = %@",shareInfo);
            [self presentViewController:_loginNC animated:YES completion:nil];
        }
        else
        {
            [self presentViewController:_loginNC animated:YES completion:nil];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
