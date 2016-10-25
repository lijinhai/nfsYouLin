//
//  PropertyVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/18.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PropertyVC.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "MyAdviceTVC.h"
#import "RepairVC.h"
#import "AdministratorRTVC.h"
#import "SqliteOperation.h"

@interface PropertyVC ()

@end

@implementation PropertyVC{

    NSMutableDictionary* propertyObj;
    UILabel *phoneVL;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkPropertyInfoAct];
        // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor=BackgroundColor;


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkPropertyInfoAct{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* commId=[defaults stringForKey:@"communityId"];
    
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"community_id%@",commId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1024",hashString]];
    
    NSDictionary* parameter = @{@"community_id" : commId,
                                @"deviceType":@"ios",
                                @"apitype" : @"apiproperty",
                                @"tag" : @"getproperty",
                                @"salt" : @"1024",
                                @"hash" : hashMD5,
                                @"keyset" : @"community_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"property_responseObject is %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            NSLog(@"address is %@",[responseObject valueForKey:@"address"]);
            
            UIView *upBackV = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2, 15, screenWidth-40, screenHeight/3)];
            upBackV.layer.cornerRadius = 4.0;
            upBackV.backgroundColor = [UIColor whiteColor];
            upBackV.center = CGPointMake(screenWidth/2, screenHeight/4+20);
            upBackV.layer.shadowColor = [UIColor blackColor].CGColor;
            upBackV.layer.shadowOffset = CGSizeMake(0.7,1);
            upBackV.layer.shadowOpacity = 0.5;
            upBackV.layer.shadowRadius = 1;
            
            
            UIImageView *propertyIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2, 15, 60, 60)];
            propertyIV.image = [UIImage imageNamed:@"pic_wuye"];
            propertyIV.center = CGPointMake(upBackV.frame.size.width/2, 50);
            [upBackV addSubview:propertyIV];
            [self.view addSubview:upBackV];
            //地址
            UIImageView *addressIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, upBackV.frame.size.height/2, 20, 20)];
            addressIV.image=[UIImage imageNamed:@"icon_dizhi"];
            UILabel *addresslab= [[UILabel alloc] initWithFrame:CGRectMake(50, upBackV.frame.size.height/2, 65, 20)];
            addresslab.text=@"地址 ：";
            UILabel *addressVL=[[UILabel alloc] initWithFrame:CGRectMake(105, upBackV.frame.size.height/2, 220, 20)];
            addressVL.text=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"address"]];
            [upBackV addSubview:addressIV];
            [upBackV addSubview:addresslab];
            [upBackV addSubview:addressVL];
            
            //营业时间
            UIImageView *timeIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, upBackV.frame.size.height/2+30, 20, 20)];
            timeIV.image=[UIImage imageNamed:@"icon_shijian"];
            UILabel *timelab= [[UILabel alloc] initWithFrame:CGRectMake(50, upBackV.frame.size.height/2+30, 105, 20)];
            timelab.text=@"营业时间 ：";
            UILabel *timeVL=[[UILabel alloc] initWithFrame:CGRectMake(145, upBackV.frame.size.height/2+30, 300, 20)];
            timeVL.text=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"office_hours"]];
            [upBackV addSubview:timeIV];
            [upBackV addSubview:timelab];
            [upBackV addSubview:timeVL];
            
            //服务电话
            UIImageView *phoneIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, upBackV.frame.size.height/2+60, 20, 20)];
            phoneIV.image=[UIImage imageNamed:@"store_dianhua"];
            UILabel *phonelab= [[UILabel alloc] initWithFrame:CGRectMake(50, upBackV.frame.size.height/2+60, 105, 20)];
            phonelab.text=@"服务电话 ：";
            phoneVL=[[UILabel alloc] initWithFrame:CGRectMake(145, upBackV.frame.size.height/2+60, 300, 20)];
            phoneVL.text=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"phone"]];
            phoneVL.textColor=UIColorFromRGB(0xFFBA02);
            phoneVL.userInteractionEnabled = YES;
            UITapGestureRecognizer* phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTapGesture)];
            [phoneVL addGestureRecognizer:phoneTap];
            [upBackV addSubview:phoneIV];
            [upBackV addSubview:phonelab];
            [upBackV addSubview:phoneVL];
            
            UIView *downView=[[UIView alloc] initWithFrame:CGRectMake(0, screenHeight/2, screenWidth, 60)];
            downView.backgroundColor=[UIColor whiteColor];
            downView.layer.shadowColor = [UIColor blackColor].CGColor;
            downView.layer.shadowOffset = CGSizeMake(0,1);
            downView.layer.shadowOpacity = 0.5;
            downView.layer.shadowRadius = 1;
            UILabel *shuLine=[[UILabel alloc] initWithFrame:CGRectMake(downView.frame.size.width/2, 5, 1, 50)];
            shuLine.backgroundColor = [UIColor lightGrayColor];
            _repairCtl=[[UIControl alloc] initWithFrame:CGRectMake(0, 0, downView.frame.size.width/2, 60)];
            [_repairCtl addTarget:self action:@selector(touchDownRepair:) forControlEvents:UIControlEventTouchDown];
            _repairBtn=[[UIButton alloc] initWithFrame:CGRectMake(45, 10, 40, 40)];
            [_repairBtn setImage:[UIImage imageNamed:@"icon_baoxiu"] forState:UIControlStateNormal];
            _repairBtn.userInteractionEnabled=NO;
            _repairLab=[[UILabel alloc] initWithFrame:CGRectMake(108, 18, 80, 30)];
            _repairLab.text=@"报修";
            [_repairCtl addSubview:_repairBtn];
            [_repairCtl addSubview:_repairLab];
            
            _adviceCtl=[[UIControl alloc] initWithFrame:CGRectMake(downView.frame.size.width/2+1, 0, downView.frame.size.width/2, 60)];
            [_adviceCtl addTarget:self action:@selector(touchDownAdvice:) forControlEvents:UIControlEventTouchDown];
            _adviceBtn=[[UIButton alloc] initWithFrame:CGRectMake(45, 10, 40, 40)];
            [_adviceBtn setImage:[UIImage imageNamed:@"icon_jianyi"] forState:UIControlStateNormal];
             _adviceBtn.userInteractionEnabled=NO;
            _adviceLab=[[UILabel alloc] initWithFrame:CGRectMake(108, 18, 80, 30)];
            _adviceLab.text=@"建议";
            [_adviceCtl addSubview:_adviceBtn];
            [_adviceCtl addSubview:_adviceLab];
            [downView addSubview:_repairCtl];
            [downView addSubview:_adviceCtl];
            [downView addSubview:shuLine];
            [self.view addSubview:downView];
            
        }else{
            
            UIImageView *noPIV=[[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2, 100, 100, 100)];
            noPIV.image=[UIImage imageNamed:@"wuyeinit"];
            noPIV.center=CGPointMake(screenWidth/2, screenHeight/4);
            UILabel *tiplab=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2, 160, screenWidth, 20)];
            tiplab.text=@"物业还没有来，请等待...";
            tiplab.textAlignment=NSTextAlignmentCenter;
            tiplab.font=[UIFont systemFontOfSize:11.0];
            tiplab.center=CGPointMake(screenWidth/2, screenHeight/4+90);
            [self.view addSubview:noPIV];
            [self.view addSubview:tiplab];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
       
    }];
    NSLog(@"propertyObj is %@",propertyObj);
    }

-(void) touchDownRepair:(id)sender{

        NSLog(@"维修");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults stringForKey:@"type"] isEqualToString:@"0"])
    {
        RepairVC *repairTVC = [[RepairVC alloc] init];
        UIBarButtonItem *backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"报修" style:UIBarButtonItemStylePlain target:nil action:nil];
        repairTVC.userIdStr=[defaults stringForKey:@"userId"];
        [self.navigationItem setBackBarButtonItem:backItemTitle];
        [self.navigationController pushViewController:repairTVC animated:YES];
    }else{
        
        AdministratorRTVC *admRTVC = [[AdministratorRTVC alloc] init];
        UIBarButtonItem *backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItemTitle];
        [self.navigationController pushViewController:admRTVC animated:YES];
    }

}

-(void) touchDownAdvice:(id)sender{
    
        MyAdviceTVC *myATVC=[[MyAdviceTVC alloc] initWithStyle:UITableViewStyleGrouped];
    
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        myATVC.userIdStr=[defaults stringForKey:@"userId"];
    
        UIBarButtonItem *backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"建议" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItemTitle];
        [self.navigationController pushViewController:myATVC animated:YES];
         NSLog(@"建议");
}

-(void)phoneTapGesture{

    NSMutableString *phoneNum = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneVL.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNum]]];
    [self.view addSubview:callWebview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
