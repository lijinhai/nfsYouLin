//
//  ISettingViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/6/30.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ISettingViewController.h"
#import "LewPopupViewController.h"
#import "quitView.h"
#import "LxxPlaySound.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUBTool.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "LoginNC.h"
#import "WaitView.h"
#import "AppDelegate.h"
#import "BlackListVC.h"

@interface ISettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ISettingViewController

{
    NSArray* _settingTypeName;
    UIColor* _viewColor;
    UISwitch *switchNoticeButton;
    UISwitch *switchShockButton;
    NSString *shockflag;
    NSString *noticeflag;
    UILabel *cacheCountLable;
    LoginNC* loginNC;
    UIView* backgroundView;
    
    NSURLSessionDataTask *dataTask;
    UIView *updatebgView;
    CGSize size;
    UIFont *fnt;
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"";
    switchNoticeButton = [[UISwitch alloc] initWithFrame:CGRectMake(_tableView.frame.size.width-70, 20, 40, 5)];
    [switchNoticeButton setOn:YES];
    [switchNoticeButton addTarget:self action:@selector(switchNoticeAction) forControlEvents:UIControlEventValueChanged];

    switchShockButton = [[UISwitch alloc] initWithFrame:CGRectMake(_tableView.frame.size.width-70, 20, 40, 5)];
    [switchShockButton setOn:YES];
    [switchShockButton addTarget:self action:@selector(switchShockAction) forControlEvents:UIControlEventValueChanged];
    shockflag=@"off";
    noticeflag=@"off";
   
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    _tableView.frame = CGRectMake(0, 0, screenWidth,530);
    _tableView.bounces = NO;
    self.view.backgroundColor = _viewColor;
    _settingTypeName = @[@"通知声音", @"振动", @"黑名单" ,@"检查更新" ,@"清除缓存" ,@"退出登录"];
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    WaitView* waitView = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"正在注销..."];
    backgroundView = [[UIView alloc] initWithFrame:self.parentViewController.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:waitView];
    
    WaitView* waitView1 = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"检查中..."];
    updatebgView = [[UIView alloc] initWithFrame:self.parentViewController.view.frame];
    updatebgView.backgroundColor = [UIColor clearColor];
    [updatebgView addSubview:waitView1];

    
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
   
    //BlackListController=[storyBoard instantiateViewControllerWithIdentifier:@"blacklistcontroller"];

    UIStoryboard* MainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    loginNC = [MainSB instantiateViewControllerWithIdentifier:@"loginNCID"];
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    /*计算缓存大小并初始化cacheCountLable*/
    fnt = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    cacheCountLable=[[UILabel alloc] init];
    cacheCountLable.font = fnt;
    cacheCountLable.text=[self getCacheSize];
    size = [cacheCountLable.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    cacheCountLable.frame=CGRectMake(_tableView.frame.size.width-size.width-40, 24, size.width, 20);
}



//开关声音
- (void)switchNoticeAction
{

    if([noticeflag isEqualToString:@"off"])
    {
        LxxPlaySound *sound =[[LxxPlaySound alloc] init];
        [sound vdealloc];
        noticeflag=@"on";
        
    }else{
        
        LxxPlaySound *sound = [[LxxPlaySound alloc]initForPlayingSystemSoundEffectWith:@"Tock" ofType:@"aiff"];
        [sound play];
        noticeflag=@"off";
    }

}

//开关振动
- (void)switchShockAction
{
    if([shockflag isEqualToString:@"off"])
    {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
        shockflag=@"on";
    
    }else{
    
        LxxPlaySound *playSound =[[LxxPlaySound alloc]initForPlayingVibrate];
        [playSound play];
        shockflag=@"off";
    }

}

//计算缓存
- (NSString *)getCacheSize
{
    
    long long sumSize = 0;
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    for (NSString *subPath in subPaths) {
                 NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
                 long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
                sumSize += fileSize;
        }
   float size_m = sumSize/(1000*1000);
    
   return [NSString stringWithFormat:@"%.2fM",size_m];
}

//清除缓存
-(void)clearCacheSize{

    cacheCountLable.text=@"0.00M";
    size = [cacheCountLable.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    cacheCountLable.frame=CGRectMake(_tableView.frame.size.width-size.width-40, 24, size.width, 20);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [fileManager removeItemAtPath:cacheFilePath error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger elementOfSection;
    switch (section) {
        case 0:
            elementOfSection = 2;
            break;
        case 1:
            elementOfSection = 3;
            break;
        case 2:
            elementOfSection = 1;
            break;
        default:
            elementOfSection = -1;
            break;
    }
    return elementOfSection;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    NSInteger sectionNo = indexPath.section;
    static NSString *CellIdentifier = @"settingid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        switch (sectionNo) {
            case 0:
                switch (rowNo) {
                    case 0:
                    {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textLabel.text = _settingTypeName[rowNo];
                        [cell.contentView addSubview:switchNoticeButton];
                        break;
                    }
                    case 1:
                    {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
                        cell.textLabel.text = _settingTypeName[rowNo];
                        [cell.contentView addSubview:switchShockButton];
                        break;
                    }
                    default:
                        break;
                }
                break;
            case 1:
                switch (rowNo) {
                    case 0:
                    {
                        cell.textLabel.text = _settingTypeName[rowNo+2];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        break;
                    }
                    case 1:
                    {
                        cell.textLabel.text = _settingTypeName[rowNo+2];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        break;
                    }
                    case 2:
                    {
                        cell.textLabel.text = _settingTypeName[rowNo+2];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        [cell.contentView addSubview:cacheCountLable];
                        break;
                    }
                    default:
                        break;
                }
                break;
            case 2:
                cell.textLabel.text = _settingTypeName[rowNo+5];
                cell.textLabel.textColor=[UIColor redColor];
                cell.textLabel.textAlignment=NSTextAlignmentCenter;
                break;
            default:
                break;
        }
        
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 16.f;
    }else
        return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 8.0f;
}


- (UIView*)tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* headerView = nil;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    headerView.backgroundColor = _viewColor;
    return headerView;
}


//- (UIView*)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView* footerView = nil;
//    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    footerView.backgroundColor = _viewColor;
//    return footerView;
//}

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


// 单元格选中
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowInSection = indexPath.row;
    NSInteger section = indexPath.section;
    NSLog(@"%ld",indexPath.row);
    switch (section) {
        case 1:
        {
            switch (rowInSection) {
                case 0:
                {
                    // 黑名单
                    //[self getBlackListInfo];
                    BlackListVC* blackListVC = [[BlackListVC alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:blackListVC animated:YES];
                    break;
                }
                case 1:
                {
                    // 检查更新
                    [self versionUpdateAction];
                    break;
                }
                case 2:
                {
                    // 清除缓存
                    [self clearCacheSize];
                    break;
                }
                default:
                    break;
            }

            break;
        }
        case 2:
        {
            NSLog(@"退出操作");
            quitView *view = [quitView defaultPopupView];
            UIButton* logoutBtn = view.logoutBtn;
            [logoutBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
            view.parentVC = self;
            [self lew_presentPopupView:view animation:[LewPopupViewAnimationSlide new] dismissed:^{
                //[self.otherTableView reloadData];
                
                NSLog(@"动画结束");
            }];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*版本更新*/
-(void)versionUpdateAction{
    
    [self.parentViewController.view addSubview:updatebgView];
    dataTask=[[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",APP_URL]]] completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
              {
                  
                  NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
                  NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
                  if (data == nil) {
                      NSLog(@"你没有连接网络哦");
                      return;
                  }
                  NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                  if (error) {
                      NSLog(@"hsUpdateAppError:%@",error);
                      return;
                  }
                  NSArray *array = appInfoDic[@"results"];
                  NSDictionary *dic = array[0];
                  NSString *appStoreVersion = dic[@"version"];
                  //NSString *releaseNotes = [dic objectForKey:@"releaseNotes"];
                  NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"];
                  NSLog(@"trackViewUrl is %@",trackViewUrl);
                  //打印版本号
                  NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
                  //更新
                  [self performSelectorOnMainThread:@selector(updateUI) withObject:self.view waitUntilDone:NO];
                  if([currentVersion floatValue] < [appStoreVersion floatValue])
                  {
                      
                      UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] message:nil preferredStyle:UIAlertControllerStyleAlert];
                      alertVC.view.tintColor = [UIColor blackColor];
                      UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                          NSLog(@"取消");
                      }];
                      
                      UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          NSURL * url = [NSURL URLWithString:trackViewUrl];
                          [[UIApplication sharedApplication] openURL:url];
                      }];
                      [alertVC addAction:cancelAction];
                      [alertVC addAction:OKAction];
                      [self presentViewController:alertVC animated:YES completion:nil];
                  }else{
                      [MBProgressHUBTool textToast:self.view Tip:@"已经是最新版本！"];
                      
                  }
                  
              }];
    
    [dataTask resume];
    
}
-(void)updateUI{
    
    [updatebgView removeFromSuperview];
    
}

- (void)textToast:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view    animated:YES];
    
    // Set the annular determinate mode to show task progress.navigationController.view
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor=[UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.minSize=CGSizeMake(30, 30);
    hud.label.text = NSLocalizedString(tips, @"HUD message title");
    
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font= [UIFont systemFontOfSize:15];
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:2.f];
}


/* 设置单元格宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}


// 退出登录
- (void) logoutAction: (id)sender
{
    [self.parentViewController.view addSubview:backgroundView];
    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSlide new]];
    [self deleteSqlite];
    [self logoutNet];
}

// 用户注销网络请求
- (void) logoutNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone%@user_id%@",phoneNum,userId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_phone" : phoneNum,
                                @"user_id" : userId,
                                @"apitype" : @"users",
                                @"salt" : @"1",
                                @"tag" : @"logoff",
                                @"hash" : hashString,
                                @"keyset" : @"user_phone:user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"注销网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            NSLog(@"成功");
            [self presentViewController:loginNC animated:YES completion:nil];
        }
        else
        {
            NSLog(@"注销失败");
        }
        [backgroundView removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 删除数据库中的表
- (BOOL) deleteSqlite
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = delegate.db;
    
    if([db open])
    {
        NSLog(@"iSettingVC: db open success!");
        BOOL success =  [db executeUpdate:@"DELETE FROM table_users"];
        if(success)
        {
            NSLog(@"iSettingVC: delete table_users success!");
        }
        else
        {
            NSLog(@"iSettingVC: delete table_users failed!");
            [db close];
            return NO;
        }
        
        success =  [db executeUpdate:@"DELETE FROM table_all_family"];
        if(success)
        {
            NSLog(@"iSettingVC: delete table_all_family success!");
        }
        else
        {
            NSLog(@"iSettingVC: delete table_all_family failed!");
            [db close];
            return NO;
        }

        
        [db close];
    
    }
    else
    {
        NSLog(@"iVC: db open error!");
        return NO;
    }
    
    
    return YES;
}


@end
