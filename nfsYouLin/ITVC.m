//
//  ITVC.m
//  nfsYouLin
//
//  Created by Macx on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ITVC.h"
#import "addressInfomationViewController.h"
#import "FeedbackViewController.h"
#import "ISettingViewController.h"
#import "Users.h"
#import "AppDelegate.h"
#import "AboutYouLinViewController.h"
#import "PersonalInformationViewController.h"
#import "SignIntegralViewController.h"
#import "IntegralMallViewController.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "SqliteOperation.h"
#import "SqlDictionary.h"
#import "MBProgressHUBTool.h"
#import "UIImageView+WebCache.h"
#import "IPostVC.h"
#import "ICollectVC.h"

@interface ITVC ()

@end

@implementation ITVC
{
    
    UIColor* _viewColor;
    NSArray* _images;
    NSArray* _cellNames;
    UILabel *integralLab;
    UILabel *favoriteLab;
    UILabel *postLab;
    addressInfomationViewController *_addressInfomationController;
    FeedbackViewController *FeedbackController;
    ISettingViewController *ISettingController;
    AboutYouLinViewController *AboutYouLinController;
    PersonalInformationViewController *PersonalInformationController;
    multiTableViewCell *multiTableCell;
    SignIntegralViewController *SignIntegralController;
    IntegralMallViewController *IntegralMallController;
    IPostVC *postVC;
    ICollectVC *collectVC;
    UIBarButtonItem* backItemTitle;
    UIButton *signButton;
    NSInteger nowPoints;
    __block NSString *initIntegralValue;
    Users* user;
    
}

- (id) init
{
    self = [super init];
    if(self)
    {
        [self initUser];
        self.tableView.bounces = NO;
        _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
        self.view.backgroundColor = _viewColor;
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        _images = @[@"dizhixinxi.png", @"yijianfankui.png", @"shezhi.png", @"guanyu.png"];
        _cellNames = @[@"地址信息", @"意见反馈", @"设置", @"关于"];
        /*跳转至地址信息页面*/
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _addressInfomationController=[storyBoard instantiateViewControllerWithIdentifier:@"addressInfomationController"];
        backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"地址信息" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIStoryboard* iStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        FeedbackController=[iStoryBoard instantiateViewControllerWithIdentifier:@"feedbackcontroller"];
        ISettingController=[iStoryBoard instantiateViewControllerWithIdentifier:@"isettingcontroller"];
        AboutYouLinController=[iStoryBoard instantiateViewControllerWithIdentifier:@"aboutyoulincontroller"];
        PersonalInformationController=[iStoryBoard instantiateViewControllerWithIdentifier:@"personalinformationcontroller"];
        SignIntegralController=[iStoryBoard instantiateViewControllerWithIdentifier:@"signintegralcontroller"];
        IntegralMallController=[iStoryBoard instantiateViewControllerWithIdentifier:@"integralmallcontroller"];
        postVC=[iStoryBoard instantiateViewControllerWithIdentifier:@"ipostid"];
        collectVC=[iStoryBoard instantiateViewControllerWithIdentifier:@"icollectid"];
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
  
    UIControl *integralView=(UIControl *)[self.view viewWithTag:2016];
    integralView.backgroundColor=[UIColor whiteColor];
    UIControl *favoriteView=(UIControl *)[self.view viewWithTag:2017];
    favoriteView.backgroundColor=[UIColor whiteColor];
    UIControl *publishView=(UIControl *)[self.view viewWithTag:2018];
    publishView.backgroundColor=[UIColor whiteColor];
    // 自定义导航返回箭头
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.delegate=self;
    
    /*获取返回后积分数*/
    [IntegralMallController returnText:^(NSString *showText) {
        
        initIntegralValue=showText;
    }];
    if(initIntegralValue!=nil)
    {
        integralLab.text= [NSString stringWithFormat:@"%@",initIntegralValue];
    }
    /*获取返回后收藏数*/
    
    /*获取返回后我发的数*/
    
    [self initUser];
    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getCredPostCol:(long) userid
{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* myId = [NSString stringWithFormat:@"%ld",userid];
    NSString* commId= [NSString stringWithFormat:@"%ld",[SqliteOperation getNowCommunityId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@",myId,commId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1024",hashString]];
    NSDictionary* parameter = @{@"user_id" : myId,
                                @"community_id" :commId,
                                @"deviceType":@"ios",
                                @"apitype" : @"comm",
                                @"tag" : @"getcount",
                                @"salt" : @"1024",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:community_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"ifpresponseObject is %@",responseObject);
        
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            
            integralLab.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"myCredit"]];
            favoriteLab.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"mycolNum"]];
            postLab.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"myPost"]];
            
        }else{
            
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger elementOfSection;
    switch (section) {
        case 0:
            elementOfSection = 2;
            break;
        case 1:
            elementOfSection = 4;
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
    NSInteger section = indexPath.section;
    multiTableViewCell* cell = nil;
    signButton = [[UIButton alloc] initWithFrame:CGRectMake(320, 30, 40, 40)];
    signButton.layer.cornerRadius = signButton.frame.size.width / 2;
    signButton.layer.masksToBounds = YES;
    [signButton setBackgroundImage:[UIImage imageNamed:@"btn_qiandao.png"] forState:UIControlStateNormal];
    [signButton addTarget:self action:@selector(signGetIntegralAction) forControlEvents:UIControlEventTouchDown];
    if(section == 0)
    {
        NSString* cellZero = @"cellZero";
        NSString* cellOne = @"cellOne";
        if(rowNo == 0)
        {
            
            cell = (multiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellZero];
            if(cell == nil)
            {
                cell = [[multiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellZero];
            }
            [cell.contentView addSubview:signButton];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.delegate = self;
            cell.userData = user;
            
        }
        else if(rowNo == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellOne];
            if(cell == nil)
            {
                cell = [[multiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOne];
                /*积分*/
                UIControl *pointsView=cell.integralView;
                pointsView.tag=2016;
                [pointsView addTarget:self action:@selector(touchDownIntegral:) forControlEvents:UIControlEventTouchDown];
                integralLab=cell.integralLabel;
                /*收藏*/
                UIControl *favoriteControlView=cell.favoriteView;
                //cell.integralView.backgroundColor=[UIColor whiteColor];
                favoriteControlView.tag=2017;
                [favoriteControlView addTarget:self action:@selector(touchDownFavorite:) forControlEvents:UIControlEventTouchDown];
                favoriteLab=cell.favoriteLabel;
                /*我发的*/
                UIControl *publishControlView=cell.publishView;
                //cell.integralView.backgroundColor=[UIColor whiteColor];
                publishControlView.tag=2018;
                [publishControlView addTarget:self action:@selector(touchDownPublish:) forControlEvents:UIControlEventTouchDown];
                postLab=cell.publishLable;
            }
            [self getCredPostCol:[SqliteOperation getUserId]];
        }
    }
    else if(section == 1)
    {
        NSString* cellId = @"cellId";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[multiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.textLabel.text = _cellNames[rowNo];
        cell.imageView.image = [UIImage imageNamed:_images[rowNo]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else
    {
        NSLog(@"cellForRowAtIndexPath section = %ld",section);
    }
    
    
    return cell;
}
- (void) touchDownIntegral:(id) sender{
    
    UIControl *integralView=(UIControl *)[self.view viewWithTag:[sender tag]];
    integralView.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    //UILabel *integtalLabel=(UILabel *)[self.view  viewWithTag:1024];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* communityId = [NSString stringWithFormat:@"%ld", [SqliteOperation getNowCommunityId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",communityId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@2016",hashString]];
    NSDictionary* parameter = @{@"community_id" : communityId,
                                @"deviceType":@"ios",
                                @"apitype" : @"exchange",
                                @"tag" : @"getgiftlist",
                                @"salt" : @"2016",
                                @"hash" : hashMD5,
                                @"keyset" : @"community_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray * goodsMutableAry=[responseObject objectForKey:@"info"];
        IntegralMallController.goodsArray=goodsMutableAry;
        IntegralMallController.pointStr=integralLab.text;
        
        backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"积分" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];
        [self.parentViewController.navigationController pushViewController:IntegralMallController animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];
    
    
}

- (void) touchDownFavorite:(id) sender{
    
    UIControl *favoriteView=(UIControl *)[self.view viewWithTag:[sender tag]];
    favoriteView.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"我的收藏" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];
    [self.parentViewController.navigationController pushViewController:collectVC animated:YES];
}

- (void) touchDownPublish:(id) sender{
    
    UIControl *publishView=(UIControl *)[self.view viewWithTag:[sender tag]];
    publishView.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"我发的" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];
    [self.parentViewController.navigationController pushViewController:postVC animated:YES];
}

-(void)signGetIntegralAction{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@",userId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@729",hashString]];
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"getsigndate",
                                @"salt" : @"729",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SignIntegralController.nowWeekSignedArray=[[NSMutableArray alloc] init];
        SignIntegralController.monthSignedArray=[[NSMutableArray alloc] init];
        NSMutableArray *responseObjectAry=[responseObject objectForKey:@"info"];
        SignIntegralController.allPoints=[integralLab.text intValue];
        //SignIntegralController.todayPoints=[[responseObjectAry objectAtIndex:0][@"credit"] intValue];
        for(int i=1;i<[responseObjectAry count];i++)
        {
            
            NSString *year=[[responseObjectAry objectAtIndex:i][@"year"] stringValue];
            NSString *month=[[responseObjectAry objectAtIndex:i][@"month"] stringValue];
            NSString *day=[[responseObjectAry objectAtIndex:i][@"day"] stringValue];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            if([month intValue]<10){
                
                [formatter setDateFormat:@"M.dd"];
            }else{
                
                [formatter setDateFormat:@"MM.dd"];
            }
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[responseObjectAry objectAtIndex:i][@"timestamp"] stringValue]intValue]];
            
            NSString *dateString=[formatter stringFromDate:date];
            /*获取本周签到日期*/
            if([month intValue]==[self month:[NSDate date]]&&[year intValue]==[self year:[NSDate date]])
            {
                for(int i=0;i<[[self getWeekTime] count];i++){
                    if([dateString isEqualToString:[[self getWeekTime] objectAtIndex:i]]){
                        
                        [SignIntegralController.nowWeekSignedArray addObject:dateString];
                        
                    }
                }
            }
            /*获取最近三个月的签到日期*/
            NSString *composeDateString=[NSString stringWithFormat:@"%@%@%@%@%@",year,@".",month,@".",day];
            [SignIntegralController.monthSignedArray addObject:composeDateString];
        }
        backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"积分签到" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];
        [self.parentViewController.navigationController pushViewController:SignIntegralController animated:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

// 获取当前周的周一到周日的日期
- (NSMutableArray *)getWeekTime
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger weekDay = [comp weekday];
    NSInteger day = [comp day];
    long firstDiff,lastDiff;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    NSMutableArray *weekDateArray=[[NSMutableArray alloc] init];
    for(int i=0;i<7;i++){
        NSDate *nextDay = [firstDayOfWeek dateByAddingTimeInterval:24*60*60*i];
        NSInteger nowmonth=[self month:nextDay];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if(nowmonth<10)
        {
            
            [formatter setDateFormat:@"M.dd"];
        }else{
            
            [formatter setDateFormat:@"MM.dd"];
        }
        NSString *firstDay = [formatter stringFromDate:nextDay];
        [weekDateArray addObject:firstDay];
    }
    
    return weekDateArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
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
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    headerView.backgroundColor = _viewColor;
    return headerView;
}


- (UIView*)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = nil;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    footerView.backgroundColor = _viewColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row
       == 0)
    {
        return 100;
    }
    else
        return 80;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 去掉cell 之间的分隔线
    if(indexPath.section == 0)
    {
        cell.separatorInset = UIEdgeInsetsMake(0, cell.frame.size.width, 0, 0);
    }
    //tableViewCell 下划线 长度设置为屏幕的宽
    else
    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowInSection = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            NSLog(@"SECTION 0");
            
            //个人信息
            backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"个人信息" style:UIBarButtonItemStylePlain target:nil action:nil];
            //初始化头像
            UIImageView *headPhotoView=[[UIImageView alloc] init];
            [headPhotoView sd_setImageWithURL:[NSURL URLWithString:user.userPortrait] placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
            //PersonalInformationController.imageView=[[UIImageView alloc] init];
            PersonalInformationController.imageView=headPhotoView;
            //初始化昵称
            UILabel* nicklabel=[[UILabel alloc] init];
            nicklabel.text=user.userName;
            PersonalInformationController.nicknameLabel=nicklabel;
            //初始化性别
            UILabel* sexlab=[[UILabel alloc] init];
            switch (user.userGender) {
                case 1:
                    sexlab.text=@"男";
                    break;
                case 2:
                    sexlab.text=@"女";
                    break;
                case 3:
                    sexlab.text=@"保密";
                    break;
                default:
                    break;
            }
            PersonalInformationController.sexLabel=sexlab;
            //初始化生日
            UILabel* birthdaylab=[[UILabel alloc] init];
            if(user.userBirthday==0)
            {
            
                birthdaylab.text=@"1970年01月01日";
            }else{
             
                birthdaylab.text=[self getShowDateWithTime:[NSString stringWithFormat:@"%ld",user.userBirthday]];
            }
            PersonalInformationController.birthdayLabel=birthdaylab;
            //初始化职业
            UILabel* vocationlab=[[UILabel alloc] init];
            vocationlab.text=user.vocation;
            PersonalInformationController.professionLabel=vocationlab;
            //初始化工作相关信息
            PersonalInformationController.statusValue=[NSString stringWithFormat:@"%ld",user.publicStatus];
            
            
            [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];

            [self.parentViewController.navigationController pushViewController:PersonalInformationController animated:YES];
            break;
        }
        case 1:
        {
            switch (rowInSection) {
                case 0:
                {
                    // 地址信息
                    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"地址信息" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];
                    [self.parentViewController.navigationController pushViewController:_addressInfomationController animated:YES];
                    break;
                }
                case 1:
                {
                    // 意见反馈
                    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"意见反馈" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];
                    [self.navigationController pushViewController:FeedbackController animated:YES];
                    break;
                }
                case 2:
                {
                    // 设置
                    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];
                    [self.navigationController pushViewController:ISettingController animated:YES];
                    break;
                }
                case 3:
                {
                    // 关于
                    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"关于优邻" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];
                    [self.navigationController pushViewController:AboutYouLinController animated:YES];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - 圆形头像点击事件回调
- (void)showCircularImageViewWithImage:(UIImage*) image
{

    UIView* addView = [[UIView alloc] initWithFrame:self.parentViewController.parentViewController.view.bounds];
    addView.alpha = 1.0;
    addView.backgroundColor = [UIColor whiteColor];
    [self.parentViewController.parentViewController.view addSubview:addView];
    ShowImageView* showImage = [[ShowImageView alloc] initWithFrame:self.view.frame circularImage:image];
    [showImage show:addView didFinish:^()
     {
         [UIView animateWithDuration:0.5f animations:^{
             
             showImage.alpha = 0.0f;
             addView.alpha = 0.0f;
             
         } completion:^(BOOL finished) {
             [showImage removeFromSuperview];
             [addView removeFromSuperview];
         }];
         
     }];
    
}

- (BOOL) initUser
{
    user = [[Users alloc] init];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = delegate.db;
    
    if([db open])
    {
        NSLog(@"iVC: db open success!");
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
        user.phoneNum = phoneNum;
        FMResultSet *result = [db executeQuery:@"SELECT user_name, user_portrait ,user_id,user_gender,user_birthday,user_vocation,user_public_status FROM table_users WHERE user_phone_number = ?",phoneNum];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"user_name"];
            NSString *portrait = [result stringForColumn:@"user_portrait"];
            long userid = [result longForColumn:@"user_id"];
            NSInteger sexVal=[result intForColumn:@"user_gender"];
            long birthdayVal=[result longForColumn:@"user_birthday"];
            NSString* vocationStr=[result stringForColumn:@"user_vocation"];
            NSInteger status=[result intForColumn:@"user_public_status"];
            user.userName = name;
            user.userPortrait = portrait;
            user.userId = userid;
            user.userBirthday = birthdayVal;
            user.userGender=sexVal;
            user.vocation=vocationStr;
            user.publicStatus=status;
            NSLog(@"user.userPortrait is %@",user.userPortrait);
            
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

/*计算毫秒数对应的生日*/
-(NSString *)getShowDateWithTime:(NSString *)time{
    NSDate *timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:[time longLongValue]/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString *timeStr = [dateFormatter stringFromDate:timeDate];
    return timeStr;
}

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated{
    if([[viewController class]isSubclassOfClass:[self class]]) {
        
    }
    ///删除代理，防止该controller销毁后引起
    if(![[viewController class]isSubclassOfClass:[self class]]) {
        
        self.navigationController.delegate=nil;
    }
    
}

@end
