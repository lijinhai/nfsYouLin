//
//  NewsNeighborVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/18.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NewsNeighborVC.h"
#import "DialogView.h"
#import "StringMD5.h"
#import "UIImageView+WebCache.h"
#import "WaitView.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"
#import "ChatDemoHelper.h"
#import "AppDelegate.h"

@interface NewsNeighborVC ()

@end

@implementation NewsNeighborVC
{
    CGFloat titlePreHeight;
    CGFloat titleMinHeight;
    
    CGFloat contentPreHeight;
    CGFloat contentMinHeight;
    CGFloat contentMaxHeight;
    
    UIImageView* emptyIV;
    UIView* line1;
    UIView* line2;

    NSString* userId;
    NSString* familyId;
    NSString* portrait;
    NSString* nick;
    NSString* familyAddress;
    NSString* communityAddress;
    long cityId;
    long communityId;
    
    UIImageView* _backIV;
    UILabel* _backLabel;
    UIView* backgroundView;
    DialogView* dialogView;
    UIViewController* rootVC;
    
    UILabel* newsTitleL;
    UIImageView* newsIV;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendResult:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIColor* lineColor = [UIColor colorWithRed:217.0 / 255.0 green:216.0 / 255.0 blue:213.0 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 80)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300)];
    self.bgView.bounces = NO;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.bgView.frame));
    
    line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), 1)];
    line1.backgroundColor = lineColor;

    line2 = [[UIView alloc] initWithFrame:CGRectMake(40, 40, CGRectGetWidth(self.bgView.frame) - 80, 1)];
    line2.backgroundColor = lineColor;
    
    [self.bgView addSubview:line1];
    [self.bgView addSubview:line2];
    
    self.titleTV = [[UITextView alloc] initWithFrame:CGRectMake(20, 1, CGRectGetWidth(self.bgView.frame) - 40, 38)];
    self.titleTV.backgroundColor = [UIColor whiteColor];
    self.titleTV.scrollEnabled = NO;
    self.titleTV.font = [UIFont boldSystemFontOfSize:18];
    self.titleTV.delegate = self;
    self.titleTV.returnKeyType = UIReturnKeyDone;
    self.titleTV.autoresizingMask = UIViewAutoresizingNone;
    titlePreHeight = ceilf([self.titleTV sizeThatFits:self.titleTV.frame.size].height);
    titleMinHeight = titlePreHeight;
    
    self.titlePlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, CGRectGetWidth(self.titleTV.frame), 18)];
    self.titlePlaceholder.text = @"标题";
    self.titlePlaceholder.textAlignment = NSTextAlignmentLeft;
    self.titlePlaceholder.font = [UIFont boldSystemFontOfSize:18];
    self.titlePlaceholder.enabled = NO;
    [self.titleTV addSubview:self.titlePlaceholder];
    [self.bgView addSubview:self.titleTV];
    
    emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line2.frame) - 10, 10, 20, 20)];
    emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
    emptyIV.layer.masksToBounds = YES;
    emptyIV.layer.cornerRadius = 10;
    emptyIV.hidden = YES;
    [self.bgView addSubview:emptyIV];
    
    self.contentTV = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line2.frame), CGRectGetWidth(self.bgView.frame) - 40, 38)];
    self.contentTV.backgroundColor = [UIColor whiteColor];
    self.contentTV.scrollEnabled = NO;
    self.contentTV.font = [UIFont systemFontOfSize:14];
    self.contentTV.returnKeyType = UIReturnKeyDone;
    self.contentTV.delegate = self;
    
    self.contentTV.autoresizingMask = UIViewAutoresizingNone;
    contentPreHeight = ceilf([self.contentTV sizeThatFits:self.contentTV.frame.size].height);
    contentMinHeight = contentPreHeight;
    self.contentPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, CGRectGetWidth(self.contentTV.frame), 14)];
    self.contentPlaceholder.text = @"描述内容...";
    self.contentPlaceholder.textAlignment = NSTextAlignmentLeft;
    self.contentPlaceholder.font = [UIFont systemFontOfSize:14];
    self.contentPlaceholder.enabled = NO;
    [self.contentTV addSubview:self.contentPlaceholder];
    [self.bgView addSubview:self.contentTV];
    
    [self.scrollView addSubview:self.bgView];
    [self.view addSubview:self.scrollView];

    newsIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.bgView.frame) - 65, 50, 50)];
    newsIV.backgroundColor = [UIColor lightGrayColor];
    newsIV.contentMode = UIViewContentModeScaleAspectFit;
    [newsIV sd_setImageWithURL:self.newsUrl placeholderImage:[UIImage imageNamed:@"error.png"] options:SDWebImageAllowInvalidSSLCertificates];
    [self.bgView addSubview:newsIV];
    
    newsTitleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(newsIV.frame) + 8, CGRectGetMinY(newsIV.frame), CGRectGetWidth(self.bgView.frame) - 80, 50)];
    newsTitleL.text = self.newsTitle;
    newsTitleL.font = [UIFont systemFontOfSize:15];
    newsTitleL.textColor = [UIColor blackColor];
    newsTitleL.numberOfLines = 0;
    [self.bgView addSubview:newsTitleL];
    [self searchSql];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    rootVC = window.rootViewController.navigationController;
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createBackItemBtn];
}

#pragma mark -发送
- (IBAction)sendResult:(id)sender
{
    NSLog(@"发送");
    NSString* title = self.titleTV.text;
    NSString* content = self.contentTV.text;
    
    if(title.length == 0)
    {
        [emptyIV setHidden:NO];
        return;
    }
    
    if(content.length > 1000)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法发送" message:@"发送内容过长" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"id = %ld", self.newsId);
    
    WaitView* waitView = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"正在发布..."];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:waitView];
    [self.parentViewController.view addSubview:backgroundView];
    
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    long topicTime = [date timeIntervalSince1970]*1000;
    NSString* displayName = [NSString stringWithFormat:@"%@@%@",nick,communityAddress];
    
    // 手机序列号
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    
    NSInteger forumId = 0;
    NSString* forumName = @"本小区";;
    // 发布新话题网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"topic_title%@topic_content%@forum_id%ldforum_name%@sender_id%@sender_name%@sender_portrait%@sender_family_id%@sender_family_address%@sender_city_id%ldsender_community_id%ldsend_status0display_name%@topic_time%ldtokenvalue%@",title, content, forumId,forumName,userId,nick,portrait,familyId,familyAddress,cityId,communityId,displayName,topicTime,identifierNumber]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    NSString* keySet = @"topic_title:topic_content:forum_id:forum_name:sender_id:sender_name:sender_portrait:sender_family_id:sender_family_address:sender_city_id:sender_community_id:send_status:display_name:topic_time:tokenvalue:";
    NSMutableDictionary* parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      title, @"topic_title",
                                      content, @"topic_content",
                                      @"2",  @"topic_category_type",
                                      [NSNumber numberWithInteger:forumId], @"forum_id",
                                      forumName, @"forum_name" ,
                                      userId, @"sender_id",
                                      nick, @"sender_name",
                                      portrait, @"sender_portrait",
                                      @"0", @"sender_nc_role",
                                      familyId, @"sender_family_id",
                                      familyAddress, @"sender_family_address",
                                      @"3", @"object_data_id",
                                      @"1", @"circle_type",
                                      identifierNumber, @"tokenvalue",
                                      [NSNumber numberWithLong:cityId], @"sender_city_id",
                                      [NSNumber numberWithLong:communityId], @"sender_community_id",
                                      [NSNumber numberWithLong:topicTime], @"topic_time",
                                      [NSNumber numberWithInteger:self.newsId], @"new_id",
                                      displayName, @"display_name",
                                      @"0", @"send_status",
                                      @"0", @"sender_lever",
                                      @"comm", @"apitype",
                                      @"addtopic", @"tag",
                                      @"1", @"salt",
                                      hashString, @"hash",
                                      keySet,@"keyset",
                                      nil];
    
    [manager POST:POST_URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@" 发布新闻网络请求请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            [ChatDemoHelper shareHelper].neighborVC.refresh = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if([flag isEqualToString:@"full"])
        {
            NSString* msg = [responseObject valueForKey:@"yl_msg"];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"发送" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [waitView removeFromSuperview];
        [backgroundView removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@", error);
        [waitView removeFromSuperview];
        [backgroundView removeFromSuperview];
    }];


}

#pragma mark -数据库获取数据
// 数据库取数据
- (void) searchSql
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    userId = [defaults stringForKey:@"userId"];
    familyId = [defaults stringForKey:@"familyId"];
    portrait = [defaults stringForKey:@"portrait"];
    nick = [defaults stringForKey:@"nick"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = delegate.db;
    
    if([db open])
    {
        NSLog(@"CreateTopicVC table_all_family: db open success!");
        FMResultSet *result = [db executeQuery:@"SELECT family_address, family_city_id ,family_community_id,family_community_nickname FROM table_all_family WHERE family_id = ?",familyId];
        while ([result next]) {
            familyAddress = [result stringForColumn:@"family_address"];
            communityAddress = [result stringForColumn:@"family_community_nickname"];
            cityId = [result longForColumn:@"family_city_id"];
            communityId = [result longForColumn:@"family_community_id"];
        }
        [db close];
        
    }
    else
    {
        NSLog(@"CreateTopicVC table_all_family: db open error!");
    }
    
}


#pragma mark -返回
- (void) createBackItemBtn
{
    CGSize size = [StringMD5 sizeWithString:@"新闻" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UIControl* view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 25 + size.width, self.navigationController.navigationBar.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    _backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.frame.size.height / 4, 20, view.frame.size.height / 2)];
    _backIV.image = [UIImage imageNamed:@"mm_title_back.png"];
    _backLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backIV.frame) + 5, 0, size.width, view.frame.size.height)];
    
    _backLabel.text = @"新闻";
    _backLabel.textColor = [UIColor whiteColor];
    [view addSubview:_backIV];
    [view addSubview:_backLabel];
    
    [view addTarget:self action:@selector(changeAlpha) forControlEvents:UIControlEventTouchDown];
    [view addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void) backAction
{
    _backLabel.alpha = 1.0;
    _backIV.alpha = 1.0;
    
    DialogView* deleteView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"common"];
    [rootVC.view  addSubview:backgroundView];
    [rootVC.view  addSubview:deleteView];
    
    deleteView.titleL.text = @"确定要放弃此次编辑吗？";
    dialogView = deleteView;
    UIButton* okBtn = deleteView.OKbtn;
    [okBtn addTarget:self action:@selector(OkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* noBtn = deleteView.NOBtn;
    [noBtn addTarget:self action:@selector(NoAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)OkAction:(id) sender
{
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)NoAction:(id) sender
{
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    return;
}

- (void) changeAlpha
{
    _backLabel.alpha = 0.2;
    _backIV.alpha = 0.2;
}

#pragma mark UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(textView == self.titleTV)
    {
        if(self.titleTV.autoresizingMask == UIViewAutoresizingNone)
        {
            self.titleTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            self.contentTV.autoresizingMask = UIViewAutoresizingNone;
        }
        
        if(textView.text.length > 0)
        {
            self.titlePlaceholder.text = @"";
            [emptyIV setHidden:YES];
        }
        else
        {
            self.titlePlaceholder.text = @"标题";
        }
        
        CGFloat toHeight = ceilf([textView sizeThatFits:textView.frame.size].height);
        if(textView.text.length > 64)
        {
            textView.text = [textView.text substringToIndex:64];
        }
        
        if(toHeight == titlePreHeight)
        {
            return;
        }
        
        if (toHeight < titleMinHeight) {
            toHeight = titleMinHeight;
        }
        
        if(toHeight >= 102)
        {
            toHeight = 102;
        }
        
        CGFloat changeHeight = toHeight - titlePreHeight;
        
        CGFloat textViewW = CGRectGetWidth(textView.frame);
        CGFloat textViewH = CGRectGetHeight(textView.frame);
        
        CGRect textViewFrame = textView.frame;
        textViewFrame.size = CGSizeMake(textViewW, toHeight);
        
        if(changeHeight > 0)
        {
            textViewFrame.size = CGSizeMake(textViewW, textViewH);
        }
        else
        {
            textViewFrame.size = CGSizeMake(textViewW, titlePreHeight + 3.6);
        }
        
        textView.frame= textViewFrame;
        titlePreHeight = toHeight;
        
        CGFloat backViewX = self.bgView.frame.origin.x;
        CGFloat backViewY = self.bgView.frame.origin.y;
        CGFloat backViewW = self.bgView.frame.size.width;
        CGFloat backViewH = self.bgView.frame.size.height + changeHeight;
        self.bgView.frame = CGRectMake(backViewX,backViewY, backViewW, backViewH);
        
        CGFloat line2X = line2.frame.origin.x;
        CGFloat line2Y = line2.frame.origin.y + changeHeight;
        CGFloat line2W = line2.frame.size.width;
        CGFloat line2H = line2.frame.size.height;
        line2.frame = CGRectMake(line2X, line2Y, line2W, line2H);
        
        CGFloat contentX = self.contentTV.frame.origin.x;
        CGFloat contentY = self.contentTV.frame.origin.y + changeHeight;
        CGFloat contentW = self.contentTV.frame.size.width;
        CGFloat contentH = self.contentTV.frame.size.height;
        self.contentTV.frame = CGRectMake(contentX, contentY, contentW, contentH);
        
        CGFloat newsIVX = newsIV.frame.origin.x;
        CGFloat newsIVY = newsIV.frame.origin.y + changeHeight;
        CGFloat newsIVW = newsIV.frame.size.width;
        CGFloat newsIVH = newsIV.frame.size.height;
        newsIV.frame  = CGRectMake(newsIVX, newsIVY, newsIVW, newsIVH);
        
        CGFloat newsTitleX = newsTitleL.frame.origin.x;
        CGFloat newsTitleY = newsTitleL.frame.origin.y + changeHeight;
        CGFloat newsTitleW = newsTitleL.frame.size.width;
        CGFloat newsTitleH = newsTitleL.frame.size.height;
        newsTitleL.frame = CGRectMake(newsTitleX, newsTitleY, newsTitleW, newsTitleH);
    }
    else if(textView == self.contentTV)
    {
        if(self.contentTV.autoresizingMask == UIViewAutoresizingNone)
        {
            self.contentTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            self.titleTV.autoresizingMask = UIViewAutoresizingNone;
        }
        
        if(textView.text.length > 0)
        {
            self.contentPlaceholder.text = @"";
        }
        else
        {
            self.contentPlaceholder.text = @"描述内容...";
        }
        
        CGFloat toHeight = ceilf([textView sizeThatFits:textView.frame.size].height);
        
        if(toHeight == contentPreHeight)
        {
            return;
        }
        
        if (toHeight < contentMinHeight) {
            toHeight = contentMinHeight;
        }
        
        
        CGFloat changeHeight = toHeight - contentPreHeight;
        
        CGFloat textViewW = CGRectGetWidth(textView.frame);
        CGFloat textViewH = CGRectGetHeight(textView.frame);
        
        CGRect textViewFrame = textView.frame;
        textViewFrame.size = CGSizeMake(textViewW, toHeight);
        
        if(changeHeight > 0)
        {
            textViewFrame.size = CGSizeMake(textViewW, textViewH);
        }
        else
        {
            textViewFrame.size = CGSizeMake(textViewW, contentPreHeight + 3.6);
        }
        
        textView.frame = textViewFrame;
        contentPreHeight = toHeight;
        
        CGFloat backViewX = self.bgView.frame.origin.x;
        CGFloat backViewY = self.bgView.frame.origin.y;
        CGFloat backViewW = self.bgView.frame.size.width;
        CGFloat backViewH = self.bgView.frame.size.height + changeHeight;
        self.bgView.frame = CGRectMake(backViewX,backViewY, backViewW, backViewH);
        
        CGFloat y = self.scrollView.contentOffset.y + changeHeight;
        if(y > 0)
        {
            self.scrollView.contentOffset = CGPointMake(0, y);
        }
        
        CGFloat newsIVX = newsIV.frame.origin.x;
        CGFloat newsIVY = newsIV.frame.origin.y + changeHeight;
        CGFloat newsIVW = newsIV.frame.size.width;
        CGFloat newsIVH = newsIV.frame.size.height;
        newsIV.frame  = CGRectMake(newsIVX, newsIVY, newsIVW, newsIVH);
        
        CGFloat newsTitleX = newsTitleL.frame.origin.x;
        CGFloat newsTitleY = newsTitleL.frame.origin.y + changeHeight;
        CGFloat newsTitleW = newsTitleL.frame.size.width;
        CGFloat newsTitleH = newsTitleL.frame.size.height;
        newsTitleL.frame = CGRectMake(newsTitleX, newsTitleY, newsTitleW, newsTitleH);

    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.bgView.frame));
    
}


#pragma mark NSNotificationCenter UIKeyboard

//当键出现时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardH, 0);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
