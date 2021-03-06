//
//  SignIntegralViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "SignIntegralViewController.h"
#import "LewPopupViewController.h"
#import "PopupCalendarView.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "SqliteOperation.h"

@interface SignIntegralViewController ()

@end

@implementation SignIntegralViewController{

    NSString *signFlag;
    UIImage *signedImage;
    float rectW;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
   
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    self.navigationItem.title=@"";
    _dateRulerImageView.frame = CGRectMake(30, 288, screenWidth-60, 20);
    NSLog(@"screenWidth-40 is %f",screenWidth-40);
    _pleaseSignImage.frame = CGRectMake(screenWidth/2-55, 90, 110, 110);
    _myPointsNameLab.frame = CGRectMake(screenWidth/2-48, CGRectGetMaxY(_pleaseSignImage.frame)+35, 90, 20);
    _pointsLabel.frame = CGRectMake(screenWidth/2+41, CGRectGetMaxY(_pleaseSignImage.frame)+35, 100, 20);
    _pointsLabel.font = [UIFont boldSystemFontOfSize:17.5f];
    _pointsLabel.text=[NSString stringWithFormat:@"%ld",_allPoints];
    /*设置周label日期*/
    _weekDateArray=[self getWeekTime];
    rectW = CGRectGetWidth(_dateRulerImageView.frame);
    self.MONLabel.frame = CGRectMake(28, 310, 39, 21);
    self.MONLabel.textAlignment = NSTextAlignmentLeft;
    self.MONLabel.text = [_weekDateArray objectAtIndex:0];
    self.MONLabel.tag=0;
    
    self.TUELabel.frame = CGRectMake(25+rectW/6, 310, 39, 21);
    self.TUELabel.text=[_weekDateArray objectAtIndex:1];
    self.TUELabel.textAlignment = NSTextAlignmentLeft;
    self.TUELabel.tag=1;
    
    self.WEDLabel.frame = CGRectMake(22+rectW/6*2, 310, 39, 21);
    self.WEDLabel.textAlignment = NSTextAlignmentLeft;
    self.WEDLabel.text=[_weekDateArray objectAtIndex:2];
    self.WEDLabel.tag=2;
    
    self.THULabel.frame = CGRectMake(19+rectW/6*3, 310, 39, 21);
    self.THULabel.textAlignment = NSTextAlignmentLeft;
    self.THULabel.text=[_weekDateArray objectAtIndex:3];
    self.THULabel.tag=3;
    
    self.FRILabel.frame = CGRectMake(16+rectW/6*4, 310, 39, 21);
    self.FRILabel.textAlignment = NSTextAlignmentLeft;
    self.FRILabel.text=[_weekDateArray objectAtIndex:4];
    self.FRILabel.tag=4;
    
    self.SATLabel.frame = CGRectMake(13+rectW/6*5, 310, 39, 21);
    self.SATLabel.textAlignment = NSTextAlignmentLeft;
    self.SATLabel.text=[_weekDateArray objectAtIndex:5];
    self.SATLabel.tag=5;
    
    self.SUNLabel.frame = CGRectMake(10+rectW/6*6, 310, 39, 21);
    self.SUNLabel.textAlignment = NSTextAlignmentLeft;
    self.SUNLabel.text=[_weekDateArray objectAtIndex:6];
    self.SUNLabel.tag=6;
   /*设置周签到标示*/
    if([self.nowWeekSignedArray count]!=0)
    {
        for(int i=0;i<[_weekDateArray count];i++){
        
           if([self checkWeekSignedDay:[_weekDateArray objectAtIndex:i]])
           {
               UIView *layerView=[[UIView alloc] initWithFrame:CGRectMake(27-i*3+rectW/6*i, 286,24, 24)];
               UIImageView *picView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_dian2"]];
               picView.frame=CGRectMake(0, 0,24, 24);
               [layerView addSubview:picView];
               [self.view addSubview:layerView];
           
           }else{
           
               
               continue;
           
           }
        
        
        }
        
    }
    /*签到积分说明*/
    _signedTitleLab.frame = CGRectMake(screenWidth/2-60, CGRectGetMaxY(_bg.frame)+20, 120, 30);
    _signedTitleLab.textAlignment = NSTextAlignmentLeft;
    
    _oneTipLabel.frame = CGRectMake(15, CGRectGetMaxY(_signedTitleLab.frame)+15, screenWidth-20, 25);
    _oneTipLabel.textAlignment = NSTextAlignmentLeft;
    _oneTipLabel.numberOfLines = 0;
    
    _twoTipLabel.frame = CGRectMake(15, CGRectGetMaxY(_oneTipLabel.frame)+10, screenWidth-30, 25);
    _twoTipLabel.textAlignment = NSTextAlignmentLeft;
    _twoTipLabel.numberOfLines = 0;
    
    _threeTipLabel.frame = CGRectMake(15, CGRectGetMaxY(_twoTipLabel.frame)+10, screenWidth-30, 50);
    _threeTipLabel.textAlignment = NSTextAlignmentLeft;
    _threeTipLabel.numberOfLines = 0;
    
    
    /*签到点击事件*/
    
    [_pleaseSignImage setUserInteractionEnabled:YES];
    _pleaseSignImage.tag = 1;
    [_pleaseSignImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSignImage:)]];
    NSLog(@"%@",[NSString stringWithFormat:@"%ld",[self day:[NSDate date]]]);
    if([self checkWeekSignedDay: [self setMonthAndDayStr]])
    {
        signedImage = [UIImage imageNamed:@"btn_qiandao_c"];//已签到
        _pleaseSignImage.image=signedImage;
        signFlag=@"signed";
    }else{
        
        signedImage = [UIImage imageNamed:@"btn_qiandao_a"];//请签到
        _pleaseSignImage.image=signedImage;
        signFlag=NULL;
    }

    [self.nowWeekSignedArray removeAllObjects];
}

- (void)clickSignImage:(UITapGestureRecognizer *)sender{

    //NSLog(@"点击更换");
    UIImage *signedWhite =  [UIImage imageNamed:@"pic_dian2"];
    UIImageView *signedWhiteView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    signedWhiteView.image=signedWhite;
    if(signFlag==NULL)
    {
        [self userTodaySign];
        NSInteger nowAllPoints=0;
        //nowAllPoints=_todayPoints+_allPoints;
        //_pointsLabel.text=[NSString stringWithFormat:@"%ld",nowAllPoints];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:[NSDate date]];
        NSInteger weekDay = [comp weekday];
        //NSLog(@"weekDay is %ld",weekDay);
        UIView *layerView=[[UIView alloc] init];
        if(weekDay!=1)
        {
            layerView.frame=CGRectMake(27-(weekDay-2)*3+rectW/6*(weekDay-2), 286,24, 24);
        }else{
        
            layerView.frame=CGRectMake(10+rectW/6*6, 286,24, 24);
        
        }
        UIImageView *picView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_dian2"]];
        picView.frame=CGRectMake(0, 0,24, 24);
        [layerView addSubview:picView];
        [self.view addSubview:layerView];
        signedImage = [UIImage imageNamed:@"btn_qiandao_c"];
        _pleaseSignImage.image = signedImage;
        
    }
    else
    {
        [self signTodayIntegral];
//        NSInteger points=_todayPoints;//今天签到所得分数
//        NSLog(@"points is %ld",points);
//        PopupCalendarView *view = [PopupCalendarView defaultPopupView:points tFrame:CGRectMake(0, 0, 365, 375) signArray:self.monthSignedArray];
//        view.parentVC = self;
//        //NSLog(@"self.monthSignedArray is %ld",[self.monthSignedArray count]);
//        [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
//            NSLog(@"动画结束");
//        }];
    }

}
/*MM.dd/M.dd字符串*/
-(NSString*)setMonthAndDayStr{

    NSDate *nowdate=[NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if([self month:nowdate] <10){
        
        [formatter setDateFormat:@"M.dd"];
    }else{
        
        [formatter setDateFormat:@"MM.dd"];
    }
     NSString *dateString=[formatter stringFromDate:nowdate];


    return dateString;

}

/*用户签到*/
-(void)userTodaySign{

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
                                @"tag" : @"usersign",
                                @"salt" : @"729",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"signresponseObject is %@",responseObject);
        _pointsLabel.text=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"credit"]];
        signFlag=@"signed";
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
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



-(BOOL)checkWeekSignedDay:(NSString *)day
{
    for(int i=0;i<[self.nowWeekSignedArray count];i++)
    {
      if([day isEqualToString:[self.nowWeekSignedArray objectAtIndex:i]])
          {
              return YES;
              break;
          }else{
          
              continue;
          }
    }
          return NO;
}

-(void)signTodayIntegral{
    
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
        

        NSMutableArray *responseObjectAry=[responseObject objectForKey:@"info"];
        _todayPoints=[[responseObjectAry objectAtIndex:0][@"credit"] intValue];
        NSInteger points=_todayPoints;//今天签到所得分数
        NSLog(@"points is %ld",points);
        PopupCalendarView *view = [PopupCalendarView defaultPopupView:points tFrame:CGRectMake(0, 0, screenWidth-40, (screenWidth-40)/0.94) signArray:self.monthSignedArray];
        NSLog(@"宽 高 比 = %f",(screenWidth-40)/375);
        view.parentVC = self;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
            NSLog(@"动画结束");
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end
