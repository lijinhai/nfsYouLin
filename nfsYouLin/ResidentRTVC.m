//
//  ResidentRTVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/10/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ResidentRTVC.h"
#import "UIImageView+WebCache.h"
#import "StringMD5.h"
#import "HeaderFile.h"

@implementation ResidentRTVC{
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 住户头像图片
        _headIV = [[UIImageView alloc] init];
        _headIV.frame = CGRectMake(0, 0, 45, 45);
        _headIV.layer.masksToBounds=YES;
        _headIV.layer.cornerRadius = 22.5;
        
        // 住户名称
        _nickNL = [[UILabel alloc] init];
        self.nickNL.textColor = [UIColor blackColor];
        self.nickNL.font = [UIFont systemFontOfSize:15.f];
        
        // 住户报修详情
        _repairDL = [[UILabel alloc] init];
        self.repairDL.textColor = [UIColor lightGrayColor];
        self.repairDL.font = [UIFont systemFontOfSize:12.f];
        self.repairDL.numberOfLines = 0;
        
        // 报修时间
        _repairTL = [[UILabel alloc] init];
        self.repairTL.textColor = [UIColor lightGrayColor];
        self.repairTL.font = [UIFont systemFontOfSize:12.f];
        
        // 审核状态
        _repairSL = [[UILabel alloc] init];
        self.repairSL.font = [UIFont systemFontOfSize:12.f];
       
        
        // 分割线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 1)];
        line.backgroundColor = UIColorFromRGB(0xf5f5f5);
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, screenWidth, 0.7)];
        line1.backgroundColor = UIColorFromRGB(0xf5f5f5);
        
        [self.contentView addSubview:_headIV];
        [self.contentView addSubview:_nickNL];
        [self.contentView addSubview:_repairDL];
        [self.contentView addSubview:_repairTL];
        [self.contentView addSubview:_repairSL];
    
        [self.contentView addSubview:line];
        [self.contentView addSubview:line1];
    }
    return self;
}



-(void) setResidenterRepairData:(residenterRinfo *)residenterRepairData{
    
    _residenterRepairData = residenterRepairData;
    [SDWebImageDownloader.sharedDownloader setValue:@"ios-dev" forHTTPHeaderField:@"User-Agent"];
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:_residenterRepairData.headPicUrl] placeholderImage:[UIImage imageNamed:@"account.png"] options:(SDWebImageAllowInvalidSSLCertificates) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.headIV.frame = CGRectMake(0, 0,45, 45);
            self.headIV.center = CGPointMake(35, 32);
    }];
    self.headIV.layer.cornerRadius = 22.5;
    self.nickNL.text = _residenterRepairData.nikeAndComm;
    sizeN = [self.nickNL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil]];
    self.nickNL.frame=CGRectMake(63,8,screenWidth-160, 20);
    

    self.repairDL.text = _residenterRepairData.repairDetailInfo;
    CGSize sizeD = [self.repairDL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10],NSFontAttributeName, nil]];
    self.repairDL.frame = CGRectMake(63,CGRectGetMaxY(_nickNL.frame)+5,screenWidth*2/3-80, sizeD.height);
    self.repairDL.numberOfLines = 0;

    NSString* timeInterval = [StringMD5 calculateTimeInternal:[_residenterRepairData.systemTime  floatValue] / 1000 old:[_residenterRepairData.repairTime floatValue] / 1000];
    self.repairTL.text = timeInterval;
    CGSize sizeT = [self.repairTL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]];
    
    self.repairTL.frame=CGRectMake(screenWidth-sizeT.width-10,6,sizeT.width+30, 20);
    self.repairSL.text = _residenterRepairData.auditStatus;
    if([_repairSL.text isEqualToString:@"等待审核"])
    {
        
        self.repairSL.textColor = UIColorFromRGB(0xFFBA02);
        
    }else if([_repairSL.text isEqualToString:@"维修完成"])
    {
        
        self.repairSL.textColor = [UIColor lightGrayColor];
    }else{
        
        self.repairSL.textColor = [UIColor redColor];
    }

    CGSize sizeS = [self.repairSL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]];
    self.repairSL.frame=CGRectMake(screenWidth-sizeS.width-10,30,sizeS.width, 20);
    
}

@end
