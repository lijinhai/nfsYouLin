//
//  DetailRepairVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/10/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DetailRepairVC.h"
#import "HeaderFile.h"
#import "ShowImageView.h"
#import "UIImageView+WebCache.h"
#import "StringMD5.h"
#import "ChatViewController.h"
#import "DialogView.h"
#import "BackgroundView.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "SqliteOperation.h"

@interface DetailRepairVC ()

@end

@implementation DetailRepairVC{

    UILabel* rectLab;
    //私信
    UIControl* sixinCtl;
    UILabel* sixinLab;
    UIImageView* sixinIV;
    //电话
    UIControl* phoneCtl;
    UILabel* phoneLab;
    UIImageView* phoneIV;
    //进度
    UIControl* scheduCtl;
    UILabel* scheduLab;
    UIImageView* scheduIV;
    UILabel *line1;
    UILabel *line2;
    
    UILabel* timeLine;
    UILabel *tipLab1;
    UILabel *tipLab2;
    UILabel *tipLab3;
    DialogView* dialogView;
    UIView* backgroundView;
    UInt64 timeMid;
    UInt64 timeLast;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
     self.view.backgroundColor = [UIColor whiteColor];
    [self setContentData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setContentData{

    CGFloat height=0;
    rectLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 8)];
    rectLab.backgroundColor =  BackgroundColor;
    [self.view addSubview:rectLab];
     self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 85,45, 45)];
     NSLog(@"head_URL is %@",self.neighborData.iconName);
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.neighborData.iconName] placeholderImage:[UIImage imageNamed:@"account.png"] options:(SDWebImageAllowInvalidSSLCertificates) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconView.frame = CGRectMake(15, 90,45, 45);
    }];
    
    self.accountInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame)+15, CGRectGetMaxY(_iconView.frame) - 30, screenWidth-80, 20)];
    self.accountInfoLabel.text = self.neighborData.accountName;
    self.accountInfoLabel.textColor = UIColorFromRGB(0x808A87);
    self.accountInfoLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_accountInfoLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, CGRectGetMaxY(_iconView.frame)+10, screenWidth*2/3, 30)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = self.neighborData.titleName;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:_titleLabel];
    
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 100, CGRectGetMaxY(_iconView.frame)+11,110, 20)];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.text = [StringMD5 ConvertStrToTime:self.neighborData.topicTime];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:_timeLabel];
    
    
    height += CGRectGetMaxY(_titleLabel.frame);
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, height+10, screenWidth-12, 30)];
    self.contentLabel.text = self.neighborData.publishText;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    //[self.contentLabel setBackgroundColor:[UIColor whiteColor]];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentLabel setFrame: CGRectMake(12, height+10, screenWidth-12, [self contentSize:_contentLabel].height)];
    [self.view addSubview:_iconView];
    [self.view addSubview:_contentLabel];
    height = CGRectGetMaxY(_contentLabel.frame);
    NSLog(@"数组长度 = %ld",[self.neighborData.picturesArray count]);
    //创建配图
    CGFloat picturesViewW = (screenWidth - PADDING ) / 3 - (PADDING / 2);
    CGFloat picturesViewH = (screenWidth - PADDING ) / 3 - (PADDING / 2);
    for (int i = 0; i < [self.neighborData.picturesArray count]; i++)
    {
        UIImageView *pictureView = [[UIImageView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureView addGestureRecognizer:tap];
        pictureView.tag = imageTag + i;
        pictureView.userInteractionEnabled = YES;
        CGFloat picturesViewX = PADDING + (i % 3)*(picturesViewW + PADDING / 2);
        CGFloat picturesViewY = CGRectGetMaxY(self.contentLabel.frame) + PADDING + (PADDING / 2 + picturesViewH) * (i / 3);
        CGRect pictureFrame = CGRectMake(picturesViewX, picturesViewY, picturesViewW, picturesViewH);
        
        NSURL* url = [NSURL URLWithString:[[self.neighborData.picturesArray objectAtIndex:i] valueForKey:@"resPath"]];
        NSLog(@"usl is %@",url);
        [pictureView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
        
         pictureView.frame = pictureFrame;
        [self.view addSubview:pictureView];
        [self.picturesView addObject:pictureView];
         height = CGRectGetMaxY(pictureView.frame);
    }
    height +=  PADDING;
    self.dingweiView = [[UIImageView alloc] initWithFrame:CGRectMake(12, height, 12, 15)];
    _dingweiView.image = [UIImage imageNamed:@"dizhixinxi-nav"];
    [self.view addSubview:_dingweiView];
    self.floorNumLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dingweiView.frame)+8, height-2, screenWidth, 20)];
    self.floorNumLab.text = self.neighborData.familyName;
    self.floorNumLab.font = [UIFont systemFontOfSize:13.0f];
    self.floorNumLab.textColor = UIColorFromRGB(0x000000);
    [self.view addSubview:_floorNumLab];
    height += 2 * PADDING;
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, height+8, screenWidth, 0.3)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    //私信
   sixinCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame)+5, screenWidth/3-1, 38)];
   sixinCtl.backgroundColor = [UIColor whiteColor];
   sixinCtl.userInteractionEnabled = YES;
  [sixinCtl addTarget:self action:@selector(touchDownSiXin:) forControlEvents:UIControlEventTouchDown];
    sixinIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/12+8, 10, 22, 20)];
    sixinIV.image = [UIImage imageNamed:@"comment"];
    
    sixinLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sixinIV.frame)+5, 10, 40, 20)];
    sixinLab.text = @"私信";
    sixinLab.font = [UIFont systemFontOfSize:13.0f];
    [sixinCtl addSubview:sixinIV];
    [sixinCtl addSubview:sixinLab];
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sixinCtl.frame)+1, screenWidth,0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2];
    //竖线1
    UILabel* shortLine1 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/3-1, 10, 0.3, 15)];
    shortLine1.backgroundColor = [UIColor lightGrayColor];
    
    //竖线2
    [sixinCtl addSubview:shortLine1];
    [self.view addSubview:sixinCtl];
    
    //电话
    phoneCtl = [[UIControl alloc] initWithFrame:CGRectMake(screenWidth/3+1, CGRectGetMaxY(line1.frame)+5, screenWidth/3, 38)];
    phoneCtl.backgroundColor = [UIColor whiteColor];
    phoneCtl.userInteractionEnabled = YES;
    [phoneCtl addTarget:self action:@selector(touchDownPhone:) forControlEvents:UIControlEventTouchDown];
    phoneIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/12+8, 10, 18, 20)];
    phoneIV.image = [UIImage imageNamed:@"dianhua"];
    
    phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneIV.frame)+5, 10, 40, 20)];
    phoneLab.text = @"电话";
    phoneLab.font = [UIFont systemFontOfSize:13.0f];
    [phoneCtl addSubview:phoneIV];
    [phoneCtl addSubview:phoneLab];
   
    UILabel* shortLine2 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/3-1, 10, 0.3, 15)];
    shortLine2.backgroundColor = [UIColor lightGrayColor];
    [phoneCtl addSubview:shortLine2];
    [self.view addSubview:phoneCtl];
    
    //进度
    scheduCtl = [[UIControl alloc] initWithFrame:CGRectMake(screenWidth*2/3+1, CGRectGetMaxY(line1.frame)+5, screenWidth/3, 38)];
    scheduCtl.backgroundColor = [UIColor whiteColor];
    scheduCtl.userInteractionEnabled = YES;
    [scheduCtl addTarget:self action:@selector(touchDownSchedu:) forControlEvents:UIControlEventTouchDown];
    scheduIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/12+8, 16, 24, 8)];
    scheduIV.image = [UIImage imageNamed:@"jindu"];
    
    scheduLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneIV.frame)+8, 10, 40, 20)];
    scheduLab.text = @"进度";
    scheduLab.font = [UIFont systemFontOfSize:13.0f];
    [scheduCtl addSubview:scheduLab];
    [scheduCtl addSubview:scheduIV];
    [self.view addSubview:scheduCtl];


}
- (void)tapImageView: (UITapGestureRecognizer*) recognizer
{
    
    NSMutableArray* imageArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.neighborData.picturesArray count]; i++) {
        [imageArray addObject:[[self.neighborData.picturesArray objectAtIndex:i] valueForKey:@"resPath"]];
    }
    NSLog(@"recognizer.view.tag is %ld",recognizer.view.tag);
    [self showImageViewWithImageViews:imageArray byClickWhich:recognizer.view.tag];
}

- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    UIView *maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screenWidth, screenHeight)];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view.window addSubview:maskview];
    
    ShowImageView* showImage = [[ShowImageView alloc] initWithFrame:self.parentViewController.view.bounds byClickTag:clickTag appendArray:imageViews];
    [showImage show:maskview didFinish:^(){
        [UIView animateWithDuration:0.5f animations:^{
            showImage.alpha = 0.0f;
            maskview.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [showImage removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
    
}
/**
 *  计算lab高度
 *
 */
- (CGSize)contentSize:(UILabel*)lab {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lab.lineBreakMode;
    paragraphStyle.alignment = lab.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : lab.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [lab.text boundingRectWithSize:CGSizeMake(lab.frame.size.width, MAXFLOAT)
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes:attributes
                                                context:nil].size;
    return contentSize;
}


-(void) touchDownSiXin:(id)sender{

    NSLog(@"点击私信");
    NSString* senderId = [NSString stringWithFormat:@"%@",self.neighborData.senderId];
    NSString* nickName = self.neighborData.accountName;
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:senderId conversationType:EMConversationTypeChat];
    NSLog(@"nickName is %@",nickName);
    chatVC.title = nickName;
    [self.navigationController  pushViewController:chatVC animated:YES];
    
}

-(void) touchDownPhone:(id)sender{

    NSLog(@"phone is %@",self.neighborData.phone);
    NSMutableString *phoneNum = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.neighborData.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNum]]];
    [self.view addSubview:callWebview];

}

-(void) touchDownSchedu:(id)sender{

    timeLine = [[UILabel alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(line2.frame)+30, screenWidth-90, 2.5)];
    timeLine.backgroundColor = [UIColor lightGrayColor];
    timeLine.userInteractionEnabled = YES;
    UIButton* roundbegin = [[UIButton alloc] initWithFrame:CGRectMake(0, -3.5, 10, 10)];
    roundbegin.backgroundColor = [UIColor lightGrayColor];
    roundbegin.layer.masksToBounds = YES;
    roundbegin.layer.cornerRadius = 5;
    tipLab1 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(timeLine.frame)+15, 60, 20)];
    tipLab1.font = [UIFont systemFontOfSize:13.0f];
    tipLab1.text = @"等待审核";
    tipLab1.textColor = [UIColor blackColor];
    
    UIButton* roundmid = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth-90)/2, -3.5, 10, 10)];
    roundmid.backgroundColor = [UIColor lightGrayColor];
    roundmid.layer.masksToBounds = YES;
    roundmid.layer.cornerRadius = 5;
    roundmid.userInteractionEnabled = YES;
    tipLab2 = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-90)/2+30, CGRectGetMaxY(timeLine.frame)+15, 60, 40)];
    tipLab2.font = [UIFont systemFontOfSize:13.0f];
    tipLab2.text = @"审核通过派人维修";
    tipLab2.numberOfLines = 0 ;
    tipLab2.userInteractionEnabled = YES;
    tipLab2.tag = 1;
    UITapGestureRecognizer *tapGR0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tGRepairStatus:)];
    [tipLab2 addGestureRecognizer:tapGR0];
    
    UIButton* roundlast = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-90, -3.5, 10, 10)];
    roundlast.backgroundColor = [UIColor lightGrayColor];
    roundlast.layer.masksToBounds = YES;
    roundlast.layer.cornerRadius = 5;
    roundlast.userInteractionEnabled = YES;
    [roundlast addTarget:self action:@selector(tGRepairStatus:) forControlEvents:UIControlEventTouchUpInside];
    tipLab3 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-50, CGRectGetMaxY(timeLine.frame)+15, 60, 20)];
    tipLab3.font = [UIFont systemFontOfSize:13.0f];
    tipLab3.text = @"已维修";
    tipLab3.userInteractionEnabled = YES;
    tipLab3.tag = 2;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tGRepairStatus:)];
    [tipLab3 addGestureRecognizer:tapGR];
    
    [timeLine addSubview:roundmid];
    [timeLine addSubview:roundlast];
    [timeLine addSubview:roundbegin];
    [self.view addSubview:timeLine];
    [self.view addSubview:tipLab1];
    [self.view addSubview:tipLab2];
    [self.view addSubview:tipLab3];
    if([_repairF isEqualToString:@"等待审核"])
    {
        UIImageView* radius1 = [[UIImageView alloc] initWithFrame:CGRectMake(44.5, CGRectGetMaxY(timeLine.frame)-7, 12, 12)];
        radius1.image = [UIImage imageNamed:@"hongdian"];
        [self.view addSubview:radius1];
        [tipLab3 setUserInteractionEnabled:NO];
        
    }else if([_repairF isEqualToString:@"维修完成"])
    {
        UIImageView* radius1 = [[UIImageView alloc] initWithFrame:CGRectMake(44.5, CGRectGetMaxY(timeLine.frame)-7, 12, 12)];
        radius1.image = [UIImage imageNamed:@"hongdian"];
        [self.view addSubview:radius1];
        UIImageView* radius2 = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-90)/2+45, CGRectGetMaxY(timeLine.frame)-7, 12, 12)];
        radius2.image = [UIImage imageNamed:@"hongdian"];
        [self.view addSubview:radius2];
        UIImageView* radius3 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-44.5, CGRectGetMaxY(timeLine.frame)-7, 12, 12)];
        radius3.image = [UIImage imageNamed:@"hongdian"];
        [self.view addSubview:radius3];
        [timeLine setBackgroundColor:[UIColor redColor]];
        [timeLine setUserInteractionEnabled:NO];
        
    
    }else{
    
        UIImageView* radius1 = [[UIImageView alloc] initWithFrame:CGRectMake(44.5, CGRectGetMaxY(timeLine.frame)-7, 12, 12)];
        radius1.image = [UIImage imageNamed:@"hongdian"];
        [self.view addSubview:radius1];
        UIImageView* radius2 = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-90)/2+45, CGRectGetMaxY(timeLine.frame)-7, 12, 12)];
        radius2.image = [UIImage imageNamed:@"hongdian"];
        [self.view addSubview:radius2];
        UILabel* fugaiLine = [[UILabel alloc] initWithFrame:CGRectMake(56, CGRectGetMaxY(line2.frame)+30, (screenWidth-90)/2-11, 2.5)];
        fugaiLine.backgroundColor = [UIColor redColor];
        [self.view addSubview:fugaiLine];
        [tipLab2 setUserInteractionEnabled:NO];
       
    }
    


}
-(void)tGRepairStatus:(id)sender{

    UITapGestureRecognizer * singleTap = (UITapGestureRecognizer *)sender;
    DialogView* repairView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"repairStatus"];
    backgroundView.alpha = 0.0f;
    repairView.alpha = 0.0f;
    [self.view  addSubview:backgroundView];
    [self.view  addSubview:repairView];
    [UIView animateWithDuration:0.3f animations:^{
        backgroundView.alpha = 0.8f;
        repairView.alpha = 1.0f;
    }];
    dialogView = repairView;
    UIButton* okBtn = repairView.repairYes;
     okBtn.tag = [singleTap view].tag;
    NSLog(@"okBtn.tag is %ld",okBtn.tag);
    [okBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okRepairAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelBtn = repairView.repairNo;
    [cancelBtn addTarget:self action:@selector(cancelRepairAction:) forControlEvents:UIControlEventTouchUpInside];

}

// 确定更新维修进度
- (void) okRepairAction: (id) sender
{
    NSLog(@" sender id is %ld",[sender tag]);
    NSInteger statusVal = 0;
    if([sender tag]==1)
    {
        UIImageView* radius2 = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-90)/2+45, CGRectGetMaxY(timeLine.frame)-7, 12, 12)];
        radius2.image = [UIImage imageNamed:@"hongdian"];
        [self.view addSubview:radius2];
        UILabel* fugaiLine = [[UILabel alloc] initWithFrame:CGRectMake(56, CGRectGetMaxY(line2.frame)+30, (screenWidth-90)/2-11, 2.5)];
        fugaiLine.backgroundColor = [UIColor redColor];
        [self.view addSubview:fugaiLine];
        [tipLab2 setUserInteractionEnabled:NO];
        [tipLab3 setUserInteractionEnabled:YES];
        statusVal = 2;
    
    }else{
    
        UIImageView* radius3 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-44.5, CGRectGetMaxY(timeLine.frame)-7, 12, 12)];
        radius3.image = [UIImage imageNamed:@"hongdian"];
        [self.view addSubview:radius3];
        UILabel* fugaiLine = [[UILabel alloc] initWithFrame:CGRectMake(34+(screenWidth-45)/2, CGRectGetMaxY(line2.frame)+30, (screenWidth-45)/2-33.5, 2.5)];
        fugaiLine.backgroundColor = [UIColor redColor];
        [self.view addSubview:fugaiLine];
        [tipLab2 setUserInteractionEnabled:NO];
        [tipLab3 setUserInteractionEnabled:NO];
        statusVal = 3;
    
    }
     NSString* proStr = [self dealProcessData:[sender tag]];
    [self alertRepairStatus:statusVal proData:proStr];
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
         dialogView = nil;
    }
    
}
// processData处理
-(NSString*) dealProcessData:(NSInteger)statusId
{

    NSString *processDataStr = [[self.neighborData.processData stringByReplacingOccurrencesOfString:@" " withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{ }"]];
    NSArray *array = [processDataStr componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    NSString *strOne = nil;
    NSString *strTwo = nil;
    NSString *strThree = nil;
    for(int i=0;i<[array count];i++)
    {
        NSArray *subArray = [array[i] componentsSeparatedByString:@":"];
        for(int j=0;j<[subArray count];j++)
        {
            if([[NSString stringWithFormat:@"%@",subArray[j]] isEqualToString:@"'1'"]||[subArray[j] isEqualToString:@"1"])
            {
                
                strOne = [NSString stringWithFormat:@"%@%@",@"{",array[i]];
                NSLog(@"strOne is %@",strOne);
                
            }else if([subArray[j] isEqualToString:@"'2'"]||[subArray[j] isEqualToString:@"2"]){
                if(statusId == 1)
                {
                 timeMid = [[NSDate date] timeIntervalSince1970]*1000;
                 strTwo = [NSString stringWithFormat:@"%@%@%@%@%@",@"'2'",@":",@"'",[NSString stringWithFormat:@"%lld",timeMid],@"'"];
                }else{
                
                    strTwo = [NSString stringWithFormat:@"%@",array[i]];
                }
                NSLog(@"strTwo is %@",strTwo);
                
            }else if([subArray[j] isEqualToString:@"'3'"]||[subArray[j] isEqualToString:@"3"]){
                
                if(statusId == 2)
                {
                    
                    timeLast = [[NSDate date] timeIntervalSince1970]*1000;
                    strThree = [NSString stringWithFormat:@"%@%@%@%@%@",@"'3'",@":",@"'",[NSString stringWithFormat:@"%lld",timeMid],@"'}"];
                    
                }else{
                
                    strThree = [NSString stringWithFormat:@"%@%@",array[i],@"}"];
                }
                 NSLog(@"strThree is %@",strThree);
            }
        }
        
    }
    NSString *lstStr = [NSString stringWithFormat:@"%@%@%@%@%@",strOne,@",",strTwo,@",",strThree];
    NSLog(@"lstStr:%@",lstStr);
    return  lstStr;

}

// 取消弹出设置框
- (void) cancelRepairAction: (id) sender
{
    
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}
//设置物业报修状态
-(void) alertRepairStatus:(NSInteger) statusId proData:(NSString*) proDataStr{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* processData = proDataStr;
    NSString* processStatus = [NSString stringWithFormat:@"%ld",statusId];
    NSString* topicId = self.neighborData.topicId;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%@process_data%@process_status%@",userId,communityId, topicId,processData,processStatus]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : topicId,
                                @"process_data" : processData,
                                @"process_status" : processStatus,
                                @"apitype" : @"apiproperty",
                                @"tag" :  @"setstatus",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:process_data:process_status:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取数据是%@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
        
            return;
            
        }else{
        
            [MBProgressHUBTool textToast:self.view Tip:@"请检查网络"];
            return;
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];


}
@end
