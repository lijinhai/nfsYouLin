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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    UILabel* timeLine = [[UILabel alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(line2.frame)+30, screenWidth-90, 2.5)];
    timeLine.backgroundColor = [UIColor lightGrayColor];
    UIView* roundbegin = [[UIView alloc] initWithFrame:CGRectMake(0, -3.5, 10, 10)];
    roundbegin.backgroundColor = [UIColor lightGrayColor];
    roundbegin.layer.masksToBounds = YES;
    roundbegin.layer.cornerRadius = 5;
    UILabel* tipLab1 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(timeLine.frame)+15, 60, 20)];
    tipLab1.font = [UIFont systemFontOfSize:13.0f];
    tipLab1.text = @"等待审核";
    tipLab1.textColor = [UIColor blackColor];
    
    UIView* roundmid = [[UIView alloc] initWithFrame:CGRectMake((screenWidth-90)/2, -3.5, 10, 10)];
    roundmid.backgroundColor = [UIColor lightGrayColor];
    roundmid.layer.masksToBounds = YES;
    roundmid.layer.cornerRadius = 5;
    UILabel* tipLab2 = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-90)/2+30, CGRectGetMaxY(timeLine.frame)+15, 60, 40)];
    tipLab2.font = [UIFont systemFontOfSize:13.0f];
    tipLab2.text = @"审核通过派人维修";
    tipLab2.numberOfLines = 0 ;
    
    
    UIView* roundlast = [[UIView alloc] initWithFrame:CGRectMake(screenWidth-90, -3.5, 10, 10)];
    roundlast.backgroundColor = [UIColor lightGrayColor];
    roundlast.layer.masksToBounds = YES;
    roundlast.layer.cornerRadius = 5;
    UILabel* tipLab3 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-50, CGRectGetMaxY(timeLine.frame)+15, 60, 20)];
    tipLab3.font = [UIFont systemFontOfSize:13.0f];
    tipLab3.text = @"已维修";
    
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
    
    }
    


}

@end
