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
#import "StringMD5.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"
#import "AppDelegate.h"
#import "SqliteOperation.h"
@interface PersonalInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@end

@implementation PersonalInformationViewController{

    UIColor *_viewColor;
    UIBarButtonItem *backItemTitle;
    UILabel *dateLabel;
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
    NSInteger addressStatusInt;
    UIImage *headPhoto;
    NSTimer *timer;
    //NSString *statusValue;
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
    _switchFamliyAddressButton = [[UISwitch alloc] initWithFrame:CGRectMake(_personalInfoTable.frame.size.width-70, 10, 40, 5)];
    [_switchFamliyAddressButton addTarget:self action:@selector(showFamliyAddressAction:) forControlEvents:UIControlEventValueChanged];
    
    /*初始化地址发布状态*/
    //[self obtainPublicStateInit];
    NSLog(@"family_statusValue is %@",_statusValue);
    addressStatusInt=[_statusValue intValue];
    if([_statusValue isEqualToString:@"2"]||[_statusValue isEqualToString:@"4"])
    {
         NSLog(@"abc");
        [_switchFamliyAddressButton setOn:YES];
    }else{
         NSLog(@"def");
        [_switchFamliyAddressButton setOn:NO];
    }
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
    _imageView.frame = CGRectMake(_personalInfoTable.frame.size.width-100, 10, 60, 60);
    _imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction:)];
    [_imageView addGestureRecognizer:tapGesture];
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
        if([showText isEqualToString:_nicknameLabel.text])
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
        if([showText isEqualToString:_nicknameLabel.text])
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
        //[self obtainPublicStateInit];
        if([showText isEqualToString:_professionLabel.text])
        {
            
            workflag=@"yes";
        }else{
            
            workflag=@"no";
            initWorkName = showText;
            [_personalInfoTable reloadData];
        }
        
    }];
   /*返回职业显示状态*/
    [ProfessionSettingController returnShow:^(NSString *showVal) {
        NSLog(@"showVal is %@",showVal);
        //[self obtainPublicStateInit];
        if(![showVal isEqualToString:_statusValue])
        {
            _statusValue = showVal;
            
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
             NSDate* inputDate = [dateFormat dateFromString:birthdayString];
             NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[inputDate timeIntervalSince1970]*1000];
              birthdayflag=@"NO";
              //更新服务器中用户的生日
             NSLog(@"timeSp is %@",timeSp);
             [self changeUserBirthDay:timeSp];
             [_personalInfoTable reloadData];
         }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { }];
    [cancel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [ok setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alert addAction:cancel];
    [alert addAction:ok];

    
}
/*改变用户的生日*/
-(void)changeUserBirthDay:(NSString*)timeStr{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%@user_birthday%@",phoneNum,userId,timeStr]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@813",hashString]];
    NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                @"user_id" : userId,
                                @"user_birthday":timeStr,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"upload",
                                @"salt" : @"813",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_phone_number:user_id:user_birthday:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"tiemresponseObject equal %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];
    
}
/*获取初始公布状态*/
-(void)obtainPublicStateInit{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone%@user_id%@",phoneNum,userId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@810",hashString]];
    NSDictionary* parameter = @{@"user_phone" : phoneNum,
                                @"user_id" : userId,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"getstatus",
                                @"salt" : @"810",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_phone:user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject equal %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            _statusValue=[[responseObject objectForKey:@"status"] stringValue];

        }else{
            
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];
    
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
    [self showCircularImageViewWithImage:_imageView.image];
}

-(void)showFamliyAddressAction:(UISwitch *)sw{
    
    if(sw.isOn)
    {
        addressStatusInt=addressStatusInt+1;
        
    }else{
        
        addressStatusInt=addressStatusInt-1;
    }
    NSLog(@"addressStatusInt is %ld",addressStatusInt);
       [self changeAddressShow];
       _statusValue=[NSString stringWithFormat:@"%ld",addressStatusInt];
   
    
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
        initSexName=@"";
        
    }
    if(initNikeName==NULL)
    {
        
        initNikeName=@"";
    }
    if(initWorkName==NULL)
    {
    
        initWorkName=@"";
    }
    /*性别*/
    _sexLabel.frame=CGRectMake(_personalInfoTable.frame.size.width-70, 15, 70, 15);
    _sexLabel.tag=1126;
    
    /*生日*/
    _birthdayLabel.frame=CGRectMake(_personalInfoTable.frame.size.width-160, 15, 150, 15);
    _birthdayLabel.tag=1988;
    
    /*昵称*/
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    _nicknameLabel.font = fnt;
    CGSize size = [_nicknameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    _nicknameLabel.frame=CGRectMake(_personalInfoTable.frame.size.width-size.width-40, 15, size.width, 20);
    _nicknameLabel.tag=2016;
    
    /*职业*/
    _professionLabel.font = fnt;
    CGSize professionSize = [_professionLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    _professionLabel.frame=CGRectMake(_personalInfoTable.frame.size.width-professionSize.width-40, 15, professionSize.width, 20);
    _professionLabel.tag=614;
    
    
    
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
                //_imageView.center=CGPointMake(cell.frame.size.width-10, cell.frame.size.height/2-10);
                [cell.contentView addSubview:_imageView];
            }
            else if(rowNo == 1)
            {
                
                //NSLog(@"调用昵称 %@",nicknameLabel.text);
                [cell.contentView addSubview:_nicknameLabel];
                
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
                
                [cell.contentView addSubview:_birthdayLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }else if(rowNo==2){
                
                [cell.contentView addSubview:_sexLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }else if(rowNo==3){
                
                [cell.contentView addSubview:_professionLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }else if(rowNo==4){
                
                [cell.contentView addSubview:_switchFamliyAddressButton];
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
        _nicknameLabel.text=initNikeName;
        [cell.contentView addSubview:_nicknameLabel];
    }
    /*更新生日*/
    if(section == 1&&rowNo == 1&&[birthdayflag isEqualToString:@"NO"])
    {
    
        [(UILabel *)[self.view viewWithTag:1988] removeFromSuperview];
        _birthdayLabel.text=birthdayString;
        [cell.contentView addSubview:_birthdayLabel];
    }
      /*更新性别*/
    if(section == 1&&rowNo == 2&&[sexflag isEqualToString:@"no"])
    {
        
        [(UILabel *)[self.view viewWithTag:1126] removeFromSuperview];
        _sexLabel.text=initSexName;
        [cell.contentView addSubview:_sexLabel];
    }
    /*更新工作*/
    if(section == 1&&rowNo == 3&&[workflag isEqualToString:@"no"])
    {
        
        [(UILabel *)[self.view viewWithTag:614] removeFromSuperview];
        _professionLabel.text=initWorkName;
        [cell.contentView addSubview:_professionLabel];
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
    NSLog(@"section %ld  rowInSection %ld" ,section,rowInSection);
    switch (section) {
        case 0:
        {
            NSLog(@"SECTION 0");
            switch (rowInSection) {
                case 0:
                {
//                    UpdatePhotoView *view = [UpdatePhotoView defaultPopupView];
//                    view.parentVC = self;
//                    view.alpha=1.0;
//                    view.backgroundColor=[UIColor clearColor];
//                    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDownSlide new] dismissed:^{
//                        //[self.otherTableView reloadData];
//                        
//                        NSLog(@"动画结束");
//                    }];
                    
                    UIAlertController *photoAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    
                    [photoAlert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //点击按钮的响应事件；
                        
                        if (![UIImagePickerController isSourceTypeAvailable:
                              UIImagePickerControllerSourceTypeCamera]) return;
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
                        picker.delegate = self;
                        picker.allowsEditing = YES;//设置可编辑  
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                       [self presentViewController:picker animated:YES completion:nil];//进入照相界面
                        NSLog(@"点击了相机");
                    }]];
                    
                    [photoAlert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //点击按钮的响应事件；
                        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
                        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                            
                        }  
                        pickerImage.delegate = self;  
                        pickerImage.allowsEditing = YES;
                        [self  presentViewController:pickerImage animated:YES completion:nil];
                        NSLog(@"点击了相册");
                    }]];
                    
                    [photoAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                        NSLog(@"点击了取消");
                    }]];
                    
                    //弹出提示框；
                    [self presentViewController:photoAlert animated:true completion:nil];
                    break;
                }
                case 1:
                {
                    // 昵称
                    NickNameController.nikeNameValue=_nicknameLabel.text;
                    NSLog(@"NickNameController.nikeNameValue is %@",_nicknameLabel.text);
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
                    ChooseSexTypeController.sexValue=_sexLabel.text;
                    backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"性别" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:backItemTitle];
                    [self.navigationController pushViewController:ChooseSexTypeController animated:YES];
                    break;
                }
                case 3:
                {
                    // 职业
                    NSLog(@"statusValue is %@",_statusValue);
                    ProfessionSettingController.workerValue=_professionLabel.text;
                    ProfessionSettingController.statusState=_statusValue;
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
#pragma mark -
#pragma UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    if (![type isEqualToString:(NSString*)kUTTypeImage])
    {
     [self dismissViewControllerAnimated:YES completion:nil];
      return;
    }
    //从字典key获取image的地址
    UIImage *image =[info objectForKey:UIImagePickerControllerEditedImage];
   [self performSelector:@selector(saveImage:)  withObject:image afterDelay:0.5];
   [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveImage:(UIImage *)image {

    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    
    
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];
     UIImage *smallImage = [self imageCompressForSize:image targetSize:CGSizeMake(60, 60)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];
     //_imageView.image=NULL;
     UIImage* newHeadPhoto = [UIImage imageWithContentsOfFile:imageFilePath];
     _imageView.image=newHeadPhoto;
    [_imageView.layer setCornerRadius:CGRectGetHeight([_imageView bounds]) / 2];
     _imageView.layer.masksToBounds = YES;
     NSData *imgData= UIImageJPEGRepresentation(smallImage, 1.0f);
    [self changeUserHeadPhoto:imgData];
}
/*改变用户头像*/
-(void)changeUserHeadPhoto:(NSData*)headImgData{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%@",phoneNum,userId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@818",hashString]];
    NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                @"user_id" : userId,
                                @"deviceType" : @"ios",
                                @"apitype" : @"users",
                                @"tag" : @"upload",
                                @"salt" : @"818",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_phone_number:user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)  {
        
        [formData appendPartWithFileData:headImgData name:@"user_portrait" fileName:@"selfPhoto.jpg" mimeType:@"image/jpg"];
        
    }progress:^(NSProgress * _Nonnull uploadProgress) {
    
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"headresponseObject is %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            
            NSLog(@"head success");
            [self userHeadPhotoUpdate];
            
        }else{
            
            
            NSLog(@"head error");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];

}
/*获取头像信息*/
-(void)userHeadPhotoUpdate{

        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
        [manager.securityPolicy setValidatesDomainName:NO];
    
        NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
        NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"my_user_id%@user_id%@",userId,userId]];
        NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@812",hashString]];
        NSDictionary* parameter = @{@"my_user_id" : userId,
                                    @"user_id" : userId,
                                    @"deviceType":@"ios",
                                    @"apitype" : @"users",
                                    @"tag" : @"userdetailinfo",
                                    @"salt" : @"812",
                                    @"hash" : hashMD5,
                                    @"keyset" : @"my_user_id:user_id:",
                                    };
    
        [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            NSLog(@"userresponseObject is %@",responseObject);
            [SqliteOperation updateUserPhotoInfo:[userId longLongValue] photoUrl:[responseObject objectForKey:@"user_portrait"]];
            return;
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@", [error localizedDescription]);
        }];

}
/*改变图像的尺寸，方便上传服务器*/
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){

        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            
            scaleFactor = widthFactor;
            
        }else{
            
            scaleFactor = heightFactor;
            
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        
        NSLog(@"scale image fail");
        
    }
    UIGraphicsEndImageContext();
    return newImage;
}

/*保持原来的长宽比，生成一个缩略图*/
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
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
-(void)changeAddressShow{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* statusStr=[NSString stringWithFormat:@"%ld",addressStatusInt];
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
        
        NSLog(@"addressShowresponseObject is %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    
}

- (void)submitUpdatePhotoInfo:(NSData*)headImgData
{
    dispatch_queue_t queue = dispatch_queue_create("**.test.youlin", DISPATCH_QUEUE_CONCURRENT);
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    dispatch_async(queue, ^{
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
        [manager.securityPolicy setValidatesDomainName:NO];
        NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_id%@",phoneNum,userId]];
        NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@818",hashString]];
        NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                    @"user_id" : userId,
                                    @"deviceType" : @"ios",
                                    @"apitype" : @"users",
                                    @"tag" : @"upload",
                                    @"salt" : @"818",
                                    @"hash" : hashMD5,
                                    @"keyset" : @"user_phone_number:user_id:",
                                    };
        
        [manager POST:POST_URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)  {
            
            [formData appendPartWithFileData:headImgData name:@"user_portrait" fileName:@"selfPhoto.jpg" mimeType:@"image/jpg"];
            
        }progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSLog(@"headresponseObject is %@",responseObject);
                  if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
                  {
                      
                      NSLog(@"head success");
                      
                  }else{
                      
                      
                      NSLog(@"head error");
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  NSLog(@"%@", [error localizedDescription]);
              }];
        
    });

    dispatch_barrier_async(queue, ^{
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
        [manager.securityPolicy setValidatesDomainName:NO];
        NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"my_user_id%@user_id%@",userId,userId]];
        NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@812",hashString]];
        NSDictionary* parameter = @{@"my_user_id" : userId,
                                    @"user_id" : userId,
                                    @"deviceType":@"ios",
                                    @"apitype" : @"users",
                                    @"tag" : @"userdetailinfo",
                                    @"salt" : @"812",
                                    @"hash" : hashMD5,
                                    @"keyset" : @"my_user_id:user_id:",
                                    };
        
        [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"userresponseObject is %@",responseObject);
            [SqliteOperation updateUserPhotoInfo:[userId longLongValue] photoUrl:[responseObject objectForKey:@"user_portrait"]];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@", [error localizedDescription]);
          
        }];
    
    });
    
    
}

@end
