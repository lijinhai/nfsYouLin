//
//  NeighborTableViewCell.m
//  Neighbor2
//
//  Created by Macx on 16/5/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "NeighborTableViewCell.h"
#import "NDetailTableViewController.h"
#import "UIImageView+WebCache.h"
#import "StringMD5.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"


@implementation NeighborTableViewCell
{
    // 第一行 cellZero
    NSInteger _currentIndex;
    NSMutableArray* _buttons;
    
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
    if(self)
    {
        if([reuseIdentifier isEqualToString:@"cellOther"])
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            // 创建头像
            UIImageView* iconView = [[UIImageView alloc] init];
            iconView.layer.cornerRadius = 30;
            iconView.layer.masksToBounds = YES;
            [self.contentView addSubview:iconView];
            self.iconView = iconView;
            
            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageView:)];
            self.iconView.userInteractionEnabled = YES;
            [self.iconView addGestureRecognizer:tapGesture];

            // 创建时间间隔
            UILabel* timeInterval = [[UILabel alloc] init];
            timeInterval.textAlignment = NSTextAlignmentLeft;
            timeInterval.font = [UIFont systemFontOfSize:10];
            timeInterval.enabled = NO;
            [self.contentView addSubview:timeInterval];
            self.timeInterval = timeInterval;

            // 创建打招呼按钮
            UIButton* hiBtn = [[UIButton alloc] init];
            [hiBtn.layer setBorderWidth:1.0];
            hiBtn.layer.borderColor=[UIColor grayColor].CGColor;
            [hiBtn setTitle:@"打招呼" forState:UIControlStateNormal];
            hiBtn.titleLabel.font = [UIFont systemFontOfSize:8];
            hiBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter | UIControlContentHorizontalAlignmentCenter;

            [hiBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1] forState:UIControlStateNormal];
//            [self.contentView addSubview:hiBtn];
            [hiBtn addTarget:self action:@selector(hiAction:) forControlEvents:UIControlEventTouchDown];
            self.hiBtn = hiBtn;

            
            // 创建帖子标题 #帖子类别# + 帖子名称
            
            UILabel* titleLabel = [[UILabel alloc] init];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            titleLabel.numberOfLines = 0;
            [self.contentView addSubview:titleLabel];
            self.titleLabel = titleLabel;

            // 创建帖子用户信息 用户名@地址
            
            UILabel* accountInfoLabel = [[UILabel alloc] init];
            accountInfoLabel.textAlignment = NSTextAlignmentLeft;
            accountInfoLabel.font = [UIFont systemFontOfSize:15];
//            accountInfoLabel.font = [UIFont fontWithName:@"AppleGothic" size:15];
            accountInfoLabel.enabled = NO;
            [self.contentView addSubview:accountInfoLabel];
            self.accountInfoLabel = accountInfoLabel;
            
            // 创建活动过期图片
            UIImageView* pastImageView = [[UIImageView alloc] init];
            pastImageView.image = [UIImage imageNamed:@"overline.png"];
            self.pastImageView = pastImageView;
//            self.pastImageView.backgroundColor = [UIColor redColor];
            
            // 创建帖子内容
            UILabel* contentLabel = [[UILabel alloc] init];
            contentLabel.lineBreakMode = NSLineBreakByWordWrapping;     //去掉省略号
            contentLabel.numberOfLines = 4;
            [self.contentView addSubview:contentLabel];
            self.contentLabel = contentLabel;
            
            // 创建查看全文按钮 不添加
            UIButton* readButton = [[UIButton alloc] init];
            [readButton setTitle:@"查看全文" forState:UIControlStateNormal];
            [readButton setTitleColor:[UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:0 / 255.0 alpha:1] forState:UIControlStateNormal];
            readButton.backgroundColor = [UIColor clearColor];
            readButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            self.readButton = readButton;
            [self.readButton addTarget:self action:@selector(readBtn) forControlEvents:UIControlEventTouchDown];
            
            // 创建报名详情
            self.applyView = [[ApplyDetailView alloc] init];
            
            // 删除按钮
            UIButton* deleteButton = [[UIButton alloc] init];
            [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            
            [deleteButton setTitleColor:[UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:0 / 255.0 alpha:1] forState:UIControlStateNormal];
            deleteButton.backgroundColor = [UIColor clearColor];
            deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            self.deleteButton = deleteButton;
            [self.deleteButton addTarget:self action:@selector(deleteBtn) forControlEvents:UIControlEventTouchDown];
            
            

        }
        else if([reuseIdentifier isEqualToString:@"cellTitle"])
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
             self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.contentView.frame),50)];
            self.scrollView.backgroundColor = [UIColor whiteColor];
            _buttons = [NSMutableArray array];
            _currentIndex = 1;
            UIButton* button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.scrollView.frame) / 4, 60, CGRectGetHeight(self.scrollView.frame) / 2)];
            button1.layer.cornerRadius = button1.frame.size.height / 2;
            button1.layer.masksToBounds = YES;
            button1.tag = 1;
            [button1 setTitle:@"全部" forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchDown];
            [self.scrollView addSubview:button1];
            [_buttons addObject:button1];
            
            UIButton* button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.origin.x + button1.frame.size.width + 10, CGRectGetHeight(self.scrollView.frame) / 4, 60, CGRectGetHeight(self.scrollView.frame) / 2)];
            button2.layer.cornerRadius = button2.frame.size.height / 2;
            button2.layer.masksToBounds = YES;
            button2.tag = 2;
            [button2 setTitle:@"话题" forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchDown];
            [_buttons addObject:button2];
            [self.scrollView addSubview:button2];
            
            
            UIButton* button3 = [[UIButton alloc] initWithFrame:CGRectMake(button2.frame.origin.x + button2.frame.size.width + 10, CGRectGetHeight(self.scrollView.frame) / 4, 60, CGRectGetHeight(self.scrollView.frame) / 2)];
            button3.layer.cornerRadius = button3.frame.size.height / 2;
            button3.layer.masksToBounds = YES;
            button3.tag = 3;
            [button3 setTitle:@"活动" forState:UIControlStateNormal];
            [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button3 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchDown];
            [_buttons addObject:button3];
            [self.scrollView addSubview:button3];
            
            
            UIButton* button4 = [[UIButton alloc] initWithFrame:CGRectMake(button3.frame.origin.x + button3.frame.size.width + 10, CGRectGetHeight(self.scrollView.frame) / 4, 60, CGRectGetHeight(self.scrollView.frame) / 2)];
            button4.layer.cornerRadius = button4.frame.size.height / 2;
            button4.layer.masksToBounds = YES;
            button4.tag = 4;
            [button4 setTitle:@"公告" forState:UIControlStateNormal];
            [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button4 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchDown];
            [_buttons addObject:button4];
            [self.scrollView addSubview:button4];
            
            
            UIButton* button5 = [[UIButton alloc] initWithFrame:CGRectMake(button4.frame.origin.x + button4.frame.size.width + 10, CGRectGetHeight(self.scrollView.frame) / 4, 60, CGRectGetHeight(self.scrollView.frame) / 2)];
            button5.layer.cornerRadius = button4.frame.size.height / 2;
            button5.layer.masksToBounds = YES;
            button5.tag = 5;
            [button5 setTitle:@"建议" forState:UIControlStateNormal];
            [button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button5 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchDown];
            [_buttons addObject:button5];
            [self.scrollView addSubview:button5];
            
            UIButton* button6 = [[UIButton alloc] initWithFrame:CGRectMake(button5.frame.origin.x + button5.frame.size.width + 10, CGRectGetHeight(self.scrollView.frame) / 4, 80, CGRectGetHeight(self.scrollView.frame) / 2)];
            button6.layer.cornerRadius = button6.frame.size.height / 2;
            button6.layer.masksToBounds = YES;
            button6.tag = 6;
            [button6 setTitle:@"闲品会" forState:UIControlStateNormal];
            [button6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button6 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchDown];
            [_buttons addObject:button6];
            [self.scrollView addSubview:button6];
            
            
            
            self.scrollView.contentSize = CGSizeMake(button6.frame.origin.x + button6.frame.size.width, CGRectGetHeight(self.scrollView.frame));
            self.scrollView.bounces = NO;
            [_scrollView setShowsHorizontalScrollIndicator:NO];
            self.scrollView.delegate = self;
            [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [self.contentView addSubview:self.scrollView];
            
            // 添加表格底边框
            UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.scrollView.frame) - 1, CGRectGetWidth(self.contentView.frame), 1)];
            separatorView.backgroundColor = [UIColor blackColor];
             [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [self.contentView addSubview:separatorView];

        }
        else if([reuseIdentifier isEqualToString:@"cellAnother"])
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            // 添加回复
            self.replyView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width / 3, 40)];
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

            [self.replyView addTarget:self action:@selector(touchDownReply) forControlEvents:UIControlEventTouchDown];
            [self.replyView addTarget:self action:@selector(touchCancelReply) forControlEvents:UIControlEventTouchUpInside ];
            [self.contentView addSubview:self.replyView];
            [self.contentView addSubview:lineView1];
            
            
            // 添加点赞
            self.praiseView = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame), 0, self.contentView.frame.size.width / 3, 40)];
            self.praiseView.backgroundColor = [UIColor whiteColor];

            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.praiseView.frame), 10.0f, 1.0f, 20)];
            [lineView2 setBackgroundColor:[UIColor blackColor]];

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
            [lineView2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];

            [self.praiseView addTarget:self action:@selector(touchDownPraise) forControlEvents:UIControlEventTouchDown];
            [self.praiseView addTarget:self action:@selector(touchCancelPraise) forControlEvents:UIControlEventTouchUpInside ];
            
            [self.contentView addSubview:self.praiseView];
            [self.contentView addSubview:lineView2];

            
            // 添加查看
            self.watchView = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame), 0, self.contentView.frame.size.width / 3, 40)];
            self.watchView.backgroundColor = [UIColor whiteColor];
            
            UIImageView *watchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.watchView.frame.size.width / 3 - 4, 10, 20, 20)];
            watchImageView.image = [UIImage imageNamed:@"browse.png"];
            [watchImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            [self.watchView addSubview:watchImageView];
            
            _watchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(watchImageView.frame) + 2, 10, 30, 20)];
            _watchLabel.tag = 3;
            _watchLabel.text = @"0";
            _watchLabel.font = [UIFont systemFontOfSize:15];
            _watchLabel.textAlignment = NSTextAlignmentLeft;
            [_watchLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            [self.watchView addSubview:_watchLabel];
            [self.watchView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
            
            [self.watchView addTarget:self action:@selector(touchDownWatch) forControlEvents:UIControlEventTouchDown];
            [self.watchView addTarget:self action:@selector(touchCancelWatch) forControlEvents:UIControlEventTouchUpInside ];
            
            [self.contentView addSubview:self.watchView];

            
            // 添加表格底边框
            UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, CGRectGetWidth(self.contentView.frame), 1)];
            separatorView.backgroundColor = [UIColor blackColor];
                        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [self.contentView addSubview:separatorView];

        }
        
    }
    return self;
}


- (void)btn: (UIButton*) sender
{
    if(sender.tag != _currentIndex)
    {
        UIButton* currentButton = _buttons[_currentIndex - 1];
        currentButton.backgroundColor = [UIColor clearColor];
    }
    _currentIndex = sender.tag;
    sender.backgroundColor = [UIColor grayColor];
    NSLog(@"%@",sender.titleLabel.text);
    [_delegate reloadShowByTitle:sender.titleLabel.text];
}

// 点击回复
- (void) touchDownReply
{
    [_delegate readTotalInformation:self.sectionNum];
    self.replyView.backgroundColor = [UIColor lightGrayColor];

}

- (void) touchCancelReply
{
    self.replyView.backgroundColor = [UIColor whiteColor];

}

// 点赞
- (void) touchDownPraise
{
    self.praiseView.backgroundColor = [UIColor lightGrayColor];
}

- (void) touchCancelPraise
{
    self.praiseView.backgroundColor = [UIColor whiteColor];
    NeighborData* neighborData = self.replyData;
    
    
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


//点击查看
- (void) touchDownWatch
{
    
    
    [_delegate readTotalInformation:self.sectionNum];
    self.watchView.backgroundColor = [UIColor lightGrayColor];

}

- (void) touchCancelWatch
{
    self.watchView.backgroundColor = [UIColor whiteColor];
}

// 设置帖子数据
- (void) settingData
{
    NeighborData* neighborData = self.neighborDataFrame.neighborData;
    NSURL* url = [NSURL URLWithString:neighborData.iconName];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",neighborData.titleName];
    
    self.timeInterval.text = [StringMD5 calculateTimeInternal:[neighborData.systemTime integerValue] / 1000 old:[neighborData.topicTime integerValue] / 1000];
    
     self.accountInfoLabel.text = [NSString stringWithFormat:@"%@", neighborData.accountName];
    
    // 设置UILabel 行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];

    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[neighborData.publishText dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [attrStr length])];
    
    self.contentLabel.text = neighborData.publishText;
    self.contentLabel.attributedText = attrStr;
    
    //创建配图
    for (int i = 0; i < [neighborData.picturesArray count]; i++)
    {
        UIImageView *pictureView = [[UIImageView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureView addGestureRecognizer:tap];
        pictureView.tag = imageTag + i;
        pictureView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:pictureView];
        [self.picturesView addObject:pictureView];
        UIImageView* imageView = ((UIImageView *)[self.picturesView objectAtIndex:i]);
       
        NSString* str =[[neighborData.picturesArray objectAtIndex:i] valueForKey:@"resPath"];
        NSArray* strArray = [str componentsSeparatedByString:@"/"];
        NSString* imageName = [NSString stringWithFormat:@"0%@",[strArray lastObject]];
        
        NSString* urlString = [str stringByReplacingOccurrencesOfString:[strArray lastObject] withString:imageName];
        
        NSURL* url = [NSURL URLWithString:urlString];
        
        
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
    }
}


// 设置帖子数据和控件位置
- (void) settingDataFrame
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSDictionary* activityDict = self.neighborDataFrame.neighborData.infoArray[0];

    self.iconView.frame = self.neighborDataFrame.iconFrame;
    self.titleLabel.frame = self.neighborDataFrame.titleFrame;
    self.accountInfoLabel.frame = self.neighborDataFrame.accountInfoFrame;
    self.hiBtn.frame = self.neighborDataFrame.hiFrame;
    
    self.timeInterval.frame = self.neighborDataFrame.intervalFrame;

    self.contentLabel.frame = self.neighborDataFrame.textFrame;

    self.readButton.frame = self.neighborDataFrame.readFrame;
    
    
    if([self.neighborDataFrame.neighborData.topicCategory integerValue] == 1)
    {
        self.applyView.applyNum.text = [NSString stringWithFormat:@"%ld",[[activityDict valueForKey:@"enrollTotal"] integerValue]];
        NSString *enrollFlag = [activityDict valueForKey:@"enrollFlag"];
        
        // 创建报名详情
        if([self.neighborDataFrame.neighborData.senderId integerValue] == [userId integerValue])
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

        // 创建活动过期图片
        NSInteger endTime = [[activityDict valueForKey:@"endTime"] integerValue];
        NSInteger systemTime = [self.neighborDataFrame.neighborData.systemTime integerValue];
        if(systemTime > endTime)
        {
            // 活动过期
            self.pastImageView.frame = self.neighborDataFrame.pastIVFrame;
            [self.contentView addSubview:self.pastImageView];
            
            self.applyView.applyLabel.enabled = NO;
            self.applyView.applyNum.enabled = NO;
        }
        else
        {
            self.applyView.applyLabel.enabled = YES;
            self.applyView.applyNum.enabled = YES;

            [self.pastImageView removeFromSuperview];
        }
        
        if([self.applyView.applyLabel.text isEqualToString:@"我要报名"])
        {
             [self.applyView removeTarget:self action:@selector(cancelApplyAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.applyView addTarget:self action:@selector(wantApplyAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if([self.applyView.applyLabel.text isEqualToString:@"取消报名"])
        {
            [self.applyView removeTarget:self action:@selector(wantApplyAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.applyView addTarget:self action:@selector(cancelApplyAction:) forControlEvents:UIControlEventTouchUpInside];
        }

        
        CGPoint point = self.neighborDataFrame.applyPoint;
        [self.applyView initApplyView:point];
        [self.contentView addSubview:self.applyView];
        
    }
    else
    {
        [self.applyView removeFromSuperview];
        [self.pastImageView removeFromSuperview];

    }
   
    

    
    if([self.neighborDataFrame.neighborData.senderId integerValue] == [userId integerValue])
    {
        // 添加删除按钮
        [self.contentView addSubview:self.deleteButton];
    }
    else
    {
        [self.deleteButton removeFromSuperview];

    }

    
    self.deleteButton.frame = self.neighborDataFrame.deleteFrame;
    
    if(self.neighborDataFrame.textCount >= 4)
    {
        self.readButton.frame = self.neighborDataFrame.readFrame;
        [self.contentView addSubview:self.readButton];
    }
    

    // 根据senderId 添加打招呼按钮
    
    if([self.neighborDataFrame.neighborData.senderId integerValue] == 1)
    {
        if([self.neighborDataFrame.neighborData.cacheKey integerValue] != [userId integerValue])
        {
            if([[activityDict valueForKey:@"sayHelloStatus"] integerValue] == 0)
            {
                [self.contentView addSubview:self.hiBtn];
            }

        }
    }
    else
    {
        [self.hiBtn removeFromSuperview];
    }

    
    for (int i = 0; i < [self.neighborDataFrame.picturesFrame count]; i++)
    {
        ((UIImageView *)[self.picturesView objectAtIndex:i]).frame = [((NSValue *)[self.neighborDataFrame.picturesFrame objectAtIndex:i]) CGRectValue];
    }

    
}

// 设置评论数据
- (void) setReplyCellData
{
    // 点赞状态
    if([self.replyData.praiseType integerValue] == 1)
    {
        self.praiseImageView.image = [UIImage imageNamed:@"dianzan_2.png"];
    }
    else
    {
        self.praiseImageView.image = [UIImage imageNamed:@"dianzan.png"];
        
    }
    
    // 点赞个数
    if ([self.replyData.praiseCount integerValue] != 0) {
        self.praiseLabel.text = [NSString stringWithFormat:@"%ld",[self.replyData.praiseCount integerValue]];
    }
    else
    {
        self.praiseLabel.text = @"赞";
    }
    
    // 浏览次数
    if ([self.replyData.viewCount integerValue] != 0) {
        self.watchLabel.text = [NSString stringWithFormat:@"%ld",[self.replyData.viewCount integerValue]];
        
    }
    else
    {
        self.watchLabel.text = @"";
    }
    
    // 回复个数
    if ([self.replyData.replyCount integerValue] != 0) {
        self.replyLabel.text = [NSString stringWithFormat:@"%ld",[self.replyData.replyCount integerValue]];
    }
    else
    {
        self.replyLabel.text = @"回复";
    }

}

//防止图片重叠
-(void)removeOldPictures
{
    for(int i = 0;i < [self.picturesView count];i++)
    {
        UIImageView *pictureView = [self.picturesView objectAtIndex:i];
        if (pictureView.superview) {
            [pictureView removeFromSuperview];
        }
    }
    [self.picturesView removeAllObjects];
}

- (void) setNeighborDataFrame:(NeighborDataFrame *)neighborDataFrame
{
    _neighborDataFrame = neighborDataFrame;
    [self removeOldPictures];
    [self settingData];
    [self settingDataFrame];
}

- (void) setReplyData:(NeighborData *)replyData
{
    _replyData = replyData;
    [self setReplyCellData];
}


-(NSMutableArray *)picturesView
{
    if (!_picturesView)
    {
        _picturesView = [[NSMutableArray alloc]init];
    }
    return _picturesView;
    
}

- (void) headImageView: (UITapGestureRecognizer*) recognizer
{
    [_delegate showCircularImageViewWithImage:self.iconView.image];
}

- (void)tapImageView: (UITapGestureRecognizer*) recognizer
{
    NSMutableArray* imageArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_neighborDataFrame.neighborData.picturesArray count]; i++) {
        [imageArray addObject:[[_neighborDataFrame.neighborData.picturesArray objectAtIndex:i] valueForKey:@"resPath"]];
    }
    [_delegate showImageViewWithImageViews:imageArray byClickWhich:recognizer.view.tag];
}

// 点击全文按钮
- (void)readBtn
{
    [_delegate readTotalInformation:self.sectionNum];

}

// 点击我要报名
- (void)wantApplyAction:(id) sender
{
    ApplyDetailView* detailView = (ApplyDetailView*) sender;
    if(detailView.applyLabel.enabled)
    {
        [_delegate applyDetail:self.sectionNum];
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
        [_delegate cancelApply:self.sectionNum];
    }
    else
    {
        [MBProgressHUBTool textToast:self Tip:@"此活动已过期"];
        
    }
    
}


// 点击删除
- (void) deleteBtn
{
    NSLog(@"删除!");
    [_delegate deleteTopic:self.sectionNum];

    
}

- (void)hiAction:(id)sender
{
    NSLog(@"hiAction");
    [_delegate sayHi:self.sectionNum];
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
