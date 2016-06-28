//
//  addressVerificationViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/6/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "addressVerificationViewController.h"
#import "scanQrCodeViewController.h"
#import "fillVerifyCodeViewController.h"

@interface addressVerificationViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation addressVerificationViewController{
    UIColor *_viewColor;
    scanQrCodeViewController *_scanQrCodeController;
    fillVerifyCodeViewController *_fillVerifyCodeController;
    UIBarButtonItem* valiyAddressItem;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    // Do any additional setup after loading the view.
    _valiyFunctionTable.sectionFooterHeight = 800.0f;
    UIView *footView = [UIView new];
    _valiyFunctionTable.tableFooterView=footView;
    footView.frame = CGRectMake(0, 0, 400, 800);
    footView.backgroundColor=_viewColor;
    [self.valiyFunctionTable setTableFooterView:footView];

    
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([self.valiyFunctionTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.valiyFunctionTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.valiyFunctionTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.valiyFunctionTable setLayoutMargins:UIEdgeInsetsZero];
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"";
    self.valiyFunctionTable.delegate=self;
    self.valiyFunctionTable.dataSource=self;
    /*跳转到扫描二维码页面*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _scanQrCodeController = [storyBoard instantiateViewControllerWithIdentifier:@"scanqrcode"];
    _fillVerifyCodeController = [storyBoard instantiateViewControllerWithIdentifier:@"fillverifycode"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger elementOfSection;
    switch (section) {
        case 0:
            elementOfSection = 1;
            break;
        case 1:
            elementOfSection = 1;
            break;
        default:
            elementOfSection = -1;
            break;
    }
    return elementOfSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"functionid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSInteger rowNumber=[indexPath row];
    NSInteger sectionNo = indexPath.section;
    UILabel *QrCodeLabel1=[[UILabel alloc] initWithFrame:CGRectMake(65, 22, 300, 32)];
    UILabel *QrCodeLabel2=[[UILabel alloc] initWithFrame:CGRectMake(65,0,100,32)];
    
    UILabel *codesLabel1=[[UILabel alloc] initWithFrame:CGRectMake(65, 22, 300, 32)];
    UILabel *codesLabel2=[[UILabel alloc] initWithFrame:CGRectMake(65,0,100,32)];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
    }
    if(sectionNo==0&&rowNumber==0)
    {
       
        QrCodeLabel1.text=@"选择后，扫描二维码，即可通过认证";
        QrCodeLabel1.font=[UIFont systemFontOfSize:14];
        QrCodeLabel1.textColor=[UIColor lightGrayColor];
        
        QrCodeLabel2.text = @"二维码";
        QrCodeLabel2.font=[UIFont systemFontOfSize:16];
 
        [cell.contentView addSubview:QrCodeLabel2];
        [cell.contentView addSubview:QrCodeLabel1];
        cell.imageView.image = [UIImage imageNamed:@"icon_erweima"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    }else if(sectionNo==1&&rowNumber==0){
    
        codesLabel1.text=@"选择后，输入验证码，即可通过认证";
        codesLabel1.font=[UIFont systemFontOfSize:14];
        codesLabel1.textColor=[UIColor lightGrayColor];
        
        codesLabel2.text = @"验证码";
        codesLabel2.font=[UIFont systemFontOfSize:16];
  
        [cell.contentView addSubview:codesLabel1];
        [cell.contentView addSubview:codesLabel2];
        cell.imageView.image = [UIImage imageNamed:@"icon_yanzhengma"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    }
    return cell;
}
#pragma mark 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowNumber=[indexPath row];
    NSInteger sectionNo = indexPath.section;
    if(sectionNo==0&&rowNumber==0)
    {
        
      self.navigationController.navigationBarHidden = YES;
     [self.navigationController pushViewController:_scanQrCodeController animated:YES];
        
    }else if(sectionNo==1&&rowNumber==0){
        
        valiyAddressItem = [[UIBarButtonItem alloc] initWithTitle:@"验证码验证地址" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:valiyAddressItem];
        [self.navigationController pushViewController:_fillVerifyCodeController animated:YES];
        
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

/* 设置单元格宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


- (UIView*)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = nil;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    footerView.backgroundColor = _viewColor;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.f;
    }else
        return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

@end
