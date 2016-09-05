//
//  NeighborDetailTVC.m
//  nfsYouLin
//
//  Created by Macx on 16/6/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NeighborDetailTVC.h"
#import "NDetailTableViewCell.h"
#import "StringMD5.h"
#import "DialogView.h"
#import "AFHTTPSessionManager.h"
#import "MJRefresh.h"
#import "MBProgressHUBTool.h"
#import "ApplyDetailTVC.h"
#import "BackgroundView.h"
#import "CreateTopicVC.h"
#import "CreateActivityVC.h"

@interface NeighborDetailTVC ()

@end

@implementation NeighborDetailTVC
{
    NSMutableArray* _replyText;
    UIView* _footerView;
    CGFloat _cellHeight;        // 第二个表格行高度
    NSMutableArray* _cellOtherHeight;   // 回复表格行高度
    UIView* backgroundView;
    DialogView* dialogView;
    UIActivityIndicatorView* indicator;
    UIView* indicatorBV;
    
    NSMutableArray* replyArr;
    UIPanGestureRecognizer* _panGesture;
    NSInteger replyOtherId;
    
    DetailListView* listView;
    BackgroundView* bgView;

}

- (id) init
{
    self = [super init];
    if(self)
    {
        replyArr = [[NSMutableArray alloc] init];
        _cellOtherHeight = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_chatToolbar)
    {
        [self.parentViewController.view addSubview:_chatToolbar];
    }
    else
    {
        [self initInputView];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"circle_more.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    [rightBtn addTarget:self action:@selector(handlePan:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    _replyText = [[NSMutableArray alloc] init];
    _cellHeight = [self heightOfScondRow];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
    self.imagePicker.delegate = self;
    
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;
    
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44)];
    _footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = _footerView;
    self.tableView.separatorColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];
    _panGesture = self.tableView.panGestureRecognizer;
    [_panGesture addTarget:self action:@selector(handlePan:)];
    replyOtherId = 0;
    
    indicatorBV = [[UIView alloc] initWithFrame:CGRectMake(0, _cellHeight + 100, CGRectGetWidth(self.view.frame), 100) ];
//    indicatorBV.backgroundColor = [UIColor blueColor];
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 - 25, 0, 50, 50)];
    indicator.hidesWhenStopped = YES;
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.color =  [UIColor grayColor];
    [indicatorBV addSubview:indicator];
    [indicator startAnimating];
    [self.view addSubview:indicatorBV];
    [self initInputView];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger senderId = [self.neighborData.senderId integerValue];
    NSInteger category = [self.neighborData.objectType integerValue];
    NSInteger caategoryType = [self.neighborData.topicCategoryType integerValue];
    NSInteger userId = [[defaults stringForKey:@"userId"] integerValue];
    NSMutableArray* nameArray;
    
    if(senderId == 1)
    {
        nameArray = [[NSMutableArray alloc] initWithObjects:@"收藏", nil];
    }
    else if (senderId == userId)
    {
        if(category != 4)
        {
            nameArray = [[NSMutableArray alloc] initWithObjects:@"修改",@"收藏", nil];
        }
        else
        {
            nameArray = [[NSMutableArray alloc] initWithObjects:@"删除",@"收藏", nil];
        }
    }
    else
    {
        if(caategoryType != 2)
        {
            nameArray = [[NSMutableArray alloc] initWithObjects:@"私信",@"收藏", nil];
        }
        else
        {
            nameArray = [[NSMutableArray alloc] initWithObjects:@"私信",@"举报",@"收藏", nil];
        }
    }
    
    
    listView = [[DetailListView alloc] initWithArray:CGRectGetMaxY(self.navigationController.navigationBar.frame) array:nameArray];
    listView.delegate = self;
    if([self.neighborData.collectStatus integerValue] == 3)
    {
        [listView setCollectStatus:YES];
    }

    bgView = [[BackgroundView alloc] initWithFrame:self.parentViewController.view.frame view:listView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CGFloat height;
    if(row == 0 || row == 2)
    {
        height = 44;
    }
    else if(indexPath.row == 1)
    {
        height = _cellHeight;
    }
    else
    {
        height = [[_cellOtherHeight objectAtIndex:row - 3] floatValue];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    CGFloat h = self.tableView.contentSize.height;
    CGFloat H = CGRectGetHeight(self.view.frame);
    if(h <= H)
    {
        self.tableView.contentSize = CGSizeMake(CGRectGetWidth(self.tableView.frame), H + 5);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [replyArr count] + 3;
//    return [_replyText count] + 3;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellZero = @"Zero";
    NSString* cellOne = @"One";
    NSString* cellTwo = @"Two";
    NSString* cellOther = @"Other";
    NDetailTableViewCell* cell;
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellZero];
        if(cell == nil)
        {
            cell = [[NDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellZero];
        }
           }
    else if(indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellOne];
        if(cell == nil)
        {
            cell = [[NDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOne];
        }
    }
    else if(indexPath.row == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellTwo];
        if(cell == nil)
        {
            cell = [[NDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellOther];
        if(cell == nil)
        {
            cell = [[NDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOther];
        }
        else
        {
//            while ([cell.contentView.subviews lastObject] != nil)
//            {
//                 //删除并进行重新分配
//                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
//            }
//            for(UIView *view in cell.contentView.subviews) {
//                [view removeFromSuperview];
//            }
//
        }
        
        NSDictionary* dict = replyArr[indexPath.row - 3];
        [cell setOtherCellData:dict];
    }
    
    cell.rowNum = indexPath.row;
    cell.delegate = self;
    cell.neighborData = self.neighborData;

    return cell;
}

- (void) initInputView
{
    //初始化页面
    CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
    EMChatToolbarType barType = EMChatToolbarTypeChat;
    self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.parentViewController.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:barType];
    self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    //初始化手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
//    [self.view addGestureRecognizer:tap];

}

- (void)setChatToolbar:(EaseChatToolbar *)chatToolbar
{
    [_chatToolbar removeFromSuperview];
    NSArray* rightItems = [chatToolbar inputViewRightItems];
    EaseChatToolbarItem *moreItem = rightItems[0];
    
    [chatToolbar setInputViewRightItems:@[moreItem]];
    _chatToolbar = chatToolbar;
    
    if (_chatToolbar) {
        [self.parentViewController.view addSubview:_chatToolbar];
    }
    
    if ([chatToolbar isKindOfClass:[EaseChatToolbar class]]) {
        [(EaseChatToolbar *)self.chatToolbar setDelegate:self];
        self.chatBarMoreView = (EaseChatBarMoreView*)[(EaseChatToolbar *)self.chatToolbar moreView];
        [self.chatBarMoreView removeItematIndex:4];
        [self.chatBarMoreView removeItematIndex:3];
        self.faceView = (EaseFaceView*)[(EaseChatToolbar *)self.chatToolbar faceView];
        self.recordView = (EaseRecordView*)[(EaseChatToolbar *)self.chatToolbar recordView];
    }
}


- (void)setNeighborData:(NeighborData *)neighborData
{
    _neighborData = neighborData;
}



//// 点击背景隐藏
//-(void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer
//{
//    NSLog(@"点击背景键盘");
//    if (tapRecognizer.state == UIGestureRecognizerStateEnded)
//    {
//        [self.chatToolbar endEditing:YES];
//    }
//   
//}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.chatToolbar removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击隐藏键盘");
    [self.chatToolbar endEditing:YES];
    

}

// 计算回复表格行高度
// remark @标识
- (CGFloat) heightOfOtherRow: (NSString*)replyText Remark:(BOOL) remark Type:(NSString*)type
{
    CGFloat cellHeight = 5 * PADDING + 25;
    if(![type isKindOfClass:[NSNumber class]])
    {
        if([type isEqualToString:@"image"])
        {
            cellHeight += 100;
        }
        else if([type isEqualToString:@"video"])
        {
            cellHeight += 30;
        }
        
    }
    else if(![replyText isEqual:[NSNull null]])
    {
        cellHeight += [StringMD5 sizeWithString:replyText font:[UIFont fontWithName:@"AppleGothic" size:16] maxSize:CGSizeMake(screenWidth - 6 * PADDING, MAXFLOAT)].height;
    }

    cellHeight +=  [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@",@"嗯嗯"] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
  
    if(remark)
    {
        cellHeight += [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@",@"嗯嗯"] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    }

    return cellHeight;
}

// 计算第二个表格行高度
- (CGFloat) heightOfScondRow
{
    CGFloat cellHeight = 4 * PADDING;
    cellHeight += [StringMD5 sizeWithString:[NSString stringWithFormat:@"标题:%@",self.neighborData.titleName] font:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    
    cellHeight += [StringMD5 sizeWithString:self.neighborData.publishText font:[UIFont fontWithName:@"AppleGothic" size:16] maxSize:CGSizeMake(screenWidth - 2 * PADDING, MAXFLOAT)].height;
    NSInteger count = self.neighborData.picturesArray.count;
    CGFloat pictureH = (screenWidth - PADDING ) / 3 - (PADDING / 2);
    if(0 < count && self.neighborData.picturesArray.count <= 3)
    {
        cellHeight += pictureH;
    }
    else if(count > 3 && count <= 6)
    {
        cellHeight += 2 * pictureH + PADDING / 2;
    }
    else if(count > 6 && count <= 9)
    {
        cellHeight += 3 * pictureH + PADDING;
    }
    
    cellHeight += 2 * PADDING;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    if([self.neighborData.senderId integerValue] == [userId integerValue])
    {
        cellHeight += [StringMD5 sizeWithString:@"删除" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height + PADDING;

    }

    if([self.neighborData.topicCategory integerValue] == 1)
    {
        cellHeight += 30;
    }
    
    cellHeight += PADDING;

    
    return cellHeight;
}


// 回复事件回调
- (void) replyEvent:(NSInteger)rowNum btnText:(NSString *)btnText
{
    NSDictionary* dict = replyArr[rowNum - 3];
    if([btnText isEqualToString:@"回复"])
    {
        EaseChatToolbar *chatToolbar = (EaseChatToolbar*)self.chatToolbar;
        [chatToolbar.inputTextView becomeFirstResponder];
        chatToolbar.inputTextView.text = [NSString stringWithFormat:@"回复 %@:",        [dict valueForKey:@"senderName"]];
        replyOtherId = [[dict valueForKey:@"senderId"] integerValue];
    }
    else
    {
        NSLog(@"delete reply");
        DialogView* deleteView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"common"];
        [self.parentViewController.view addSubview:backgroundView];
        [self.parentViewController.view addSubview:deleteView];
        
        deleteView.titleL.text = @"确定要删除该回复嘛？";
        dialogView = deleteView;
        UIButton* okBtn = deleteView.OKbtn;
        okBtn.tag = rowNum;
        [okBtn addTarget:self action:@selector(deleteOkReply:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* cancelBtn = deleteView.NOBtn;
        [cancelBtn addTarget:self action:@selector(deleteNoReply:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}


#pragma mark -DetailListViewDelegate
-(void) seletedAction:(NSString *)action
{
    if([action isEqualToString:@"收藏"])
    {
        [self collectTopicNet];
    }
    else if([action isEqualToString:@"取消收藏"])
    {
        [self delCollectTopicNet];
    }
    else if([action isEqualToString:@"修改"])
    {
        NSInteger type = [self.neighborData.objectType integerValue];
        switch (type) {
            // 话题
            case 0:
            {
                CreateTopicVC* topicVC = [[CreateTopicVC alloc] init];
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"update",@"option",
                                             self.neighborData.titleName, @"title",
                                             self.neighborData.publishText, @"content",
                                             self.neighborData.forumName, @"forumName",
                                             self.neighborData.topicId, @"topicId",
                                             self.neighborDF , @"dataFrame",
                                             nil];
                [topicVC setTopicInfo:dict];
                [self.navigationController pushViewController:topicVC animated:YES];
                break;
            }
            // 活动
            case 1:
            {
                CreateActivityVC* activityVC = [[CreateActivityVC alloc] init];
                NSDictionary* objectDict = self.neighborData.objectData[0];
                NSString* title = [self.neighborData.titleName substringFromIndex:4];
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"update",@"option",
                                             title, @"title",
                                             [objectDict valueForKey:@"content"], @"content",
                                             self.neighborData.forumName, @"forumName",
                                             self.neighborData.topicId, @"topicId",
                                             [objectDict valueForKey:@"location"], @"location",
                                             [objectDict valueForKey:@"startTime"], @"startTime",
                                             [objectDict valueForKey:@"endTime"], @"endTime",
                                             self.neighborDF , @"dataFrame",
                                             nil];
                [activityVC setTopicInfo:dict];
                [self.navigationController pushViewController:activityVC animated:YES];
                break;
            }
            // 物品置换
            case 4:
            {
                break;
            }
            default:
                break;
        }
        
    }
    else if([action isEqualToString:@"私信"])
    {
        
    }
    else if([action isEqualToString:@"举报"])
    {
        
    }

}


#pragma mark - cellDelegate
- (void)showRectImageViewWithImage:(UIImage *)image
{
    self.tableView.scrollEnabled = NO;
    UIView* addView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    addView.alpha = 1.0;
    [self.parentViewController.view addSubview:addView];
    ShowImageView* showImage = [[ShowImageView alloc] initWithFrame:self.view.frame rectImage:image];
    [showImage show:addView didFinish:^()
     {
         [UIView animateWithDuration:0.5f animations:^{
             
             showImage.alpha = 0.0f;
             addView.alpha = 0.0f;
             
         } completion:^(BOOL finished) {
             self.tableView.scrollEnabled = YES;
             [showImage removeFromSuperview];
             [addView removeFromSuperview];
         }];
         
     }];

}

// 	圆形头像点击事件回调
- (void)showCircularImageViewWithImage:(UIImage*) image
{
    self.tableView.scrollEnabled = NO;
    //    UIView* addView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView* addView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    addView.alpha = 1.0;
    [self.parentViewController.view addSubview:addView];
    ShowImageView* showImage = [[ShowImageView alloc] initWithFrame:self.view.frame circularImage:image];
    [showImage show:addView didFinish:^()
     {
         [UIView animateWithDuration:0.5f animations:^{
             
             showImage.alpha = 0.0f;
             addView.alpha = 0.0f;
             
         } completion:^(BOOL finished) {
             self.tableView.scrollEnabled = YES;
             [showImage removeFromSuperview];
             [addView removeFromSuperview];
         }];
         
     }];
    
}

// 图片点击回调事件
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    self.tableView.scrollEnabled = NO;
    //    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView *maskview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.parentViewController.view addSubview:maskview];
    ShowImageView* showImage = [[ShowImageView alloc] initWithFrame:self.parentViewController.view.bounds byClickTag:clickTag appendArray:imageViews];
    [showImage show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            showImage.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            [showImage removeFromSuperview];
            [maskview removeFromSuperview];
            self.tableView.scrollEnabled = YES;
        }];
        
    }];
    
}

// 删除帖子回调
- (void)deleteTopic:(NSInteger)topicId
{
    NSLog(@"Detail 删除帖子回调");
    DialogView* deleteView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"common"];
    [self.parentViewController.view addSubview:backgroundView];
    [self.parentViewController.view addSubview:deleteView];
    
    deleteView.titleL.text = @"确定要删除该内容嘛？";
    dialogView = deleteView;
    UIButton* okBtn = deleteView.OKbtn;
    okBtn.tag = topicId;
    [okBtn addTarget:self action:@selector(deleteOkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelBtn = deleteView.NOBtn;
    [cancelBtn addTarget:self action:@selector(deleteNoAction:) forControlEvents:UIControlEventTouchUpInside];

}


// 查看报名详情回调
- (void)lookApplyDetail:(NSInteger)activityId
{
    NSLog(@"lookApplyDetail 回调");
    [self lookApplyNet:activityId];
}

// 报名
- (void) applyDetail:(NSInteger)activityId
{
    NSLog(@"报名详情");
    DialogView* applyView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"apply"];
    backgroundView.alpha = 0.0f;
    applyView.alpha = 0.0f;
    [self.parentViewController.view  addSubview:backgroundView];
    [self.parentViewController.view addSubview:applyView];
    [UIView animateWithDuration:0.3f animations:^{
        backgroundView.alpha = 0.8f;
        applyView.alpha = 1.0f;
    }];
    
    dialogView = applyView;
    UIButton* okBtn = applyView.applyYes;
    okBtn.tag = activityId;
    [okBtn addTarget:self action:@selector(okApplyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelBtn = applyView.applyNo;
    [cancelBtn addTarget:self action:@selector(cancelApplyAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 取消报名回调
- (void) cancelApply:(NSInteger) activityId
{
    NSLog(@"取消报名");
    DialogView* cancelView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"cancelApply"];
    [self.parentViewController.view  addSubview:backgroundView];
    [self.parentViewController.view addSubview:cancelView];
    
    dialogView = cancelView;
    UIButton* okBtn = cancelView.cancelApplyYes;
    okBtn.tag = activityId;
    [okBtn addTarget:self action:@selector(cancelOkApplyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelBtn = cancelView.cancelApplyNo;
    [cancelBtn addTarget:self action:@selector(cancelNoApplyAction:) forControlEvents:UIControlEventTouchUpInside];
}


// 确定报名
- (void) okApplyAction: (id)sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger activityId = button.tag;
    
    [self applyNet:activityId Adult:[dialogView.adultTF.text integerValue] Child:[dialogView.childTF.text integerValue]];

    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
}

// 取消报名
- (void) cancelApplyAction: (id)sender
{
    NSLog(@"取消报名");
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
}

// 确定取消报名
- (void) cancelOkApplyAction: (id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger activityId = button.tag;
    [self cancelApplyNet:activityId];
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}

// 不取消报名
- (void) cancelNoApplyAction: (id) sender
{
    
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}

// 确定删除帖子
- (void) deleteOkAction: (id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger topicId = button.tag;
    [self deleteTopicNet:topicId];
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
}

// 取消删除帖子
- (void) deleteNoAction: (id) sender
{
    
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}

// 确定删除回复
- (void) deleteOkReply: (id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger rowNum = button.tag;
    [self deleteReplyNet:rowNum];
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
}

// 取消删除回复
- (void) deleteNoReply: (id) sender
{
    
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
}



// 取消报名网络请求
// activityId 活动Id
- (void) cancelApplyNet:(NSInteger) activityId
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"activityId%lduserId%@",activityId,userId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"activityId" :
                                    [NSNumber numberWithInteger:activityId],
                                @"userId" : userId,
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"delenroll",
                                @"hash" : hashString,
                                @"keyset" : @"activityId:userId:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"取消报名网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            NSDictionary* dict = self.neighborData.infoArray[0];
            NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [dataDict setObject:@"false" forKey:@"enrollFlag"];
            [dataDict setObject:[responseObject valueForKey:@"enrollTotal"] forKey:@"enrollTotal"];
            NSArray* array = [NSArray arrayWithObject:dataDict];
            self.neighborData.infoArray = [array mutableCopy];

        }
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 查看报名详情网络请求
- (void) lookApplyNet: (NSInteger)activityId
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"activityId%ld",activityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"activityId" : [NSNumber numberWithInteger:activityId],
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"detenroll",
                                @"hash" : hashString,
                                @"keyset" : @"activityId:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"查看报名详情网络请求:%@", responseObject);
        
        ApplyDetailTVC* applyDetailVC = [[ApplyDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
        UIBarButtonItem* detailItem = [[UIBarButtonItem alloc] initWithTitle:@"报名详情" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.parentViewController.navigationItem setBackBarButtonItem:detailItem];
        
        applyDetailVC.totalNum = [[responseObject valueForKey:@"enrollTotal"] integerValue];
        applyDetailVC.peopleA = [responseObject valueForKey:@"enrollData"];
        NSDictionary* dict = self.neighborData.infoArray[0];
        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dataDict setObject:[responseObject valueForKey:@"enrollTotal"] forKey:@"enrollTotal"];
        NSArray* array = [NSArray arrayWithObject:dataDict];
        self.neighborData.infoArray = [array mutableCopy];
        [self.navigationController pushViewController:applyDetailVC animated:YES];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


// 报名网络请求
// activityId 活动Id adultNum 成人人数 childNum 小孩人数
- (void) applyNet:(NSInteger) activityId Adult:(NSInteger)adultNum Child:(NSInteger)childNum
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"activityId%lduserId%@enrollUserCount%ldenrollNeCount%ld",activityId,userId,adultNum,childNum]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"activityId" :
                                    [NSNumber numberWithInteger:activityId],
                                @"userId" : userId,
                                @"enrollUserCount" : [NSNumber numberWithInteger:adultNum],
                                @"enrollNeCount" : [NSNumber numberWithInteger:childNum],
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"enroll",
                                @"hash" : hashString,
                                @"keyset" : @"activityId:userId:enrollUserCount:enrollNeCount:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"报名网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            NSDictionary* dict = self.neighborData.infoArray[0];
            NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [dataDict setObject:@"true" forKey:@"enrollFlag"];
            [dataDict setObject:[responseObject valueForKey:@"count"] forKey:@"enrollTotal"];
            NSArray* array = [NSArray arrayWithObject:dataDict];
            self.neighborData.infoArray = [array mutableCopy];
        }
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 删除帖子网络请求
// topicId 帖子Id
- (void) deleteTopicNet:(NSInteger) topicId
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@topic_id%ld",userId,communityId,topicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"deltopic",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除帖子网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            [self.neighborDA removeObject:self.neighborDF];
            [self.navigationController popViewControllerAnimated:YES];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 添加文本回复网络请求
- (void) addTextReplyNet:(NSString*)content
{
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* senderId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
   
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"sender_id%@topic_id%ldcommunity_id%@content%@",senderId,topicId,communityId,content]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    long sendTime = [date timeIntervalSince1970]*1000;
    NSDictionary* parameter;
    if(replyOtherId == 0)
    {
        parameter = @{@"sender_id" : senderId,
                      @"topic_id" : [NSNumber numberWithInteger:topicId],
                      @"community_id" : communityId,
                      @"contentType" : @"0",
                      @"content" : content,
                      @"sendTime" : [NSNumber numberWithLong:sendTime],
                      @"apitype" : @"comm",
                      @"salt" : @"1",
                      @"tag" : @"addcomm",
                      @"hash" : hashString,
                      @"keyset" : @"sender_id:topic_id:community_id:content:",
                      };
    }
    else
    {
        
        parameter = @{@"sender_id" : senderId,
                      @"topic_id" : [NSNumber numberWithInteger:topicId],
                      @"community_id" : communityId,
                      @"contentType" : @"0",
                      @"content" : content,
                      @"replay_user_id" : [NSNumber numberWithInteger:replyOtherId],
                      @"sendTime" : [NSNumber numberWithLong:sendTime],
                      @"apitype" : @"comm",
                      @"salt" : @"1",
                      @"tag" : @"addcomm",
                      @"hash" : hashString,
                      @"keyset" : @"sender_id:topic_id:community_id:content:",
                      };

    }
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"添加回复网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        replyOtherId = 0;
        if([flag isEqualToString:@"ok"])
        {
            NSDictionary* dict = [replyArr firstObject];
            NSInteger commentId = [[dict valueForKey:@"commId"] integerValue];
            [self getDownReplyNet:commentId];
            
        }
        else if([flag isEqualToString:@"black"])
        {
            
        }
        else if([flag isEqualToString:@"none"])
        {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    

}


// 添加语音回复网络请求
- (void) addVedioReplyNet:(NSString*)vedioPath Length:(NSInteger) length
{
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* senderId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* fileName = [[vedioPath componentsSeparatedByString:@"/"] lastObject];
    NSData* fileData = [NSData dataWithContentsOfFile:vedioPath];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"sender_id%@topic_id%ldcommunity_id%@",senderId,topicId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    long sendTime = [date timeIntervalSince1970]*1000;
    NSDictionary* parameter;
    if(replyOtherId == 0)
    {
        parameter = @{@"sender_id" : senderId,
                      @"topic_id" : [NSNumber numberWithInteger:topicId],
                      @"community_id" : communityId,
                      @"contentType" : @"2",
                      @"video_length" : [NSNumber numberWithInteger:length],
                      @"video" : fileName,
                      @"sendTime" : [NSNumber numberWithLong:sendTime],
                      @"apitype" : @"comm",
                      @"salt" : @"1",
                      @"tag" : @"addcomm",
                      @"hash" : hashString,
                      @"keyset" : @"sender_id:topic_id:community_id:",
                      };
    }
    else
    {
        
        parameter = @{@"sender_id" : senderId,
                      @"topic_id" : [NSNumber numberWithInteger:topicId],
                      @"community_id" : communityId,
                      @"contentType" : @"2",
                      @"video_length" : [NSNumber numberWithInteger:length],
                      @"video" : fileName,
                      @"replay_user_id" : [NSNumber numberWithInteger:replyOtherId],
                      @"sendTime" : [NSNumber numberWithLong:sendTime],
                      @"apitype" : @"comm",
                      @"salt" : @"1",
                      @"tag" : @"addcomm",
                      @"hash" : hashString,
                      @"keyset" : @"sender_id:topic_id:community_id:",
                      };
        
    }
    
    [manager POST:POST_URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"video" fileName:fileName mimeType:@"amr"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"添加语音回复网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        replyOtherId = 0;
        if([flag isEqualToString:@"ok"])
        {
            NSDictionary* dict = [replyArr firstObject];
            NSInteger commentId = [[dict valueForKey:@"commId"] integerValue];
            [self getDownReplyNet:commentId];
            
        }
        else if([flag isEqualToString:@"black"])
        {
            
        }
        else if([flag isEqualToString:@"none"])
        {
            
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
    }];

}


// 添加图片回复网络请求
- (void) addImageReplyNet:(UIImage*)image
{
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* senderId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"sender_id%@topic_id%ldcommunity_id%@",senderId,topicId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    long sendTime = [date timeIntervalSince1970]*1000;
    NSDictionary* parameter;
    if(replyOtherId == 0)
    {
        parameter = @{@"sender_id" : senderId,
                      @"topic_id" : [NSNumber numberWithInteger:topicId],
                      @"community_id" : communityId,
                      @"contentType" : @"1",
                      @"image" : imageName,
                      @"sendTime" : [NSNumber numberWithLong:sendTime],
                      @"apitype" : @"comm",
                      @"salt" : @"1",
                      @"tag" : @"addcomm",
                      @"hash" : hashString,
                      @"keyset" : @"sender_id:topic_id:community_id:",
                      };
    }
    else
    {
        
        parameter = @{@"sender_id" : senderId,
                      @"topic_id" : [NSNumber numberWithInteger:topicId],
                      @"community_id" : communityId,
                      @"contentType" : @"1",
                      @"image" : imageName,
                      @"replay_user_id" : [NSNumber numberWithInteger:replyOtherId],
                      @"sendTime" : [NSNumber numberWithLong:sendTime],
                      @"apitype" : @"comm",
                      @"salt" : @"1",
                      @"tag" : @"addcomm",
                      @"hash" : hashString,
                      @"keyset" : @"sender_id:topic_id:community_id:",
                      };
        
    }
    
    [manager POST:POST_URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSData *data = UIImageJPEGRepresentation(image,0.1);
        [formData appendPartWithFileData:data name:@"image" fileName:imageName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"添加语音回复网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        replyOtherId = 0;
        if([flag isEqualToString:@"ok"])
        {
            NSDictionary* dict = [replyArr firstObject];
            NSInteger commentId = [[dict valueForKey:@"commId"] integerValue];
            [self getDownReplyNet:commentId];
            
        }
        else if([flag isEqualToString:@"black"])
        {
            
        }
        else if([flag isEqualToString:@"none"])
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
    }];
    
}

// 获取回复网络请求
- (void) getReplyNet
{
    
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    [replyArr removeAllObjects];
    [_cellOtherHeight removeAllObjects];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ld",userId,topicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"type" : @"0",
                                @"count" : @"6",
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"getcomm",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取回复网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for(NSInteger i = 0; i < [responseObject count]; i++)
            {
                NSDictionary* sourceDict = responseObject[i];
                NSString* remarkName = [sourceDict valueForKey:@"remarkName"];
                NSString* contentType = [sourceDict valueForKey:@"contentType"];

                if([remarkName isEqualToString:@"null"])
                {
                    [_cellOtherHeight addObject:[NSNumber numberWithFloat:[self heightOfOtherRow:[sourceDict valueForKey:@"content"] Remark:NO Type:contentType]]];
                }
                else
                {
                    [_cellOtherHeight addObject:[NSNumber numberWithFloat:[self heightOfOtherRow:[sourceDict valueForKey:@"content"] Remark:YES Type:contentType]]];
                }
                
               

                [replyArr addObject:sourceDict];
            }
            [self.tableView reloadData];
        }
        [indicatorBV removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 获取下拉回复网络请求
- (void) getDownReplyNet:(NSInteger) commentId
{
    
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ldcomment_id%ld",userId,topicId,commentId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"comment_id" : [NSNumber numberWithInteger:commentId],
                                @"type" : @"2",
                                @"count" : @"6",
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"getcomm",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:comment_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取下拉回复网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for(NSInteger i = 0; i < [responseObject count]; i++)
            {
                NSDictionary* sourceDict = responseObject[i];
                NSInteger sourceId = [[sourceDict valueForKey:@"commId"] integerValue];
                BOOL state = NO;
                for(int i = 0;i < [replyArr count]; i++)
                {
                    NSDictionary* dict = replyArr[i];
                    NSInteger targetId = [[dict valueForKey:@"commId"] integerValue];
                    if(targetId == sourceId)
                        state = YES;

                }
                
                if(state)
                {
                    continue;
                }
                    
                NSString* remarkName = [sourceDict valueForKey:@"remarkName"];
                NSString* contentType = [sourceDict valueForKey:@"contentType"];

                if([remarkName isEqualToString:@"null"])
                {
                    [_cellOtherHeight insertObject:[NSNumber numberWithFloat:[self heightOfOtherRow:[sourceDict valueForKey:@"content"] Remark:NO Type:contentType]] atIndex:0];
                }
                else
                {
                    [_cellOtherHeight insertObject:[NSNumber numberWithFloat:[self heightOfOtherRow:[sourceDict valueForKey:@"content"] Remark:YES Type:contentType]] atIndex:0];
                }
                [replyArr insertObject:sourceDict atIndex:0];
            }
            [self getTotalReplyCountNet];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 获取上拉回复网络请求
- (void) getUpReplyNet
{
    if([replyArr count] < 6)
    {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSDictionary* dict = [replyArr lastObject];
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* commentId = [dict valueForKey:@"commId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ldcomment_id%@",userId,topicId,commentId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"comment_id" : commentId,
                                @"type" : @"3",
                                @"count" : @"6",
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"getcomm",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:comment_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取上拉回复网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for(NSInteger i = 0; i < [responseObject count]; i++)
            {
                
                NSDictionary* sourceDict = responseObject[i];
                NSString* remarkName = [sourceDict valueForKey:@"remarkName"];
                NSString* contentType = [sourceDict valueForKey:@"contentType"];
                if([remarkName isEqualToString:@"null"])
                {
                     [_cellOtherHeight addObject:[NSNumber numberWithFloat:[self heightOfOtherRow:[sourceDict valueForKey:@"content"] Remark:NO Type:contentType]]];
                }
                else
                {
                    [_cellOtherHeight addObject:[NSNumber numberWithFloat:[self heightOfOtherRow:[sourceDict valueForKey:@"content"] Remark:YES Type:contentType]]];
                  
                }
                [replyArr addObject:sourceDict];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
//        self.tableView.bounces = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

// 获取回复总数网络请求
- (void) getTotalReplyCountNet
{
    
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ld",userId,topicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"getcommentcount",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取回复总数网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            self.neighborData.replyCount = [responseObject valueForKey:@"count"];
        }
        EaseChatToolbar *chatToolbar = (EaseChatToolbar*)self.chatToolbar;
        [chatToolbar.inputTextView becomeFirstResponder];
        chatToolbar.inputTextView.text = @"";
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


// 删除回复网络请求
// commentId 回复id
- (void) deleteReplyNet:(NSInteger)rowNum
{
    NSDictionary* dict = replyArr[rowNum - 3];
    NSString* commentId = [dict valueForKey:@"commId"];
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ldcomment_id%@",userId,topicId,commentId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"comment_id" : commentId,
                                @"type" : @"0",
                                @"count" : @"6",
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"delcomm",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:comment_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除回复网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            [replyArr removeObjectAtIndex:rowNum - 3];
            [_cellOtherHeight removeObjectAtIndex:rowNum - 3];
            [self.tableView reloadData];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}

// 取消收藏网络请求
- (void)delCollectTopicNet
{
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ldcommunity_id%@",userId,topicId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"community_id" : communityId,
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"delcol",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:community_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"取消收藏网络请求:%@", responseObject);
        self.neighborData.collectStatus = @"0";
        [listView setCollectStatus:NO];
        [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"取消收藏成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    

}

// 收藏网络请求
- (void)collectTopicNet
{
    NSInteger topicId = [self.neighborData.topicId integerValue];
    NSInteger senderId = [self.neighborData.senderId integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%ldcommunity_id%@",userId,topicId,communityId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"sender_id" : [NSNumber numberWithInteger:senderId],
                                @"topic_id" : [NSNumber numberWithInteger:topicId],
                                @"community_id" : communityId,
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"addcol",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:topic_id:community_id:",
                                };
    NSLog(@"parameter = %@",parameter);
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"收藏网络请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            self.neighborData.collectStatus = @"3";
            [listView setCollectStatus:YES];
            [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"收藏成功"];
        }
        else{
            
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
    
}


#pragma mark - selector

- (void) handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:self.tableView];
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if(translation.y > 0)
        {
            self.tableView.bounces = NO;
        }
        // 底部上拉
        else if(translation.y < 0)
        {
            self.tableView.bounces = YES;
        }
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat h = self.tableView.contentSize.height;
        CGFloat H = CGRectGetHeight(self.view.frame);
        if(h <= H)
        {
            self.tableView.contentSize = CGSizeMake(CGRectGetWidth(self.tableView.frame), H + 5);
        }
    }
}

- (void)rightAction:(id)sender
{
    [self.parentViewController.view addSubview:bgView];
    [self.parentViewController.view addSubview:listView];
}


- (void)upRefreshData
{
    [self getUpReplyNet];
}

#pragma mark - EMChatToolbarDelegate

// 获取键盘输入文本
- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self addTextReplyNet:text];
    }
}


// 按下录音按钮开始录音
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
        [(EaseRecordView *)self.recordView recordButtonTouchDown];
    }
    if ([self _canRecord]) {
        EaseRecordView *tmpView = (EaseRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error)
         {
             if (error) {
                 NSLog(@"%@",NSEaseLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }

}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    if ([self.recordView isKindOfClass:[EaseRecordView class]])
    {
        [(EaseRecordView *)self.recordView recordButtonTouchUpOutside];
    }
    [self.recordView removeFromSuperview];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    if ([self.recordView isKindOfClass:[EaseRecordView class]])
    {
        [(EaseRecordView *)self.recordView recordButtonTouchUpInside];
    }
    [self.recordView removeFromSuperview];
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if(error)
        {
            [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"录音时间太短了"];
        }
        else
        {
            NSLog(@"duration = %ld",aDuration);
            NSLog(@"recordPath = %@",recordPath);
            [self addVedioReplyNet:recordPath Length:aDuration];

        }
    }];
}


#pragma mark - EaseChatBarMoreViewDelegate
- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
//    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
}

- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSEaseLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
#endif
}

- (void)moreViewLocationAction:(EaseChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
    EaseLocationViewController *locationController = [[EaseLocationViewController alloc] init];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage* theImage = nil;
    if([mediaType isEqualToString:(NSString*)kUTTypeImage])
    {
        if([picker allowsEditing])
        {
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else
        {
            theImage = [info objectForKey: UIImagePickerControllerOriginalImage];
        }
        NSLog(@"theImage = %@",theImage);
    }
    if(theImage)
    {
        [self addImageReplyNet:theImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
}

#pragma mark - EMLocationViewDelegate

-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address
{
    NSLog(@"latitude = %g,longitude = %g,address = %@",latitude,longitude,address);
}

#pragma mark - Private
- (BOOL)_canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}


@end



