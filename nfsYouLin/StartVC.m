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
#import "ErrorVC.h"


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
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"imei%@addr_cache-1",identifierNumber]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    NSDictionary* parameter = @{@"imei" : identifierNumber,
                                @"apitype" : @"users",
                                @"tag" : @"token",
                                @"addr_cache" : @"-1",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"imei:addr_cache:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"验证账户可用性 网络请求请求成功:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        NSString* addr_flag = [responseObject valueForKey:@"addr_flag"];
        
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"flag+addr_flag" message:[NSString stringWithFormat:@"%@+%@",flag,addr_flag] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
        if([flag isEqualToString:@"ok"] && [addr_flag isEqualToString:@"ok"])
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[responseObject valueForKey:@"user_nick"] forKey:@"nick"];
            [defaults setObject:[responseObject valueForKey:@"user_id"] forKey:@"userId"];
            [defaults synchronize];
            [self presentViewController:_firstTBC animated:YES completion:nil];
        }
        else if([addr_flag isEqualToString:@"empty"])
        {
            if([flag isEqualToString:@"no"])
            {
                [self presentViewController:_firstTBC animated:YES completion:nil];
            }
            else
            {
                NSString* shareInfo = [StringMD5 replaceUnicode:[responseObject valueForKey:@"share_info"]];
                NSLog(@"shareInfo = %@",shareInfo);
                [self presentViewController:_loginNC animated:YES completion:nil];
            }
            
        }
        else
        {
            [self presentViewController:_loginNC animated:YES completion:nil];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData* data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        ErrorVC* errorVC = [[ErrorVC alloc] init];
        errorVC.error = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"验证账户可用性 请求失败:%@", errorVC.error);
        [self.navigationController pushViewController:errorVC animated:YES];
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
