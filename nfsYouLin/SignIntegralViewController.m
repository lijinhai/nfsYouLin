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

@interface SignIntegralViewController ()

@end

@implementation SignIntegralViewController{

    NSString *signFlag;
    UIImage *signedImage;

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
    self.navigationItem.title=@"";
    /*签到点击事件*/
    signedImage = [UIImage imageNamed:@"btn_qiandao_c"];//已签到
    [_pleaseSignImage setUserInteractionEnabled:YES];
     _pleaseSignImage.tag = 1;
    [_pleaseSignImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSignImage:)]];
    if(signFlag!=NULL)
    {
    
        _pleaseSignImage.image=signedImage;
    
    }
    /*设置周label日期*/
    NSMutableArray *weekDateArray=[self getWeekTime];
    self.MONLabel.text=[weekDateArray objectAtIndex:0];
    self.MONLabel.tag=0;
    
    self.TUELabel.text=[weekDateArray objectAtIndex:1];
    self.TUELabel.tag=1;
    
    self.WEDLabel.text=[weekDateArray objectAtIndex:2];
    self.WEDLabel.tag=2;
    
    self.THULabel.text=[weekDateArray objectAtIndex:3];
    self.THULabel.tag=3;
    
    self.FRILabel.text=[weekDateArray objectAtIndex:4];
    self.FRILabel.tag=4;
    
    self.SATLabel.text=[weekDateArray objectAtIndex:5];
    self.SATLabel.tag=5;
    
    self.SUNLabel.text=[weekDateArray objectAtIndex:6];
    self.SUNLabel.tag=6;
   /*设置周签到标示*/
    if([self.nowWeekSignedArray count]!=0)
    {
        for(int i=0;i<[weekDateArray count];i++){
        
           if([self checkWeekSignedDay:[weekDateArray objectAtIndex:i]])
           {
               UIView *layerView=[[UIView alloc] initWithFrame:CGRectMake(17.5+59*i, 286,24, 24)];
               UIImageView *picView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_dian2"]];
               picView.frame=CGRectMake(0, 0,24, 24);
               [layerView addSubview:picView];
               [self.view addSubview:layerView];
           
           }else{
           
               
               continue;
           
           }
        
        
        }
    
    }
    
}

- (void)clickSignImage:(UITapGestureRecognizer *)sender{

    //NSLog(@"点击更换");
    UIImage *signedWhite =  [UIImage imageNamed:@"pic_dian2"];
    UIImageView *signedWhiteView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    signedWhiteView.image=signedWhite;
    NSLog(@"%ld", sender.view.tag);
    if(signFlag==NULL)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:[NSDate date]];
        NSInteger weekDay = [comp weekday];
        NSLog(@"weekDay is %ld",weekDay);
        UIView *layerView=[[UIView alloc] init];
        if(weekDay!=1)
        {
            layerView.frame=CGRectMake(17.5+59*(weekDay-2), 286,24, 24);
        }else{
        
            layerView.frame=CGRectMake(17.5+59*6, 286,24, 24);
        
        }
        UIImageView *picView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_dian2"]];
        picView.frame=CGRectMake(0, 0,24, 24);
        [layerView addSubview:picView];
        [self.view addSubview:layerView];
        _pleaseSignImage.image = signedImage;
        signFlag=@"signed";
    }
    else
    {
        
        NSInteger points=3;//今天签到所得分数
        PopupCalendarView *view = [PopupCalendarView defaultPopupView:points tFrame:CGRectMake(0, 0, 365, 375)];
        view.parentVC = self;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
            NSLog(@"动画结束");
        }];
    }

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


@end