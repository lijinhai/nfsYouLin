//
//  NDetailTableViewCell.m
//  nfsYouLin
//
//  Created by Macx on 16/6/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NDetailTableViewCell.h"
#import "StringMD5.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"

@implementation NDetailTableViewCell
{

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if([reuseIdentifier isEqualToString:@"Zero"])
        {
            // 头像
            UIImageView* iconView = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, PADDING / 2, CGRectGetHeight(self.contentView.frame) - PADDING, CGRectGetHeight(self.contentView.frame) - PADDING)];
            iconView.layer.masksToBounds = YES;
            iconView.layer.cornerRadius = CGRectGetWidth(iconView.frame) / 2;
            [self.contentView addSubview:iconView];
            self.iconView = iconView;
            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageView:)];
            self.iconView.userInteractionEnabled = YES;
            [self.iconView addGestureRecognizer:tapGesture];
            
            // 创建帖子用户信息 用户名@地址
            UILabel* accountInfoLabel = [[UILabel alloc] init];
            accountInfoLabel.textAlignment = NSTextAlignmentLeft;
            accountInfoLabel.font = [UIFont systemFontOfSize:15];
            //            accountInfoLabel.font = [UIFont fontWithName:@"AppleGothic" size:15];
            [self.contentView addSubview:accountInfoLabel];
            self.accountInfoLabel = accountInfoLabel;
            
            // 帖子发表时间点
            UILabel* timeLabel = [[UILabel alloc] init];
            timeLabel.textAlignment = NSTextAlignmentLeft;
            timeLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:timeLabel];
            timeLabel.enabled = NO;
            self.timeLabel = timeLabel;

            
        }
        else if ([reuseIdentifier isEqualToString:@"One"])
        {
            // 创建帖子标题 #帖子类别# + 帖子名称
            UILabel* titleLabel = [[UILabel alloc] init];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [self.contentView addSubview:titleLabel];
            self.titleLabel = titleLabel;
            
            // 创建帖子内容
            UILabel* contentLabel = [[UILabel alloc] init];
            contentLabel.font = [UIFont fontWithName:@"AppleGothic" size:16];
            //            contentLabel.font = [UIFont systemFontOfSize:16];
            contentLabel.lineBreakMode = NSLineBreakByWordWrapping;     //去掉省略号
            contentLabel.numberOfLines = 0;
            [self.contentView addSubview:contentLabel];
            self.contentLabel = contentLabel;

            // 创建删除
            UIButton* deleteButton = [[UIButton alloc] init];
            [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            
            [deleteButton setTitleColor:[UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:0 / 255.0 alpha:1] forState:UIControlStateNormal];
            deleteButton.backgroundColor = [UIColor clearColor];
            deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            self.deleteButton = deleteButton;
            [self.deleteButton addTarget:self action:@selector(deleteBtn) forControlEvents:UIControlEventTouchDown];

        }
        else if([reuseIdentifier isEqualToString:@"Two"])
        {
            self.replyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width / 2, 40)];
            self.replyView.backgroundColor = [UIColor whiteColor];
            
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.replyView.frame), 10.0f, 1.0f, 20)];
            [lineView1 setBackgroundColor:[UIColor blackColor]];
            
            UIImageView *replyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.replyView.frame.size.width / 3 - 6, 10, 20, 20)];
            replyImageView.image = [UIImage imageNamed:@"comment"];
            [self.replyView addSubview:replyImageView];
            
            UILabel* replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(replyImageView.frame) + 2, 10, 30, 20)];
            replyLabel.text = @"回复";
            replyLabel.textAlignment = NSTextAlignmentLeft;
            replyLabel.font = [UIFont systemFontOfSize:15];
            [replyLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            [replyImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            self.replyLabel = replyLabel;
            [self.replyView addSubview:replyLabel];
            
            [self.replyView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
            [lineView1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
            
            [self.contentView addSubview:self.replyView];
            [self.contentView addSubview:lineView1];
            
            
            // 添加点赞
            self.praiseView = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame), 0, self.contentView.frame.size.width / 2, 40)];
            self.praiseView.backgroundColor = [UIColor whiteColor	];
            
            
            _praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.praiseView.frame.size.width / 3 - 4, 10, 20, 20)];
            _praiseImageView.image = [UIImage imageNamed:@"dianzan.png"];
            [_praiseImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            [self.praiseView addSubview:_praiseImageView];
            
            _praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_praiseImageView.frame) + 2, 10, 30, 20)];
            _praiseLabel.text = @"赞";
            _praiseLabel.font = [UIFont systemFontOfSize:15];
            _praiseLabel.textAlignment = NSTextAlignmentLeft;
            [_praiseLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            [self.praiseView addSubview:_praiseLabel];
            
            [self.praiseView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
            
            [self.praiseView addTarget:self action:@selector(touchDownPraise1) forControlEvents:UIControlEventTouchDown];
            [self.praiseView addTarget:self action:@selector(touchCancelPraise1) forControlEvents:UIControlEventTouchUpInside ];
            
            [self.contentView addSubview:self.praiseView];
            // 添加表格底边框
            UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, CGRectGetWidth(self.contentView.frame), 1)];
            separatorView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [self.contentView addSubview:separatorView];
            

        }
        else if([reuseIdentifier isEqualToString:@"Other"])
        {
            // 头像
            UIImageView* personView = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, PADDING / 2, 25, 25)];
            personView.layer.masksToBounds = YES;
            personView.layer.cornerRadius = CGRectGetWidth(personView.frame) / 2;
            [self.contentView addSubview:personView];
            self.personView = personView;
            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personImageView:)];
            self.personView.userInteractionEnabled = YES;
            [self.personView addGestureRecognizer:tapGesture];
            
            // 用户信息
            UILabel* personLable = [[UILabel alloc] init];
            personLable.textAlignment = NSTextAlignmentLeft;
            personLable.font = [UIFont systemFontOfSize:15];
            //            accountInfoLabel.font = [UIFont fontWithName:@"AppleGothic" size:15];
            [self.contentView addSubview:personLable];
            self.personLable = personLable;
            
            
            // 回复时间
            UILabel* replyTimeLabel = [[UILabel alloc] init];
            replyTimeLabel.textAlignment = NSTextAlignmentLeft;
            replyTimeLabel.font = [UIFont systemFontOfSize:12];
            //            accountInfoLabel.font = [UIFont fontWithName:@"AppleGothic" size:15];
            replyTimeLabel.enabled = NO;
            [self.contentView addSubview:replyTimeLabel];
            self.replyTimeLabel = replyTimeLabel;
            
            // 回复文本
            UILabel* repleyText = [[UILabel alloc] init];
            repleyText.font = [UIFont fontWithName:@"AppleGothic" size:16];

            repleyText.lineBreakMode = NSLineBreakByWordWrapping;     //去掉省略号
            repleyText.numberOfLines = 0;
            [self.contentView addSubview:repleyText];
            self.repleyText = repleyText;

            // 回复或删除按钮
            UIButton* otherButton = [[UIButton alloc] init];
            [otherButton setTitleColor:[UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:0 / 255.0 alpha:1] forState:UIControlStateNormal];
            otherButton.backgroundColor = [UIColor clearColor];
            otherButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            
            [otherButton addTarget:self action:@selector(otherBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:otherButton];
            self.otherButton = otherButton;
            
        }
        else
        {
            
        }
    }
    
    return self;
}

- (void)setNeighborData:(NeighborData *)neighborData
{
    _neighborData = neighborData;
    switch (self.rowNum) {
        case 0:
            [self setZeroCellData];
            break;
        case 1:
            [self setFirstCellData];
            break;
        case 2:
            [self setSecondCellData];
            break;
        default:
            [self setOtherCellData];
            break;
    }
}

- (void) setZeroCellData
{
    NSURL* url = [NSURL URLWithString:self.neighborData.iconName];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
    CGRect accountFrame;
    CGSize accountInfoLabelSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@",self.neighborData.accountName] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat accountInfoLabelW = accountInfoLabelSize.width;
    CGFloat accountInfoLabelH = accountInfoLabelSize.height;
    accountFrame = CGRectMake(CGRectGetMaxX(self.iconView.frame) +  PADDING / 2, PADDING / 2, accountInfoLabelW, accountInfoLabelH);
    self.accountInfoLabel.frame = accountFrame;
    self.accountInfoLabel.text = [NSString stringWithFormat:@"%@",self.neighborData.accountName];
    
    NSDate* topicTime = [NSDate dateWithTimeIntervalSince1970:[self.neighborData.topicTime integerValue] / 1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    
    CGSize timeLabelSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@",[formatter stringFromDate:topicTime]] font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat timeLabelW = timeLabelSize.width;
    CGFloat timeLabelH = timeLabelSize.height;
    self.timeLabel.frame = CGRectMake( CGRectGetMinX(self.accountInfoLabel.frame), CGRectGetMaxY(self.accountInfoLabel.frame), timeLabelW, timeLabelH);
    self.timeLabel.text = [formatter stringFromDate:topicTime];

}

- (void) setFirstCellData
{
    CGFloat height;
    CGRect titleFrame;
    CGSize titleSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"标题:%@",self.neighborData.titleName] font:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    titleFrame = CGRectMake(PADDING, PADDING, titleSize.width, titleSize.height);
    self.titleLabel.text = [NSString stringWithFormat:@"标题:%@",self.neighborData.titleName];
    self.titleLabel.frame = titleFrame;
    
    CGRect textLabelFrame;
    CGSize textLabelSize = [StringMD5 sizeWithString:self.neighborData.publishText font:[UIFont fontWithName:@"AppleGothic" size:16] maxSize:CGSizeMake(screenWidth - 2 * PADDING, MAXFLOAT)];
    textLabelFrame = CGRectMake(PADDING, CGRectGetMaxY(self.titleLabel.frame) + PADDING, textLabelSize.width, textLabelSize.height);
    self.contentLabel.frame = textLabelFrame;
    self.contentLabel.text = self.neighborData.publishText;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    
       NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[self.neighborData.publishText dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [attrStr length])];

    self.contentLabel.attributedText = attrStr;

    height = CGRectGetMaxY(self.contentLabel.frame);
    
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
        
        [pictureView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
        
        pictureView.frame = pictureFrame;
        [self.contentView addSubview:pictureView];
        [self.picturesView addObject:pictureView];
        height = CGRectGetMaxY(pictureView.frame);
    }
    
    height += 2 * PADDING;
    // 创建删除
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    CGSize deleteSize = [StringMD5 sizeWithString:@"删除" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat deleteX = screenWidth - deleteSize.width - PADDING;
    CGFloat deleteY = height;
    if([self.neighborData.senderId integerValue] == [userId integerValue])
    {
        self.deleteButton.frame = CGRectMake(deleteX, deleteY, deleteSize.width, deleteSize.height);
        [self.contentView addSubview:self.deleteButton];
        height = CGRectGetMaxY(self.deleteButton.frame) + PADDING;
        
    }
    else
    {
        
    }
    
    // 创建报名详情
    self.applyView = [[ApplyDetailView alloc] init];
    if([self.neighborData.topicCategory integerValue] == 1)
    {
        CGPoint point = CGPointMake(PADDING, height);
        
        NSDictionary* activityDict = self.neighborData.infoArray[0];
        NSInteger endTime = [[activityDict valueForKey:@"endTime"] integerValue];
        NSInteger systemTime = [self.neighborData.systemTime integerValue];
        
        self.applyView.applyNum.text = [NSString stringWithFormat:@"%ld",[[activityDict valueForKey:@"enrollTotal"] integerValue]];
        NSString *enrollFlag = [activityDict valueForKey:@"enrollFlag"];

        // 创建报名详情
        if([self.neighborData.senderId integerValue] == [userId integerValue])
        {
            self.applyView.applyLabel.text = @"报名详情";
        }
        else
        {
            if([enrollFlag isEqualToString:@"false"])
            {
                self.applyView.applyLabel.text = @"我要报名";
                
            }
            else if([enrollFlag isEqualToString:@"true"])
            {
                self.applyView.applyLabel.text = @"取消报名";
            }
        }
        
        if(systemTime > endTime)
        {
            // 活动过期
            self.applyView.applyLabel.enabled = NO;
            self.applyView.applyNum.enabled = NO;

        }
        else
        {
            self.applyView.applyLabel.enabled = YES;
            self.applyView.applyNum.enabled = YES;

        }
       
        if([self.applyView.applyLabel.text isEqualToString:@"我要报名"])
        {
            [self.applyView addTarget:self action:@selector(wantApplyAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if([self.applyView.applyLabel.text isEqualToString:@"取消报名"])
        {
            [self.applyView addTarget:self action:@selector(cancelApplyAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        

        
       

        
        [self.applyView initApplyView:point];
        [self.contentView addSubview:self.applyView];
    }
    else
    {
        [self.applyView removeFromSuperview];
    }

    height += PADDING;

}

- (void) setSecondCellData
{
    // 点赞状态
    if([self.neighborData.praiseType integerValue] == 1)
    {
        self.praiseImageView.image = [UIImage imageNamed:@"dianzan_2.png"];
    }
    else
    {
        self.praiseImageView.image = [UIImage imageNamed:@"dianzan.png"];
        
    }
    
    // 点赞个数
    if ([self.neighborData.praiseCount integerValue] != 0) {
        self.praiseLabel.text = [NSString stringWithFormat:@"%ld",[self.neighborData.praiseCount integerValue]];
    }
    else
    {
        self.praiseLabel.text = @"赞";
    }
    
    // 回复个数
    if ([self.neighborData.replyCount integerValue] != 0) {
        self.replyLabel.text = [NSString stringWithFormat:@"%ld",[self.neighborData.replyCount integerValue]];
    }
    else
    {
        self.replyLabel.text = @"回复";
    }
    

}

- (void) setOtherCellData
{
    self.personView.image = [UIImage imageNamed:self.neighborData.iconName ];
    
    CGRect personLableFrame;
    CGSize personLableLabelSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@",self.neighborData.accountName] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat personLabelW = personLableLabelSize.width;
    CGFloat personLabelH = personLableLabelSize.height;
    personLableFrame = CGRectMake(CGRectGetMaxX(self.personView.frame) +  PADDING, PADDING, personLabelW, personLabelH);
    self.personLable.frame = personLableFrame;
    self.personLable.text = [NSString stringWithFormat:@"%@",self.neighborData.accountName];
    
    
    CGRect replyTimeFrame;
    CGSize replyTimeSize = [StringMD5 sizeWithString:@"刚刚" font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    replyTimeFrame = CGRectMake(screenWidth - PADDING - replyTimeSize.width, PADDING, replyTimeSize.width, replyTimeSize.height);
    self.replyTimeLabel.text = @"刚刚";
    self.replyTimeLabel.frame = replyTimeFrame;

    
    self.repleyText.frame = CGRectMake(CGRectGetMinX(self.personLable.frame), CGRectGetMaxY(self.personLable.frame) + PADDING, self.replySize.width, self.replySize.height);
    self.repleyText.text = self.replyString;
    
    
    CGRect otherButtonFrame;
    CGSize otherButtonSize = [StringMD5 sizeWithString:@"回复" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    otherButtonFrame = CGRectMake(screenWidth - PADDING - otherButtonSize.width,CGRectGetMaxY(self.repleyText.frame) + 2 * PADDING, otherButtonSize.width, otherButtonSize.height);
    [self.otherButton setTitle:@"回复" forState:UIControlStateNormal];
    self.otherButton.frame = otherButtonFrame;
    

}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 点赞
- (void) touchDownPraise1
{
    self.praiseView.backgroundColor = [UIColor lightGrayColor];
}



- (void) touchCancelPraise1
{
    self.praiseView.backgroundColor = [UIColor whiteColor];
    NeighborData* neighborData = self.neighborData;
    
    
    if([neighborData.praiseType integerValue] == 0)
    {
        [self praiseNet:[neighborData.topicId integerValue] action:1];
        self.praiseImageView.image = [UIImage imageNamed:@"dianzan_2.png"];
        NSInteger num = [self.praiseLabel.text integerValue] + 1;
        self.praiseLabel.text = [NSString stringWithFormat:@"%ld",num];
        neighborData.praiseType = @"1";
        neighborData.praiseCount = [NSString stringWithFormat:@"%ld",num];
    }
    else
    {
        [self praiseNet:[neighborData.topicId integerValue] action:0];
        self.praiseImageView.image = [UIImage imageNamed:@"dianzan.png"];
        NSInteger num = [self.praiseLabel.text integerValue] - 1;
        
        if(num != 0)
        {
            self.praiseLabel.text = [NSString stringWithFormat:@"%ld",num];
            neighborData.praiseType = @"0";
            neighborData.praiseCount = [NSString stringWithFormat:@"%ld",num];
        }
        else
        {
            self.praiseLabel.text = @"赞";
            neighborData.praiseType = @"0";
            neighborData.praiseCount = @"0";
        }
        
    }

}


- (void) otherBtn:(UIButton*) button
{
    NSLog(@"other button");
}


// 人物头像点击放大
- (void) personImageView: (UITapGestureRecognizer*) recognizer
{
    [_delegate showCircularImageViewWithImage:self.personView.image];
}

// 个人头像点击放大
- (void) headImageView: (UITapGestureRecognizer*) recognizer
{
    [_delegate showCircularImageViewWithImage:self.iconView.image];
}

- (void)tapImageView: (UITapGestureRecognizer*) recognizer
{
    
    
    NSMutableArray* imageArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.neighborData.picturesArray count]; i++) {
        [imageArray addObject:[[self.neighborData.picturesArray objectAtIndex:i] valueForKey:@"resPath"]];
    }
    
    [_delegate showImageViewWithImageViews:imageArray byClickWhich:recognizer.view.tag];
}

- (void)deleteBtn
{
    [_delegate deleteTopic:1];
    NSLog(@"delete detail!");
}

// 点击我要报名
- (void)wantApplyAction:(id) sender
{
    ApplyDetailView* detailView = (ApplyDetailView*) sender;
    NSDictionary* activityDict = self.neighborData.infoArray[0];
    NSInteger activiId = [[activityDict valueForKey:@"activityId"] integerValue];
    if(detailView.applyLabel.enabled)
    {
        [_delegate applyDetail:activiId];
    }
    else
    {
        [MBProgressHUBTool textToast:self Tip:@"此活动已过期"];
        
    }
}

- (void)cancelApplyAction:(id) sender
{
    ApplyDetailView* detailView = (ApplyDetailView*) sender;
    if(detailView.applyLabel.enabled)
    {
        [_delegate cancelApply:0];
    }
    else
    {
        [MBProgressHUBTool textToast:self Tip:@"此活动已过期"];
        
    }
    
}

// 点赞网络请求
// topicId 帖子id
// type 点赞动作 1 点赞 0 取消点赞
- (void) praiseNet: (NSInteger)topicId action:(NSInteger)type
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ldtype%ld",userId,topicId,type]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"type" : [NSNumber numberWithInteger:type],
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"hitpraise",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:type:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"点赞网络请求:%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


@end
