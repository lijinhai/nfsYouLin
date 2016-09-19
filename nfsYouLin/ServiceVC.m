//
//  ServiceVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ServiceVC.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"


@interface ServiceVC ()

@end

@implementation ServiceVC
{
    UILabel* _barL;
    
    NSMutableArray* serviceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    _barL = [[UILabel alloc] init];
    _barL.textColor = MainColor;
    _barL.font = [UIFont systemFontOfSize:18];
    _barL.backgroundColor = [UIColor whiteColor];
    _barL.layer.borderWidth = 0;
    serviceArr = [[NSMutableArray alloc] init];
    [self communityServiceNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [serviceArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 275;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    NSInteger row = indexPath.row;
    ServiceCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[ServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = BackgroundColor;
    cell.serviceView.serviceInfo = [serviceArr objectAtIndex:row];
    cell.s_delegate = self;
    return cell;
}

#pragma mark -设置浮标显示
-(void) barShow:(NSString*) text showTime:(NSTimeInterval)time
{
    CGSize barSize = [StringMD5 sizeWithString:text font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(screenWidth, 30)];
    _barL.frame = CGRectMake((screenWidth - barSize.width) * 0.5, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 1, barSize.width, barSize.height);
    _barL.text = text;
    [self.parentViewController.view addSubview:_barL];
    [_barL performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:time];
}

#pragma mark -ServiceCellDelegate

- (void) selectedAddressCell:(NSString *)text
{
    [self barShow:text showTime:1];
}

- (void) selectedLongAddressCell:(NSString *)text
{
    [self barShow:text showTime:3];
}

- (void) selectedTimeCell:(NSString *)text
{
    [self barShow:text showTime:1];
}

- (void) selectecLongTimeCell:(NSString *)text
{
    [self barShow:text showTime:3];
}

#pragma mark -拨打电话
- (void) selectedPhoneCell:(NSString *)text;
{
    NSMutableString *phoneNum = [[NSMutableString alloc] initWithFormat:@"tel:%@",text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNum]]];
    [self.view addSubview:callWebview];
}

#pragma mark- 获取社区服务网络请求
- (void) communityServiceNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"community_id" : communityId,
                                @"apitype" : @"comsrv",
                                @"salt" : @"1",
                                @"tag" : @"loadsrv",
                                @"hash" : hashString,
                                @"keyset" : @"community_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取社区服务网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++) {
                [serviceArr addObject:[responseObject objectAtIndex:i]];
            }
        }
        [self.tableView reloadData];
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}



@end
