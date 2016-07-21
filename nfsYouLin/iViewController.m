//
//  iViewController.m
//  nfsYouLin
//
//  Created by Macx on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "iViewController.h"
#import "addressInfomationViewController.h"
#import "FeedbackViewController.h"
#import "ISettingViewController.h"
#import "Users.h"
#import "AppDelegate.h"
#import "AboutYouLinViewController.h"
#import "PersonalInformationViewController.h"
#import "SignIntegralViewController.h"

@interface iViewController ()

@end

@implementation iViewController
{
    UIColor* _viewColor;
    NSArray* _images;
    NSArray* _cellNames;
    addressInfomationViewController *_addressInfomationController;
    FeedbackViewController *FeedbackController;
    ISettingViewController *ISettingController;
    AboutYouLinViewController *AboutYouLinController;
    PersonalInformationViewController *PersonalInformationController;
    multiTableViewCell *multiTableCell;
    SignIntegralViewController *SignIntegralController;
    UIBarButtonItem* backItemTitle;
    UIButton *signButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUser];
    /*改变BarItem 图片系统颜色为 自定义颜色 ffba20 */
    UIImage *iImageA = [UIImage imageNamed:@"btn_wo_a.png"];
    iImageA = [iImageA imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.iTabBarItem.selectedImage = iImageA;
    /* uicolor ffba20*/
    UIColor *fontColor= [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    
    [self.iTabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : fontColor
                                               } forState:UIControlStateSelected];
    //multiTableCell=[[multiTableViewCell alloc] init];
    //[multiTableCell.signButton addTarget:self action:@selector(signGetIntegralAction) forControlEvents:UIControlEventTouchDown];
    
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
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            }
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
-(void)signGetIntegralAction{

    
    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"积分签到" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.parentViewController.navigationItem setBackBarButtonItem:backItemTitle];
    [self.parentViewController.navigationController pushViewController:SignIntegralController animated:YES];
    /*获取签到日期*/
    SignIntegralController.nowWeekSignedArray=@[@"7.18",@"7.19"];
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
    
    //    UIView* addView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView* addView = [[UIView alloc] initWithFrame:self.parentViewController.parentViewController.view.bounds];
    addView.alpha = 1.0;
    addView.backgroundColor = [UIColor whiteColor];
    [self.parentViewController.parentViewController.view addSubview:addView];
    //    [self.view addSubview:addView];
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
        FMResultSet *result = [db executeQuery:@"SELECT user_name, user_portrait, user_phone_number FROM table_users WHERE id = 1"];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"user_name"];
            NSString *phoneNum = [result stringForColumn:@"user_phone_number"];
            NSString *portrait = [result stringForColumn:@"user_portrait"];
            user.userName = name;
            user.phoneNum = phoneNum;
            user.userPortrait = portrait;
            NSLog(@"name = %@",user.userName);
            NSLog(@"phoneNum = %@",user.phoneNum);
            NSLog(@"userPortrait = %@",user.userPortrait);
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
