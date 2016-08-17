//
//  ProfessionSettingViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ProfessionSettingViewController.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "SqliteOperation.h"
#import "SqlDictionary.h"
@interface ProfessionSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ProfessionSettingViewController{

    UIColor *_viewColor;
    UISwitch *switchWorkerButton;
    NSInteger publiceStatusInt;
    Boolean flag;
    NSString* userId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=_viewColor;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"";
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    /*switch 按钮*/
    switchWorkerButton = [[UISwitch alloc] initWithFrame:CGRectMake(_workSettingTable.frame.size.width-70, 10, 40, 5)];
    NSLog(@"999999_statusStateis %@",_statusState);
    if([@"3" isEqualToString:_statusState]||[@"4" isEqualToString:_statusState])
    {
        NSLog(@"开启");
        [switchWorkerButton setOn:YES];
    }else{
        NSLog(@"关闭");
        [switchWorkerButton setOn:NO];
    }
    
    [switchWorkerButton addTarget:self action:@selector(switchWorkerAction:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"*******");
    /*表格初始化*/
    _workSettingTable.dataSource=self;
    _workSettingTable.delegate=self;
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([_workSettingTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_workSettingTable setSeparatorInset:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    
    if ([_workSettingTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_workSettingTable setLayoutMargins:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    self.navigationItem.title=@"";
    _workerNameTextField.backgroundColor=[UIColor whiteColor];
    _workerNameTextField.delegate=self;
    [_workerNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if(![_workerValue isEqualToString:@""])
    {
        _workerNameTextField.text=_workerValue;
    }
    publiceStatusInt=[_statusState intValue];
    
}

- (void)returnText:(ReturnWorkerTextBlock)block {
    
    self.returnWorkerTextBlock = block;
}
-(void)returnShow:(ReturnWorkerShowBlock)block
{
    self.returnWorkerShowBlock=block;
}
-(void)sureAction{
    
    [self submitVocationInfo];
    
    //回传职业名
    if (self.returnWorkerTextBlock != nil) {
        self.returnWorkerTextBlock(_workerNameTextField.text);
        NSLog(@"_workerNameTextField is %@",_workerNameTextField.text);
    }
    //回传职业状态
    if (self.returnWorkerShowBlock != nil) {
        self.returnWorkerShowBlock([NSString stringWithFormat:@"%ld",publiceStatusInt]);
        NSLog(@"publiceStatusInt is %ld",publiceStatusInt);
    }
    //更新用户表中的职业和状态
    [SqliteOperation updateUserWorkInfo:[userId longLongValue] userVocation:_workerNameTextField.text publicStatus:publiceStatusInt];
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*改变职业*/
-(void)changeVocationContent{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%@user_vocation%@",phoneNum,userId,_workerNameTextField.text]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@810",hashString]];
    NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                @"user_id" : userId,
                                @"user_vocation":_workerNameTextField.text,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"upload",
                                @"salt" : @"810",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_phone_number:user_id:user_vocation:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"VocationContentresponseObject is %@",responseObject);
        if([[responseObject objectForKey:@"ok"] isEqualToString:@"ok"])
        {
            
            
        }else{
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *CellIdentifier = @"infoid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *tiplabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 40, tableView.frame.size.width,60)];
    tiplabel.font=[UIFont systemFontOfSize:14];
    tiplabel.text=@"找到更多同兴趣的好友，一起交流进步，与此同时也能与其他行\n业的好友进行沟通，扩展知识面，发现自己感兴趣的圈子，从而\n丰富自己的生活";
    tiplabel.textColor=[UIColor darkGrayColor];
    tiplabel.numberOfLines=0;
    
     UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width,20)];
    titleLabel.text=@"公开职业的好处";
    titleLabel.font=[UIFont systemFontOfSize:17];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
       
        if(rowNo==0)
        {
          
            [cell.contentView addSubview:switchWorkerButton];
             cell.textLabel.text=@"公开职业：";
            
        }else{
        
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:tiplabel];
        
        }
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        
    }
    //[tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    return cell;

}
- (void)switchWorkerAction:(UISwitch *)sw
{
    
    NSLog(@"_statusState is %@",_statusState);
    if(sw.isOn)
    {
        NSLog(@"开启");
        publiceStatusInt=publiceStatusInt+2;
        
    }else{
        
        NSLog(@"关闭");
        publiceStatusInt=publiceStatusInt-2;
        
    }
    //_statusState=[NSString stringWithFormat:@"%ld",publiceStatusInt];
    NSLog(@"publiceStatusInt is %ld",publiceStatusInt);

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row
       == 1)
    {
        return 100;
    }
    else
        return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 380.0f;
}
- (UIView*)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = nil;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 370)];
    footerView.backgroundColor = _viewColor;
    return footerView;
}




-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.workerNameTextField) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}
- (void)submitVocationInfo
{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    flag=NO;
    // 创建队列组，可以使两个网络请求异步执行，执行完之后再进行操作
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"ssssss_workerNameTextField.text is %@",_workerNameTextField.text);
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
        [manager.securityPolicy setValidatesDomainName:NO];
        NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%@user_vocation%@",phoneNum,userId,_workerNameTextField.text]];
        NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@810",hashString]];
        NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                    @"user_id" : userId,
                                    @"user_vocation":_workerNameTextField.text,
                                    @"deviceType":@"ios",
                                    @"apitype" : @"users",
                                    @"tag" : @"upload",
                                    @"salt" : @"810",
                                    @"hash" : hashMD5,
                                    @"keyset" : @"user_phone_number:user_id:user_vocation:",
                                    };
        
        [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"VocationContentresponseObject is %@",responseObject);
            if([[responseObject objectForKey:@"ok"] isEqualToString:@"ok"])
            {
               dispatch_semaphore_signal(semaphore);
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_semaphore_signal(semaphore);
            NSLog(@"%@", [error localizedDescription]);
        }];
        
        // 在请求成功之前等待信号量(-1)
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
        [manager.securityPolicy setValidatesDomainName:NO];
        NSString* statusStr=[NSString stringWithFormat:@"%ld",publiceStatusInt];
        NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%@user_public_status%@",phoneNum,userId,statusStr]];
        NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@810",hashString]];
        NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                    @"user_id" : userId,
                                    @"user_public_status":statusStr,
                                    @"deviceType":@"ios",
                                    @"apitype" : @"users",
                                    @"tag" : @"upload",
                                    @"salt" : @"810",
                                    @"hash" : hashMD5,
                                    @"keyset" : @"user_phone_number:user_id:user_public_status:",
                                    };
        
        [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_semaphore_signal(semaphore);
            NSLog(@"VocationShowresponseObject is %@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_semaphore_signal(semaphore);
            NSLog(@"%@", [error localizedDescription]);
        }];
        // 在请求成功之前等待信号量
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    // 请求完成之后
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
}
@end
