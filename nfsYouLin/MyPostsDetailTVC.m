//
//  MyPostsDetailTVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/8/26.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "MyPostsDetailTVC.h"
#import "PDetailTableViewCell.h"
#import "StringMD5.h"
#import "DialogView.h"
#import "AFHTTPSessionManager.h"
#import "FTPopOverMenu.h"
#import "SqliteOperation.h"
#import "MBProgressHUBTool.h"


@interface MyPostsDetailTVC ()

@end

@implementation MyPostsDetailTVC{


    NSMutableArray* _replyText;
    UIView* _footerView;
    CGFloat _cellHeight;        // 第二个表格行高度
    NSMutableArray* _cellOtherHeight;   // 回复表格行高度
    UIView* backgroundView;
    DialogView* dialogView;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"circle_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction:event:)];
    self.navigationItem.rightBarButtonItem = rightButton;
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
    _replyText = [[NSMutableArray alloc] init];
    _cellOtherHeight = [[NSMutableArray alloc] init];
    _cellHeight = [self heightOfScondRow];
    
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;
    
    self.tableView.bounces = NO;
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
    [self initInputView];
    
}

-(void)selectRightAction:(UIBarButtonItem *)sender event:(UIEvent *)event
{
    
    
    [FTPopOverMenu showFromEvent:event
                        withMenu:@[@"修改",@"收藏"]
                  imageNameArray:@[@"",@""]
                       doneBlock:^(NSInteger selectedIndex) {
                           if(selectedIndex==0)
                           {
                               NSLog(@"修改");
                             
                           }else{
                            
                               NSLog(@"收藏");
                               [self collectTopicAct];
                           
                           }

                       } dismissBlock:^{
                           
                       }];    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectTopicAct{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [NSString stringWithFormat:@"%ld", [SqliteOperation getNowCommunityId]];
    NSString* topicId=self.myPostsData.topicId;
    NSLog(@"topicId is %@",topicId);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@topic_id%@community_id%@",userId,topicId,communityId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@2016",hashString]];
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"topic_id" : topicId,
                                @"community_id" : communityId,
                                @"deviceType":@"ios",
                                @"apitype" : @"comm",
                                @"tag" : @"addcol",
                                @"salt" : @"2016",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:topic_id:community_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject is %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"收藏成功"];
        
        }else{
        
        
            [MBProgressHUBTool textToast:self.view Tip:@"网络不给力！"];
        
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 || indexPath.row == 2)
    {
        return 44;
    }
    else if(indexPath.row == 1)
    {
        return _cellHeight;
    }
    else
    {
        return [[_cellOtherHeight objectAtIndex:indexPath.row - 3] floatValue];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_replyText count] + 3;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellZero = @"Zero";
    NSString* cellOne = @"One";
    NSString* cellTwo = @"Two";
    NSString* cellOther = @"Other";
    PDetailTableViewCell* cell;
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellZero];
        if(cell == nil)
        {
            cell = [[PDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellZero];
        }
    }
    else if(indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellOne];
        if(cell == nil)
        {
            cell = [[PDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOne];
        }
    }
    else if(indexPath.row == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellTwo];
        if(cell == nil)
        {
            cell = [[PDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
        }
    }
    
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellOther];
        if(cell == nil)
        {
            cell = [[PDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOther];
        }
        
        cell.replyString = _replyText[indexPath.row - 3];
        cell.replySize = [StringMD5 sizeWithString: _replyText[indexPath.row - 3] font:[UIFont fontWithName:@"AppleGothic" size:16] maxSize:CGSizeMake(screenWidth - 6 * PADDING, MAXFLOAT)];
    }
    
    cell.rowNum = indexPath.row;
    cell.delegate = self;
    cell.myPostsData = self.myPostsData;
    
    return cell;
}

- (void) initInputView
{
    //初始化页面
    CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
    EMChatToolbarType barType = EMChatToolbarTypeChat;
    self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.parentViewController.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:barType];
    self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
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


- (void)setMyPostsData:(MyPostsData *)myPostsData
{
    _myPostsData = myPostsData;
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

// 获取键盘输入文本
- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [_replyText insertObject:text atIndex: 0];
        [_cellOtherHeight addObject:[NSNumber numberWithFloat:[self heightOfOtherRow:text]]];
        [self.tableView reloadData];
    }
}

// 计算回复表格行高度

- (CGFloat) heightOfOtherRow: (NSString*)replyText
{
    CGFloat cellHeight = 5 * PADDING + 25;
    cellHeight +=  [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@",self.myPostsData.accountName] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    cellHeight += [StringMD5 sizeWithString:replyText font:[UIFont fontWithName:@"AppleGothic" size:16] maxSize:CGSizeMake(screenWidth - 6 * PADDING, MAXFLOAT)].height;
    return cellHeight;
}

// 计算第二个表格行高度
- (CGFloat) heightOfScondRow
{
    CGFloat cellHeight = 4 * PADDING;
    cellHeight += [StringMD5 sizeWithString:[NSString stringWithFormat:@"标题:%@",self.myPostsData.titleName] font:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    
    cellHeight += [StringMD5 sizeWithString:self.myPostsData.publishText font:[UIFont fontWithName:@"AppleGothic" size:16] maxSize:CGSizeMake(screenWidth - 2 * PADDING, MAXFLOAT)].height;
    NSInteger count = self.myPostsData.picturesArray.count;
    CGFloat pictureH = (screenWidth - PADDING ) / 3 - (PADDING / 2);
    if(0 < count && self.myPostsData.picturesArray.count <= 3)
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
    if([self.myPostsData.senderId integerValue] == [userId integerValue])
    {
        cellHeight += [StringMD5 sizeWithString:@"删除" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height + PADDING;
        
    }
    
    if([self.myPostsData.topicCategory integerValue] == 1)
    {
        cellHeight += 30;
    }
    
    cellHeight += PADDING;
    
    
    return cellHeight;
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
            NSDictionary* dict = self.myPostsData.infoArray[0];
            NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [dataDict setObject:@"false" forKey:@"enrollFlag"];
            [dataDict setObject:[responseObject valueForKey:@"enrollTotal"] forKey:@"enrollTotal"];
            NSArray* array = [NSArray arrayWithObject:dataDict];
            self.myPostsData.infoArray = [array mutableCopy];
            
        }
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
            NSDictionary* dict = self.myPostsData.infoArray[0];
            NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [dataDict setObject:@"true" forKey:@"enrollFlag"];
            [dataDict setObject:[responseObject valueForKey:@"count"] forKey:@"enrollTotal"];
            NSArray* array = [NSArray arrayWithObject:dataDict];
            self.myPostsData.infoArray = [array mutableCopy];
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
            [self.myPostsDA removeObject:self.myPostsDF];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


@end
