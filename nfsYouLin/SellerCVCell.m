//
//  SellerCVCell.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "SellerCVCell.h"
#import "UIImageView+WebCache.h"
#import "StringMD5.h"
#import "HeaderFile.h"

@implementation SellerCVCell{
    CGSize sizeN;
    UIImageView* start1IV;
    UIImageView* start2IV;
    UIImageView* start3IV;
    UIImageView* start4IV;
    UIImageView* start5IV;
    UIImage* fullGrayStart;
    UIImage* halfGrayStart;
    UIImage* noneGrayStart;
    UIImageView* dingweiIV;
    NSMutableArray * startAry;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 商家图片
        _sellerIV = [[UIImageView alloc] init];
      

        // 商家名称
        _sellerNL = [[UILabel alloc] init];
        self.sellerNL.textColor = [UIColor blackColor];
        self.sellerNL.font = [UIFont systemFontOfSize:15.f];

        // 商家位置
        _sellerPL = [[UILabel alloc] init];
        self.sellerPL.textColor = [UIColor lightGrayColor];
        self.sellerPL.font = [UIFont systemFontOfSize:12.f];
        
        // 商家距离
        _sellerDL = [[UILabel alloc] init];
        dingweiIV = [[UIImageView alloc] init];
        self.sellerDL.textColor = [UIColor lightGrayColor];
        self.sellerDL.font = [UIFont systemFontOfSize:12.f];
        
        // 商家评级
        _sellerLL =[[UILabel alloc] init];
        self.sellerLL.textColor = UIColorFromRGB(0xFFBA02);
        self.sellerLL.font = [UIFont systemFontOfSize:12.f];
        start1IV=[[UIImageView alloc] initWithFrame:CGRectMake(110, self.frame.size.height-25, 12, 12)];
        start2IV=[[UIImageView alloc] initWithFrame:CGRectMake(122.5, self.frame.size.height-25, 12, 12)];
        start3IV=[[UIImageView alloc] initWithFrame:CGRectMake(135, self.frame.size.height-25, 12, 12)];
        start4IV=[[UIImageView alloc] initWithFrame:CGRectMake(147.5, self.frame.size.height-25, 12, 12)];
        start5IV=[[UIImageView alloc] initWithFrame:CGRectMake(160, self.frame.size.height-25, 12, 12)];
        
        start1IV.image = fullGrayStart;
        start2IV.image = fullGrayStart;
        start3IV.image = fullGrayStart;
        start4IV.image = fullGrayStart;
        start5IV.image = fullGrayStart;
        
        startAry = [[NSMutableArray alloc] initWithObjects:start1IV,start2IV,start3IV, start4IV,start5IV,nil];
        
        // 分割线
        UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        line.backgroundColor = UIColorFromRGB(0xf5f5f5);

        [self.contentView addSubview:_sellerIV];
        [self.contentView addSubview:_sellerNL];
        [self.contentView addSubview:dingweiIV];
        [self.contentView addSubview:_sellerPL];
        [self.contentView addSubview:_sellerDL];
        [self.contentView addSubview:_sellerLL];
        
        [self.contentView addSubview:start1IV];
        [self.contentView addSubview:start2IV];
        [self.contentView addSubview:start3IV];
        [self.contentView addSubview:start4IV];
        [self.contentView addSubview:start5IV];
        [self.contentView addSubview:line];
    }
    return self;
}



-(void) setSellerData:(SellerInfo *)sellerData{
    
    _sellerData = sellerData;
    [SDWebImageDownloader.sharedDownloader setValue:@"ios-dev" forHTTPHeaderField:@"User-Agent"];
    [self.sellerIV sd_setImageWithURL:[NSURL URLWithString:_sellerData.sellerPicUrl] placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:(SDWebImageAllowInvalidSSLCertificates) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image.size.width == image.size.height)
        {
            
            self.sellerIV.frame = CGRectMake(0, 0,80, 80);
            
        }else{
         
            self.sellerIV.frame = CGRectMake(0, 0,80, 57);
        }
        self.sellerIV.center = CGPointMake(55, 48);
    }];
    
    self.sellerNL.text = _sellerData.sellerName;
    sizeN = [self.sellerNL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil]];
    self.sellerNL.frame=CGRectMake(110,3,screenWidth-110-80, 30);
    
    dingweiIV.frame = CGRectMake(110, self.frame.size.height/2-6, 9, 12);
    dingweiIV.image = [UIImage imageNamed:@"icon_dibiao"];
    self.sellerPL.text =_sellerData.sellerPosition;
    CGSize sizeP = [self.sellerPL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10],NSFontAttributeName, nil]];
    self.sellerPL.frame=CGRectMake(127,self.frame.size.height/2-8,screenWidth*2/3, 20);
    
    
    
    if([_sellerData.sellerDistance intValue]<=200)
    {
        
     self.sellerDL.text = [NSString stringWithFormat:@"%@%@%@",@"<",@"200",@"米"];
    }else if([_sellerData.sellerDistance intValue]<=500&&[_sellerData.sellerDistance intValue]>200)
    {
    
        self.sellerDL.text = [NSString stringWithFormat:@"%@%@%@",@"<",@"200",@"米"];

    }else{
    
        self.sellerDL.text = [NSString stringWithFormat:@"%@%@%@",@"<",_sellerData.sellerDistance,@"米"];
    }
    CGSize sizeD = [self.sellerDL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]];
    self.sellerDL.frame=CGRectMake(self.frame.size.width-50,6,sizeD.width+50, 20);
    
    self.sellerLL.text = _sellerData.sellerLevel;
    CGSize sizeL = [self.sellerLL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]];
    self.sellerLL.frame=CGRectMake(180,self.frame.size.height-27,sizeL.width+40, 20);
    
    fullGrayStart=[UIImage imageNamed:@"star_gray"];
    halfGrayStart=[UIImage imageNamed:@"star_half"];
    noneGrayStart=[UIImage imageNamed:@"star_yellow"];
   

    for(int i=0;i<floor([self.sellerLL.text doubleValue]);i++){
    
        UIImageView* fullStar = [startAry objectAtIndex:i];
        fullStar.image = noneGrayStart;
    
    }
    
    float decimal = [self.sellerLL.text doubleValue]-floor([self.sellerLL.text doubleValue]);
    
    if(decimal > 0)
    {
        
        UIImageView* fullStar = [startAry objectAtIndex:floor([self.sellerLL.text doubleValue])];
        fullStar.image = halfGrayStart;
        for(int i=floor([self.sellerLL.text doubleValue])+1;i<5;i++){
            UIImageView* fullStar = [startAry objectAtIndex:i];
            fullStar.image = fullGrayStart;
        }
    
    }else{
    
        for(int i=floor([self.sellerLL.text doubleValue]);i<5;i++){
        
            UIImageView* fullStar = [startAry objectAtIndex:i];
            fullStar.image = fullGrayStart;
          
        }
    }
}


@end

