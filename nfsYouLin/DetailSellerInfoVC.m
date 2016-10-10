//
//  DetailSellerInfoVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DetailSellerInfoVC.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+WebCache.h"
#import "StringMD5.h"
#import "SqliteOperation.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"
#import "UIViewLinkmanTouch.h"
#import "DialogView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DetailSellerInfoVC ()

@end

@implementation DetailSellerInfoVC{

    NSMutableDictionary* sellerDic;
    NSMutableDictionary* reviewersDic;
    UIView *addressV;
    UIView *timeV;
    UIView *phoneV;
    
    UIImageView* backIV;
    
    UILabel* bussessNL;
    UIImageView* addressIV;
    UIImageView* timeIV;
    UIImageView* phoneIV;
    
    UIImageView* dingweiIV;
    UIView* dingweiV;
    
    
    UILabel* detailAddressNL;
    UILabel* detailAddressVL;
    UILabel* timeNL;
    UILabel* timeVL;
    UILabel* phoneNL;
    UILabel* phoneVL;
    
    UIView* backgroundView;
    DialogView* dialogView;
    
    /*定位服务*/
    float fromLongitude;//经度
    float fromLatitude;//维度
    float toLongitude;//经度
    float toLatitude;//维度
    NSString *location;//位置
    CLLocationManager *locationManager;
    //评论区
    NSMutableArray *startAry;
    UIView* commentV;
    UIView* contentV;
    UIImageView* avatarIV;
    UILabel* nickL;
    UILabel* timeL;
    UILabel *contentL;
    UIImageView* start1IV;
    UIImageView* start2IV;
    UIImageView* start3IV;
    UIImageView* start4IV;
    UIImageView* start5IV;
    UIImage* fullGrayStart;
    UIImage* halfGrayStart;
    UIImage* noneGrayStart;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
     backgroundView.backgroundColor = [UIColor grayColor];
     backgroundView.alpha = 0.8;
     dialogView = nil;
     self.view.backgroundColor = BackgroundColor;
     backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, screenWidth, self.view.frame.size.height/3-53)];
     bussessNL =  [[UILabel alloc] initWithFrame:CGRectMake(13, self.view.frame.size.height/3-85, screenWidth, 26)];
     bussessNL.textColor = [UIColor whiteColor];
     [backIV addSubview:bussessNL];
    
     dingweiIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-22, 17, 15, 15)];
     dingweiIV.image = [UIImage imageNamed:@"store_daohang"];
     dingweiIV.userInteractionEnabled = YES;
     UITapGestureRecognizer* dingweiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dingweiTapGesture:)];
     [dingweiIV addGestureRecognizer:dingweiTap];
    
     addressV = [[UIViewLinkmanTouch alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3, screenWidth, 50)];
     addressV.backgroundColor = [UIColor whiteColor];
    
    
     timeV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3+51, screenWidth, 50)];
     timeV.backgroundColor = [UIColor whiteColor];
    
     phoneV = [[UIViewLinkmanTouch alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3+102, screenWidth, 50)];
     phoneV.backgroundColor = [UIColor whiteColor];
     phoneV.userInteractionEnabled = YES;
     UITapGestureRecognizer* phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTapGesture:)];
     [phoneV addGestureRecognizer:phoneTap];
    
     addressIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 15, 15)];
     addressIV.image = [UIImage imageNamed:@"store_dizhi"];
     detailAddressNL = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 80, 50)];
     detailAddressNL.text = @"详细地址 ：";
     detailAddressNL.userInteractionEnabled = YES;
     UITapGestureRecognizer* addressTapa = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapGesture:)];
     [detailAddressNL addGestureRecognizer:addressTapa];
     detailAddressNL.font = [UIFont systemFontOfSize:14];
     detailAddressVL = [[UILabel alloc] initWithFrame:CGRectMake(120, 0,screenWidth/2, 50)];
     detailAddressVL.font = [UIFont systemFontOfSize:14];
     detailAddressVL.userInteractionEnabled = YES;
     UITapGestureRecognizer* addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapGesture:)];
     [detailAddressVL addGestureRecognizer:addressTap];
    
     [addressV addSubview:dingweiIV];
     [addressV addSubview:addressIV];
     [addressV addSubview:detailAddressNL];
     [addressV addSubview:detailAddressVL];
    
     timeIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 15, 15)];
     timeIV.image = [UIImage imageNamed:@"store_shijian"];
     timeNL = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 80, 50)];
     timeNL.text = @"营业时间 ：";
     timeNL.font = [UIFont systemFontOfSize:14];
     timeVL = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, screenWidth-120, 50)];
     timeVL.font = [UIFont systemFontOfSize:14];
     timeVL.numberOfLines = 2;
     [timeV addSubview:timeIV];
     [timeV addSubview:timeNL];
     [timeV addSubview:timeVL];
    
     phoneIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 15, 15)];
     phoneIV.image = [UIImage imageNamed:@"store_dianhua"];
     phoneNL = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 80, 50)];
     phoneNL.text = @"预约电话 ：";
     phoneNL.font = [UIFont systemFontOfSize:14];
     phoneVL = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, screenWidth-120, 50)];
     phoneVL.font = [UIFont systemFontOfSize:14];
     phoneVL.numberOfLines = 2;
     [phoneV addSubview:phoneIV];
     [phoneV addSubview:phoneNL];
     [phoneV addSubview:phoneVL];
    //评论
    commentV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3+162, screenWidth, 60)];
    commentV.backgroundColor = [UIColor whiteColor];
    avatarIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    nickL = [[UILabel alloc] initWithFrame:CGRectMake(58, 12, screenWidth, 20)];
    nickL.textColor = UIColorFromRGB(0xFFD700);
    nickL.font = [UIFont systemFontOfSize:13.f];
    timeL = [[UILabel alloc] initWithFrame:CGRectMake(58, 32, 60, 20)];
    timeL.textColor = [UIColor lightGrayColor];
    timeL.font = [UIFont systemFontOfSize:13.f];
    
    fullGrayStart = [UIImage imageNamed:@"star_gray"];
    halfGrayStart = [UIImage imageNamed:@"star_half"];
    noneGrayStart = [UIImage imageNamed:@"star_yellow"];
    start1IV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 36, 12, 12)];
    start2IV = [[UIImageView alloc] initWithFrame:CGRectMake(112.5, 36, 12, 12)];
    start3IV = [[UIImageView alloc] initWithFrame:CGRectMake(125, 36, 12, 12)];
    start4IV = [[UIImageView alloc] initWithFrame:CGRectMake(137.5, 36, 12, 12)];
    start5IV = [[UIImageView alloc] initWithFrame:CGRectMake(150, 36, 12, 12)];
    
    start1IV.image = fullGrayStart;
    start2IV.image = fullGrayStart;
    start3IV.image = fullGrayStart;
    start4IV.image = fullGrayStart;
    start5IV.image = fullGrayStart;
    
    startAry = [[NSMutableArray alloc] initWithObjects:start1IV,start2IV,start3IV, start4IV,start5IV,nil];
    [commentV addSubview:avatarIV];
    [commentV addSubview:nickL];
    [commentV addSubview:timeL];
    [commentV addSubview:start1IV];
    [commentV addSubview:start2IV];
    [commentV addSubview:start3IV];
    [commentV addSubview:start4IV];
    [commentV addSubview:start5IV];
    
    contentV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3+222, screenWidth, 25)];
    contentV.backgroundColor = [UIColor whiteColor];
    contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screenWidth, 20)];
    contentL.font = [UIFont systemFontOfSize:14.0f];
    contentL.numberOfLines = 0;
    contentL.textColor = [UIColor blackColor];
    contentL.textAlignment = NSTextAlignmentLeft;
    [contentL setBackgroundColor:[UIColor whiteColor]];
     contentL.lineBreakMode = NSLineBreakByWordWrapping;
    [contentV addSubview:contentL];
    
    [self.view addSubview:backIV];
    [self.view addSubview:addressV];
    [self.view addSubview:timeV];
    [self.view addSubview:phoneV];
     locationManager = [[CLLocationManager alloc] init];
    
     locationManager.delegate = self;
    // 设置定位精度
     locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    [locationManager startUpdatingLocation];
     sellerDic = [[NSMutableDictionary alloc] init];
    [self getSellerDetailInfo];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    NSLog(@"self.navigationController.navigationBar.subviews is %ld",[self.navigationController.navigationBar.subviews count]);
    for(UIView *views in self.navigationController.navigationBar.subviews)
    {
      if(views.tag == 101 || views.tag ==102)
      {
       [views removeFromSuperview];
      }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*调用百度地图*/
-(void)dingweiTapGesture:(UITapGestureRecognizer*) gesture{

    
    if ([CLLocationManager locationServicesEnabled]) {
        
        // 获取经纬度
        fromLatitude = locationManager.location.coordinate.latitude;
        fromLongitude = locationManager.location.coordinate.longitude;
        NSLog(@"fromLatitude = %f\n fromLongitude =%f",fromLatitude,fromLongitude);
        
    }
    else {
        
         [MBProgressHUBTool textToast:self.view Tip:@"请开启定位功能"];
         return;
    }
     
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
    {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=transit&region=哈尔滨&src=北京有凡科技有限公司|优邻&coord_type=bd09ll",fromLatitude,fromLongitude,toLatitude,toLongitude] stringByAddingPercentEncodingWithAllowedCharacters : NSCharacterSet.URLQueryAllowedCharacterSet];
         NSLog(@"百度地图客户端：%@",urlString);
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    }else{
        
        NSString *urlString = [[NSString stringWithFormat:@"http://api.map.baidu.com/direction?origin=%f,%f&destination=%f,%f&mode=transit&region=哈尔滨&output=html&src=北京有凡科技有限公司|优邻&coord_type=bd09ll",fromLatitude,fromLongitude,toLatitude,toLongitude] stringByAddingPercentEncodingWithAllowedCharacters : NSCharacterSet.URLQueryAllowedCharacterSet];
        NSLog(@"百度地图网页%@",urlString);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }

}

/*弹出详细地址*/
-(void)addressTapGesture:(UITapGestureRecognizer*) gesture{
    
    DialogView* deleteView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"bussnessName"];
    [self.view  addSubview:backgroundView];
    [self.view  addSubview:deleteView];
    
    deleteView.titleL.text = detailAddressVL.text;
    dialogView = deleteView;
    UIButton* okBtn = deleteView.OKbtn;
    [okBtn addTarget:self action:@selector(OkAction:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)OkAction:(id)sender{

    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
         dialogView = nil;
    }

}

/*服务电话*/
- (void)phoneTapGesture: (UITapGestureRecognizer*) gesture
{
    if([phoneVL.text isEqualToString:@"未提供"])
        return;
    NSMutableString *phoneNum = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneVL.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNum]]];
    [self.view addSubview:callWebview];
}

/*获取商家详细信息*/
-(void)getSellerDetailInfo{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
   
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"uid%@community_id%@",_uuid,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"uid" : _uuid,
                                @"community_id" : communityId,
                                @"apitype" : @"address",
                                @"tag" : @"intobizcirdetail",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"uid:community_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"商店信息请求:%@", responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            sellerDic = [responseObject objectForKey:@"detail"];
            reviewersDic = [[NSMutableDictionary alloc] init];
           if([[NSString stringWithFormat:@"%@",[sellerDic valueForKey:@"imgurl"]] isEqualToString:@"<null>"] || [[NSString stringWithFormat:@"%@",[sellerDic valueForKey:@"imgurl"]] isEqualToString:@""])
           {
               [backIV sd_setImageWithURL:[NSURL URLWithString:_insteadIVURL] placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   NSLog(@"error is %@",error);
               }];
               
           }else{
           
               [backIV sd_setImageWithURL:[NSURL URLWithString:[sellerDic valueForKey:@"imgurl"]] placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                   NSLog(@"error is %@",error);
               }];

           }
            //eva_dict
            if([[NSString stringWithFormat:@"%@",[sellerDic valueForKey:@"eva_dict"]] isEqualToString:@"<null>"])
            {
                
                 reviewersDic = nil;
                
            }else{
                
                 reviewersDic = [sellerDic valueForKey:@"eva_dict"];
                [avatarIV sd_setImageWithURL:[NSURL URLWithString:[reviewersDic valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"account"] options:SDWebImageAllowInvalidSSLCertificates  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    NSLog(@"error is %@",error);
                }];
                 NSString* timeInterval = [StringMD5 calculateTimeInternal:[[sellerDic valueForKey:@"systime"] floatValue] / 1000 old:[[reviewersDic valueForKey:@"time"] floatValue] / 1000];
                 timeL.text = timeInterval;
                if([[NSString stringWithFormat:@"%@",[reviewersDic valueForKey:@"status"]] integerValue]==1)
                {
                  nickL.text = @"匿名";
                }else{
                
                  nickL.text = [reviewersDic valueForKey:@"nick"];
                }
                
                for(int i=0;i<floor([[reviewersDic valueForKey:@"facility"] doubleValue]);i++){
                    
                    UIImageView* fullStar = [startAry objectAtIndex:i];
                    fullStar.image = noneGrayStart;
                    
                }
                
                float decimal = [[reviewersDic valueForKey:@"facility"] doubleValue]-floor([[reviewersDic valueForKey:@"facility"] doubleValue]);
                
                if(decimal > 0)
                {
                    
                    UIImageView* fullStar = [startAry objectAtIndex:floor([[reviewersDic valueForKey:@"facility"] doubleValue])];
                    fullStar.image = halfGrayStart;
                    for(int i=floor([[reviewersDic valueForKey:@"facility"] doubleValue])+1;i<5;i++){
                        UIImageView* fullStar = [startAry objectAtIndex:i];
                        fullStar.image = fullGrayStart;
                    }
                    
                }else{
                    
                    for(int i=floor([[reviewersDic valueForKey:@"facility"] doubleValue]);i<5;i++){
                        
                        UIImageView* fullStar = [startAry objectAtIndex:i];
                        fullStar.image = fullGrayStart;
                        
                    }
                }
                 contentL.text = [reviewersDic valueForKey:@"content"];
                 //NSLog(@"contentL.text is %@",contentL.text);
                 [contentL setFrame: CGRectMake(16, 10, screenWidth-30, [self contentSize:contentL].height)];
                 [contentV setFrame:CGRectMake(0, self.view.frame.size.height/3+222, screenWidth, contentL.frame.size.height+40)];
                 [self.view addSubview:commentV];
                 [self.view addSubview:contentV];
                 //NSLog(@"reviewersDic content is %@",timeInterval);
            
            }
            NSMutableArray* aryLocation = [NSMutableArray arrayWithArray:[[sellerDic objectForKey:@"location"] componentsSeparatedByString:@","]];
            toLatitude = [[[aryLocation objectAtIndex:0] substringFromIndex:8] floatValue];
            toLongitude = [[[aryLocation objectAtIndex:1] substringFromIndex:7] floatValue];
            bussessNL.text = [sellerDic valueForKey:@"name"];
            detailAddressVL.text = [sellerDic valueForKey:@"address"];
            
            if([[NSString stringWithFormat:@"%@",[sellerDic valueForKey:@"shophours"]] isEqualToString:@"<null>"])
            {
                
              timeVL.text = @"未提供";
            }else{
                
              timeVL.text = [sellerDic valueForKey:@"shophours"];
            }
            
            if([[NSString stringWithFormat:@"%@",[sellerDic valueForKey:@"telephone"]]isEqualToString:@"<null>"])
            {
                
                phoneVL.text = @"未提供";
            }else{
                
                phoneVL.text = [sellerDic valueForKey:@"telephone"];
            }
            
             //NSLog(@"sellerDic is %@",[sellerDic valueForKey:@"address"]);
            return;
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

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
#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    //NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    //NSLog(@"经度:%f",newLocation.coordinate.longitude);
    fromLatitude = newLocation.coordinate.latitude;
    fromLongitude = newLocation.coordinate.longitude;
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

@end
