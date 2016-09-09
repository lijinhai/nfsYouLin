//
//  FriendsVC.m
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FriendsVC.h"
#import "FriendViewCell.h"
#import "SegmentView.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "Friends.h"
#import "FriendsManager.h"
#import "MJRefresh.h"
#import "ChatViewController.h"
#import "EaseMessageViewController.h"
#import "PersonModel.h"
#import "ChatDemoHelper.h"
#import "FirstTabBarController.h"
#import "HeaderFile.h"
#import "ShowImageView.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 1.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";


@interface FriendsVC ()

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation FriendsVC
{
    SegmentView* segmentView;
    UIColor *color;
    NSMutableArray* friendsArr;
    NSArray* keysArr;
    NSDictionary* friendsDict;
    UIActivityIndicatorView* indicator;
    UIView* backgroundView;
    UIView* headerView;
    UIPanGestureRecognizer* _panGesture;
    
}

- (id) init
{
    self = [super init];
    if(self)
    {
        color = [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
        friendsArr = [[NSMutableArray alloc] init];
        segmentView = [[SegmentView alloc] init];
        self.listFlag = YES;
        
        self.ecdelegate = self;
        self.ecdataSource = self;
        
        self.conversationArr = [[NSMutableArray alloc] init];
        //    [ChatDemoHelper shareHelper].mainVC = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
        
        UIButton* neighborsBtn = segmentView.neighborsBtn;
        segmentView.nLineView.backgroundColor = color;
        [neighborsBtn setTitleColor:color forState:UIControlStateNormal];
        
        [neighborsBtn addTarget:self action:@selector(neighborsAction:) forControlEvents:UIControlEventTouchDown];
        
        UIButton* chatBtn = segmentView.chatBtn;
        [chatBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:segmentView];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(segmentView.frame)) style:UITableViewStyleGrouped];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        }];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
        backgroundView.backgroundColor = [UIColor lightGrayColor];
        backgroundView.alpha = 0.5;
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetWidth(backgroundView.frame)/2 - 25, CGRectGetHeight(backgroundView.frame) / 2- 25, 50, 50)];
        indicator.hidesWhenStopped = YES;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [backgroundView addSubview:indicator];
        
        _panGesture = self.tableView.panGestureRecognizer;
        [_panGesture addTarget:self action:@selector(handlePan:)];
        
        [self.view addSubview:self.tableView];
        [self getNeighborsListNet];
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.listFlag)
    {
        UIButton* neighborsBtn = segmentView.neighborsBtn;
        segmentView.nLineView.backgroundColor = color;
        [neighborsBtn setTitleColor:color forState:UIControlStateNormal];
        
        UIButton* chatBtn = segmentView.chatBtn;
        segmentView.cLineView.backgroundColor = [UIColor whiteColor];
        [chatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [friendsArr removeAllObjects];
        keysArr = nil;
        [self getNeighborsListNet];
        [self.parentViewController.view addSubview:backgroundView];
    }
   
    [self tableViewDidTriggerHeaderRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// 点击好友列表
- (void) neighborsAction: (id)sender
{
    self.listFlag = YES;
    self.tableView.bounces = YES;
    [segmentView.neighborsBtn setTitleColor:color forState:UIControlStateNormal];
    segmentView.nLineView.backgroundColor = color;
    
    [segmentView.chatBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    segmentView.cLineView.backgroundColor = [UIColor whiteColor];
    [friendsArr removeAllObjects];
    keysArr = nil;
    [self.tableView reloadData];
    [self.parentViewController.view addSubview:backgroundView];
    [self getNeighborsListNet];
    
}

// 点击聊天记录
- (void) chatAction: (id) sender
{
    self.listFlag = NO;
    self.tableView.bounces = NO;
    [segmentView.neighborsBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    segmentView.nLineView.backgroundColor = [UIColor whiteColor];
    
    [segmentView.chatBtn setTitleColor:color forState:UIControlStateNormal];
    segmentView.cLineView.backgroundColor = color;
    keysArr = nil;
    [self.tableView reloadData];

    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.listFlag)
    {
        if(keysArr)
            return [keysArr count];
        else
            return 0;
    }
    else
    {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.listFlag)
    {
        if(keysArr)
        {
            NSString* key = [keysArr objectAtIndex:section];
            NSMutableArray* arr = [friendsDict objectForKey:key];
            return [arr count];
        }
        else
            return 0;
    }
    else
    {
        return [self.conversationArr count];

    }
   
 
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.listFlag)
    {
        if(keysArr)
            return [keysArr objectAtIndex:section];
        else
            return nil;
    }
    else
    {
        return nil;
    }
    
}

// 右侧索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.listFlag)
    {
        if(keysArr)
            return keysArr;
        else
            return nil;
    }
    else
        return nil;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listFlag)
    {
        static NSString* cellId = @"cellId";
        FriendViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[FriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
            
        }
        if(keysArr)
        {
            NSString* key = [keysArr objectAtIndex:indexPath.section];
            NSMutableArray* arr = [friendsDict objectForKey:key];
            Friends* friend = arr[indexPath.row];
            cell.friendsData = friend;
            
        }
        
        return cell;

    }
    else
    {
        NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
        EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.imageDelegate = self;

        id<IConversationModel> model = [self.conversationArr objectAtIndex:indexPath.row];
        cell.model = model;
        cell.detailLabel.attributedText = [self conversationListViewController:nil latestMessageTitleForConversationModel:model];
        cell.timeLabel.text = [self conversationListViewController:nil latestMessageTimeForConversationModel:model];
        return cell;

    }
}

#pragma mark - 圆形头像点击事件回调
- (void)showCircularImageViewWithImage:(UIImage*) image
{
    NSLog(@"圆形头像点击事件回调");
    UIView* addView = [[UIView alloc] initWithFrame:self.parentViewController.view.bounds];
    addView.alpha = 1.0;
    addView.backgroundColor = [UIColor whiteColor];
    [self.parentViewController.view addSubview:addView];
    ShowImageView* showImage = [[ShowImageView alloc] initWithFrame:self.view.frame circularImage:image];
    [showImage show:addView didFinish:^()
     {
         [UIView animateWithDuration:0.5f animations:^{
             showImage.alpha = 0.0f;
             addView.alpha = 0.0f;
             
         } completion:^(BOOL finished) {
             [showImage removeFromSuperview];
             [addView removeFromSuperview];
         }];
         
     }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 好友列表
    if(self.listFlag)
    {
        NSString* key = [keysArr objectAtIndex:indexPath.section];
        NSMutableArray* arr = [friendsDict objectForKey:key];
        
        Friends* friend = arr[indexPath.row];
        NSString* nickName = friend.nick;
        NSString* friendUserId = [NSString stringWithFormat:@"%ld",friend.userId];
        ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:friendUserId conversationType:EMConversationTypeChat];
        chatVC.title = nickName;
        [self.navigationController  pushViewController:chatVC animated:YES];
    }
    else
    {
        id<IConversationModel> model = [self.conversationArr objectAtIndex:indexPath.row];
        NSString* nickName = [[PersonModel sharedPersonModel].nickDict valueForKey:model.title];
        ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:model.title conversationType:EMConversationTypeChat];
        chatVC.title = nickName;
        [self.navigationController  pushViewController:chatVC animated:YES];

    }
    [self setupUnreadMessageCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.listFlag)
    {
        if(section == 0)
            return 30;
        return 15;
    }
    else
    {
        return 0.01f;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == [keysArr count] - 1)
        return 0.1;
    return 15;
}

// 下拉刷下
- (void)loadNewData
{
    [friendsArr removeAllObjects];
    [self getNeighborsListNet];
}

- (void) handlePan:(UIPanGestureRecognizer*)gesture
{

    CGPoint translation = [gesture translationInView:self.tableView];
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if(translation.y > 0)
        {
            self.tableView.bounces = YES;
        }
        // 底部上拉
        else if(translation.y < 0)
        {
            self.tableView.bounces = NO;
        }
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        self.tableView.bounces = NO;

    }
    
    
}



- (void) getNeighborsListNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* blockId = [defaults stringForKey:@"block_id"];
   
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* nickDict = [[NSMutableDictionary alloc] init];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String;
    NSString* hashString;
    NSDictionary* parameter;
    
    MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@block_id%@",userId,communityId,blockId]];
    hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    parameter = @{@"user_id" : userId,
                  @"community_id" : communityId,
                  @"block_id" : blockId,
                  @"apitype" : @"users",
                  @"salt" : @"1",
                  @"tag" : @"neighbors",
                  @"hash" : hashString,
                  @"keyset" : @"user_id:community_id:block_id:",
                  };

    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取邻居列表网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            
            for(int i = 0;i < [responseObject count]; i++)
            {
                if([[responseObject[i] valueForKey:@"user_type"] integerValue] == 4)
                {
                    continue;
                }
                
                NSInteger Id =[[responseObject[i] valueForKey:@"user_id"] integerValue];
                [userDict setValue:[responseObject[i] valueForKey:@"user_portrait"] forKey:[NSString stringWithFormat:@"%ld",Id]];
                [nickDict setValue:[responseObject[i] valueForKey:@"user_nick"] forKey:[NSString stringWithFormat:@"%ld",Id]];
                if([userId integerValue] == [[responseObject[i] valueForKey:@"user_id"] integerValue])
                {
                    continue;
                }
                Friends* friend = [[Friends alloc] init];
                friend.nick = [responseObject[i] valueForKey:@"user_nick"];
                friend.iconAddr = [responseObject[i] valueForKey:@"user_portrait"];
                friend.houseAddr = [NSString stringWithFormat:@"%@-%@",[responseObject[i] valueForKey:@"building_num"],[responseObject[i] valueForKey:@"aptnum"]];
                friend.profession = [responseObject[i] valueForKey:@"user_profession"];
                friend.publicStatus = [responseObject[i] valueForKey:@"user_public_status"];
                friend.userId = [[responseObject[i] valueForKey:@"user_id"] integerValue];
                [friendsArr addObject:friend];
            }
            
            FriendsManager* manager = [[FriendsManager alloc] initWithArray:friendsArr];
            friendsDict = [manager friendsWithGroupAndSort];
            keysArr = [friendsDict allKeys];
            keysArr = [keysArr sortedArrayUsingSelector:@selector(compare:)];
            [segmentView.neighborsBtn setTitle:[NSString stringWithFormat:@"附近邻居:%ld",[friendsArr count]] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [backgroundView removeFromSuperview];
        [PersonModel sharedPersonModel].userDict = userDict;
        [PersonModel sharedPersonModel].nickDict = nickDict;
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取邻居列表请求失败:%@", error.description);
        return;
    }];

}




// 消息推送
- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //触发通知的时间
    notification.fireDate = [NSDate date];
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = [[PersonModel sharedPersonModel].nickDict valueForKey:message.from];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}


// 播放在线消息响铃
- (void)playSoundAndVibration
{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}


- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController* rootVC = window.rootViewController;
        NSArray *viewControllers = rootVC.navigationController.viewControllers;
        __block ChatViewController *chatViewController = nil;
        NSString *conversationChatter = userInfo[kConversationChatter];
        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:EMConversationTypeChat];
        NSString* title = [[PersonModel sharedPersonModel].nickDict valueForKey:conversationChatter];
        chatViewController.title = title;
        
       [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            if([obj isKindOfClass:[ChatViewController class]])
            {
                [rootVC.navigationController popViewControllerAnimated:NO];

            }
        }];
        [rootVC.navigationController pushViewController:chatViewController animated:NO];
    }
    
    [self setupUnreadMessageCount];
}

- (void)jumpToChatList:(NSString*)userId
{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    UIViewController* rootVC = window.rootViewController;
//    NSArray *viewControllers = rootVC.navigationController.viewControllers;
//    __block ChatViewController *chatViewController = nil;
//    chatViewController = [[ChatViewController alloc] initWithConversationChatter:userId conversationType:EMConversationTypeChat];
//    NSString* title = [[PersonModel sharedPersonModel].nickDict valueForKey:userId];
//    chatViewController.title = title;
//    
//    [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//     {
//         if([obj isKindOfClass:[ChatViewController class]])
//         {
//             [rootVC.navigationController popViewControllerAnimated:NO];
//             
//         }
//     }];
//    [self setupUnreadMessageCount];

}


//- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
//{
//    EMConversationType conversatinType = EMConversationTypeChat;
//    switch (type) {
//        case EMChatTypeChat:
//            conversatinType = EMConversationTypeChat;
//            break;
//        case EMChatTypeGroupChat:
//            conversatinType = EMConversationTypeGroupChat;
//            break;
//        case EMChatTypeChatRoom:
//            conversatinType = EMConversationTypeChatRoom;
//            break;
//        default:
//            break;
//    }
//    return conversatinType;
//}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    [self tableViewDidTriggerHeaderRefresh];
    
    [[ChatDemoHelper shareHelper].discoveryVC setRefreshIsMessage];
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    if(unreadCount > 0)
    {
        [segmentView setIsMessage:true];
    }
    else
    {
        [segmentView setIsMessage:false];
    }

    
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    
    
    [self.conversationArr removeAllObjects];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
//        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
//            model = [self.dataSource conversationListViewController:self
//                                               modelForConversation:converstion];
//        }
//        else{
//            model = [[EaseConversationModel alloc] initWithConversation:converstion];
//        }
        model = [[EaseConversationModel alloc] initWithConversation:converstion];
        if (model) {
            [self.conversationArr addObject:model];
        }
    }
    [self.tableView reloadData];
    
}


// 获取最后一条消息显示时间
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    
    return latestMessageTime;
}


- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            NSString* nickName = [[PersonModel sharedPersonModel].nickDict valueForKey:from];
             latestMessageTitle = [NSString stringWithFormat:@"%@: %@", nickName, latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}


@end
