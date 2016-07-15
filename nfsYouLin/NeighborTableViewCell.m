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

@implementation NeighborTableViewCell
{
    // 第一行 cellZero
    NSInteger _currentIndex;
    NSMutableArray* _buttons;
    
    
    
    BOOL _praiseState; // 点赞状态

//    // 评论cell
//    UIImageView* _praiseImageView;
//    UILabel* _praiseLabel;
//    NSInteger _praiseCount; // 点赞数量
//    
//    UILabel* _watchLabel;
//    NSInteger _watchCount; // 访问次数
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
            
            // 创建帖子内容
            UILabel* contentLabel = [[UILabel alloc] init];
            contentLabel.font = [UIFont fontWithName:@"AppleGothic" size:16];
//            contentLabel.font = [UIFont systemFontOfSize:16];
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

        }
        else if([reuseIdentifier isEqualToString:@"cellTitle"])
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
             self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.contentView.frame),39)];
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
            [self.replyView addSubview:replyLabel];
            
            [self.replyView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
             [lineView1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];

            [self.replyView addTarget:self action:@selector(touchDownReply) forControlEvents:UIControlEventTouchDown];
            [self.replyView addTarget:self action:@selector(touchCancelReply) forControlEvents:UIControlEventTouchUpInside ];
            [self.contentView addSubview:self.replyView];
            [self.contentView addSubview:lineView1];
            
            
            // 添加点赞
            _praiseState = NO;
            _praiseCount = 0;
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
    _praiseState = !_praiseState;
    if(_praiseState)
    {
        _praiseCount = 1;
        _praiseImageView.image = [UIImage imageNamed:@"dianzan_2.png"];
        _praiseLabel.text = [NSString stringWithFormat:@"%ld",_praiseCount];
    }
    else
    {
        _praiseCount = 0;
        _praiseLabel.text = @"赞";
        _praiseImageView.image = [UIImage imageNamed:@"dianzan.png"];
        
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
    _watchCount ++;
    _watchLabel.text = [NSString stringWithFormat:@"%ld",_watchCount];
}

- (void) settingData
{
    NSLog(@"setData");
    NeighborData* neighborData = self.neighborDataFrame.neighborData;
    NSURL* url = [NSURL URLWithString:neighborData.iconName];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageAllowInvalidSSLCertificates];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",neighborData.titleName];
    
    self.timeInterval.text = [StringMD5 calculateTimeInternal:[neighborData.systemTime integerValue] / 1000 old:[neighborData.topicTime integerValue] / 1000];
    
     self.accountInfoLabel.text = [NSString stringWithFormat:@"%@", neighborData.accountName];
    
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[neighborData.publishText dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
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
        NSURL* url = [NSURL URLWithString:[[neighborData.picturesArray objectAtIndex:i] valueForKey:@"resPath"]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageAllowInvalidSSLCertificates];
    }
    // 根据senderId 添加打招呼按钮
    NSLog(@"senderId = %@",neighborData.senderId);
    if([neighborData.senderId integerValue] == 1)
    {
        [self.contentView addSubview:self.hiBtn];
    }
    else
    {
        [self.hiBtn removeFromSuperview];
    }
    
}

- (void) settingDataFrame
{
    NSLog(@"setDataFrame");
    self.iconView.frame = self.neighborDataFrame.iconFrame;
    self.titleLabel.frame = self.neighborDataFrame.titleFrame;
    self.accountInfoLabel.frame = self.neighborDataFrame.accountInfoFrame;
    self.hiBtn.frame = self.neighborDataFrame.hiFrame;

    self.timeInterval.frame = self.neighborDataFrame.intervalFrame;

    self.contentLabel.frame = self.neighborDataFrame.textFrame;
    
    self.readButton.frame = self.neighborDataFrame.readFrame;
    
    if(self.neighborDataFrame.textCount > 4)
    {
        NSLog(@"共 %ld 行", self.neighborDataFrame.textCount);
        self.readButton.frame = self.neighborDataFrame.readFrame;
        [self.contentView addSubview:self.readButton];
    }
    
//    if([self.neighborDataFrame.neighborData.senderId integerValue] == 1)
//    {
//    }
    
    
    for (int i = 0; i < [self.neighborDataFrame.picturesFrame count]; i++)
    {
        ((UIImageView *)[self.picturesView objectAtIndex:i]).frame = [((NSValue *)[self.neighborDataFrame.picturesFrame objectAtIndex:i]) CGRectValue];
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

- (void)hiAction:(id)sender
{
    NSLog(@"hiAction");
    [_delegate sayHi:self.sectionNum];
}

@end
