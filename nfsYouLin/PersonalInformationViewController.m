//
//  PersonalInformationViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/4.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "ShowImageView.h"
#import "NickNameViewController.h"
#import "ModifyPasswordViewController.h"
#import "ChooseSexTypeViewController.h"
#import "ProfessionSettingViewController.h"
#import "LewPopupViewController.h"
#import "UpdatePhotoView.h"
#import "MBProgressHUD.h"
@interface PersonalInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@end

@implementation PersonalInformationViewController{

    UIColor *_viewColor;
    UIBarButtonItem *backItemTitle;
    UISwitch *switchFamliyAddressButton;
    UILabel *sexLabel;
    UILabel *birthdayLabel;
    UILabel *nicknameLabel;
    UILabel *dateLabel;
    UILabel *professionLabel;
    UIImageView *imageView;
    NickNameViewController *NickNameController;
    ModifyPasswordViewController *ModifyPasswordController;
    ChooseSexTypeViewController  *ChooseSexTypeController;
    ProfessionSettingViewController *ProfessionSettingController;
    __block NSString *initNikeName;
    __block NSString *nickflag;
    __block NSString *initSexName;
    __block NSString *sexflag;
    __block NSString *initWorkName;
    __block NSString *workflag;
    
    NSString *birthdayflag;
    UIAlertController *alert;
    UIDatePicker *datePicker;
    NSString *birthdayString;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor = _viewColor;

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
  
    NSLog(@"viewWillAppear");
    /*个人信息表格初始化*/
    _personalInfoTable.delegate=self;
    _personalInfoTable.dataSource=self;
    _personalInfoTable.scrollEnabled=NO;
    /*数据源初始化*/
    dataSource = @[@"头像", @"昵称", @"修改密码", @"生日", @"性别", @"职业", @"家庭住址是否公开"];
    switchFamliyAddressButton = [[UISwitch alloc] initWithFrame:CGRectMake(_personalInfoTable.frame.size.width-70, 10, 40, 5)];
    [switchFamliyAddressButton setOn:YES];
    [switchFamliyAddressButton addTarget:self action:@selector(showFamliyAddressAction) forControlEvents:UIControlEventValueChanged];
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([self.personalInfoTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.personalInfoTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.personalInfoTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.personalInfoTable setLayoutMargins:UIEdgeInsetsZero];
    }
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     self.navigationItem.title=@"";
    /*图片设置*/
    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(_personalInfoTable.frame.size.width-80, 20, 40, 40)];
    imageView.image = [UIImage imageNamed:@"account.png"];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction:)];
    [imageView addGestureRecognizer:tapGesture];
    /*页面跳转*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    NickNameController=[storyBoard instantiateViewControllerWithIdentifier:@"nicknamecontroller"];
    ModifyPasswordController=[storyBoard instantiateViewControllerWithIdentifier:@"modifypasswordcontroller"];
    ChooseSexTypeController=[storyBoard instantiateViewControllerWithIdentifier:@"choosesextypecontroller"];
    ProfessionSettingController=[storyBoard instantiateViewControllerWithIdentifier:@"professionsettingcontroller"];
    
    self.navigationController.delegate=self;
    /*获取返回的昵称*/
    [NickNameController returnText:^(NSString *showText) {
        NSLog(@"showText is %@",showText);
        if([showText isEqualToString:nicknameLabel.text])
        {
            
            nickflag=@"yes";
        }else{
            
            nickflag=@"no";
            initNikeName = showText;
        }
        
    }];
    /*获取返回的性别*/
    [ChooseSexTypeController returnText:^(NSString *showText) {
        NSLog(@"showText is %@",showText);
        if([showText isEqualToString:nicknameLabel.text])
        {
            
            sexflag=@"yes";
        }else{
            
            sexflag=@"no";
            initSexName = showText;
            [_personalInfoTable reloadData];
        }
        
    }];
    /*获取返回的职业*/
    [ProfessionSettingController returnText:^(NSString *showText) {
        NSLog(@"showText is %@",showText);
        if([showText isEqualToString:professionLabel.text])
        {
            
            workflag=@"yes";
        }else{
            
            workflag=@"no";
            initWorkName = showText;
            [_personalInfoTable reloadData];
        }
        
    }];


    /*生日信息初始化*/
    datePicker = [[UIDatePicker alloc] init];
    UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(0, 38, 270, 0.6)];
    dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 15, 270, 20)];
    line.layer.borderColor=[UIColor blackColor].CGColor;
    line.backgroundColor=[UIColor lightGrayColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame=CGRectMake(0,40, 270, 200);
     NSString *dateString=[self setInitDate:datePicker.date];
    dateLabel.text=dateString;
    dateLabel.font=[UIFont systemFontOfSize:17];
    dateLabel.tag=2017;
    [datePicker addTarget:self
                          action:@selector(datePickerDateChanged)
                forControlEvents:UIControlEventValueChanged];
    alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.view.tintColor = [UIColor blackColor];
    
    [alert.view addSubview:dateLabel];
    [alert.view addSubview:datePicker];
    [alert.view addSubview:line];
    
     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy年MM月dd日"];//设定时间格式
         birthdayString = [dateFormat stringFromDate:datePicker.date];
        //求出当天的时间字符串
         NSLog(@"%@",birthdayString);
         NSDate * now = [NSDate date];
         NSComparisonResult result = [now compare:datePicker.date];
         if(result==NSOrderedAscending){
         
             [self textToast:@"生日日期不合理"];
              birthdayflag=@"YES";
             
         }else{
              birthdayflag=@"NO";
             [_personalInfoTable reloadData];
         }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { }];
    [cancel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [ok setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    
}

-(void)datePickerDateChanged{

    NSString *text=[self weekdayStringFromDate:datePicker.date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:datePicker.date];
    long year = [dateComponent year];
    long month = [dateComponent month];
    long day = [dateComponent day];
    NSString *string1 = [NSString stringWithFormat:@"%ld%@%ld%@%ld%@%@", year,@"年",month,@"月",day,@"日",text ];
    [(UILabel *)[self.view viewWithTag:2017] removeFromSuperview];
     dateLabel.text=string1;
    [alert.view addSubview:dateLabel];
}

- (NSString*)setInitDate:(NSDate *) nowDate{


    NSString *text=[self weekdayStringFromDate:nowDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:datePicker.date];
    
    long year = [dateComponent year];
    long month = [dateComponent month];
    long day = [dateComponent day];
    NSString *dateString = [NSString stringWithFormat:@"%ld%@%ld%@%ld%@%@", year,@"年",month,@"月",day,@"日",text ];

    return dateString;

}
- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated{
    if([[viewController class]isSubclassOfClass:[self class]]) {
        ///执行刷新操作
        
          [_personalInfoTable reloadData];
           NSLog(@"执行刷新");
         }
        ///删除代理，防止该controller销毁后引起
    if(![[viewController class]isSubclassOfClass:[self class]]) {
        
        self.navigationController.delegate=nil;
    }
    
}




- (void) headTapAction: (UITapGestureRecognizer*) recognizer
{
    [self showCircularImageViewWithImage:imageView.image];
}

-(void)showFamliyAddressAction{

    NSLog(@"展示地址");

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
            elementOfSection = 5;
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
    /*信息初始化*/
    if(initSexName==NULL)
    {
        initSexName=@"男";
        
    }
    if(initNikeName==NULL)
    {
        
        initNikeName=@"大神";
    }
    if(initWorkName==NULL)
    {
    
        initWorkName=@"";
    }
    /*性别*/
    sexLabel =[[UILabel alloc]initWithFrame:CGRectMake(_personalInfoTable.frame.size.width-70, 15, 70, 15)];
    sexLabel.tag=1126;
    sexLabel.text=initSexName;
    
    /*生日*/
    birthdayLabel=[[UILabel alloc]initWithFrame:CGRectMake(_personalInfoTable.frame.size.width-160, 15, 150, 15)];
    birthdayLabel.text=@"1970年01月01日";
    birthdayLabel.tag=1988;
    
    /*昵称*/
    nicknameLabel=[[UILabel alloc] init];
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    nicknameLabel.font = fnt;
    nicknameLabel.text = initNikeName;
    CGSize size = [nicknameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    nicknameLabel.frame=CGRectMake(_personalInfoTable.frame.size.width-size.width-40, 15, size.width, 20);
    nicknameLabel.tag=2016;
    
    /*职业*/
    professionLabel=[[UILabel alloc] init];
    professionLabel.font = fnt;
    professionLabel.text = initWorkName;
    CGSize professionSize = [professionLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    professionLabel.frame=CGRectMake(_personalInfoTable.frame.size.width-professionSize.width-40, 15, professionSize.width, 20);
    professionLabel.tag=614;
    
    
    
    static NSString *CellIdentifier = @"infoid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        if(section == 0)
        {
            if(rowNo == 0)
            {
                
                [cell.contentView addSubview:imageView];
            }
            else if(rowNo == 1)
            {
                
                //NSLog(@"调用昵称 %@",nicknameLabel.text);
                [cell.contentView addSubview:nicknameLabel];
                
            }
            
            cell.textLabel.text = dataSource[rowNo];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        else if(section == 1)
        {
            if(rowNo == 0)
            {
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if(rowNo == 1)
            {
                
                [cell.contentView addSubview:birthdayLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }else if(rowNo==2){
                
                [cell.contentView addSubview:sexLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }else if(rowNo==3){
                
                [cell.contentView addSubview:professionLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }else if(rowNo==4){
                
                [cell.contentView addSubview:switchFamliyAddressButton];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = dataSource[rowNo+2];
            
        }
        else
        {
            NSLog(@"cellForRowAtIndexPath section = %ld",section);
        }
    }
    
    /*更新昵称*/
    if(section == 0&&rowNo == 1&&[nickflag isEqualToString:@"no"])
    {

        [(UILabel *)[self.view viewWithTag:2016] removeFromSuperview];
        nicknameLabel.text=initNikeName;
        [cell.contentView addSubview:nicknameLabel];
    }
    /*更新生日*/
    if(section == 1&&rowNo == 1&&[birthdayflag isEqualToString:@"NO"])
    {
    
        [(UILabel *)[self.view viewWithTag:1988] removeFromSuperview];
        birthdayLabel.text=birthdayString;
        [cell.contentView addSubview:birthdayLabel];
    }
      /*更新性别*/
    if(section == 1&&rowNo == 2&&[sexflag isEqualToString:@"no"])
    {
        
        [(UILabel *)[self.view viewWithTag:1126] removeFromSuperview];
        sexLabel.text=initSexName;
        [cell.contentView addSubview:sexLabel];
    }
    /*更新工作*/
    if(section == 1&&rowNo == 3&&[workflag isEqualToString:@"no"])
    {
        
        [(UILabel *)[self.view viewWithTag:614] removeFromSuperview];
        professionLabel.text=initWorkName;
        [cell.contentView addSubview:professionLabel];
    }

        return cell;
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
        return 80;
    }
    else
        return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowInSection = indexPath.row;
    NSInteger section = indexPath.section;
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"section %ld  rowInSection %ld" ,section,rowInSection);
    switch (section) {
        case 0:
        {
            NSLog(@"SECTION 0");
            switch (rowInSection) {
                case 0:
                {
                    UpdatePhotoView *view = [UpdatePhotoView defaultPopupView];
                    view.parentVC = self;
                    view.alpha=1.0;
                    view.backgroundColor=[UIColor clearColor];
                    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDownSlide new] dismissed:^{
                        //[self.otherTableView reloadData];
                        
                        NSLog(@"动画结束");
                    }];

                    break;
                }
                case 1:
                {
                    // 昵称
                    NickNameController.nikeNameValue=nicknameLabel.text;
                    NSLog(@"NickNameController.nikeNameValue is %@",nicknameLabel.text);
                    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"昵称" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:backItemTitle];
                    [self.navigationController pushViewController:NickNameController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;

        }
        case 1:
        {
            switch (rowInSection) {
                case 0:
                {
                    // 修改密码
                    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"修改密码" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:backItemTitle];
                    [self.navigationController pushViewController:ModifyPasswordController animated:YES];
                    break;
                }
                case 1:
                {
          
                    [self presentViewController:alert animated:YES completion:^{ }];
                    break;
                }
                case 2:
                {
                    // 性别
                    ChooseSexTypeController.sexValue=sexLabel.text;
                    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"性别" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:backItemTitle];
                    [self.navigationController pushViewController:ChooseSexTypeController animated:YES];
                    break;
                }
                case 3:
                {
                    // 职业
                    ProfessionSettingController.workerValue=professionLabel.text;
                    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"职业" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:backItemTitle];
                    [self.navigationController pushViewController:ProfessionSettingController animated:YES];
                    break;
                }
                case 4:
                {
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 圆形头像点击事件回调
- (void)showCircularImageViewWithImage:(UIImage*) image
{
    
    //    UIView* addView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView* addView = [[UIView alloc] initWithFrame:self.parentViewController.view.bounds];
    addView.alpha = 1.0;
    addView.backgroundColor = [UIColor whiteColor];
    [self.parentViewController.view addSubview:addView];
    
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


- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
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

@end
