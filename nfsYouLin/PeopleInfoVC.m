//
//  PeopleInfoVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/8.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PeopleInfoVC.h"
#import "PeopleInfoCell.h"
#import "StringMD5.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"
#import "ShowImageView.h"
#import "PersonTopicTVC.h"

@interface PeopleInfoVC ()


@end

@implementation PeopleInfoVC
{
    UIImageView* _sexIV;
    
    NSString* _profession;
    NSString* _city;
    NSString* _userNick;
    NSString* _curNick;
    UITableView* _tableView;
    UIImageView* iconIV;
    UILabel* _nickL;
    UILabel* _forumL;
    UITextField* _textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat bgY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    UIImageView* bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, bgY, CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame) - bgY) * 0.4)];
    bgIV.image = [UIImage imageNamed:@"beijing.png"];
    bgIV.userInteractionEnabled = YES;
    [self.view addSubview:bgIV];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgIV.frame), CGRectGetWidth(self.view.frame), 200)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    [self.view addSubview:_tableView];
    
    iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 - 40, 40, 80, 80)];
    iconIV.layer.masksToBounds = YES;
    iconIV.layer.cornerRadius = 40;
    iconIV.userInteractionEnabled = YES;
    NSURL* url = [NSURL URLWithString:self.icon];
    [iconIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconGesture)];
    [iconIV addGestureRecognizer:gesture];
    [bgIV addSubview:iconIV];
    
    NSString* name = [[self.displayName componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSString* forum = [[self.displayName componentsSeparatedByString:@"@"] objectAtIndex:1];

    UILabel* nickL = [[UILabel alloc] init];
    nickL.font = [UIFont systemFontOfSize:15];
    if(name.length > 10)
    {
        nickL.text = [name substringToIndex:9];
    }
    else
    {
        nickL.text = name;
    }
    
    nickL.textAlignment = NSTextAlignmentCenter;
    nickL.textColor = [UIColor whiteColor];
    CGSize nickSize = [StringMD5 sizeWithString:nickL.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame), 20)];
    CGFloat nickX = (CGRectGetWidth(self.view.frame) - nickSize.width) * 0.5;
    nickL.frame = CGRectMake(nickX, CGRectGetMaxY(iconIV.frame) + 20, nickSize.width, 20);
    [bgIV addSubview:nickL];
    _nickL = nickL;
    
    _sexIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickL.frame) + 5, CGRectGetMinY(nickL.frame) + 3, 14, 14)];
    _sexIV.layer.masksToBounds = YES;
    _sexIV.layer.cornerRadius = 7;
    [bgIV addSubview:_sexIV];
    
    
    _forumL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nickL.frame), CGRectGetWidth(self.view.frame), 25)];
    _forumL.textColor = [UIColor whiteColor];
    _forumL.font = [UIFont systemFontOfSize:16];
    _forumL.text = forum;
    _forumL.textAlignment = NSTextAlignmentCenter;
    [bgIV addSubview:_forumL];
    
    [self getPeopleInfoNet];
    
    UIControl* chatView = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 - 140, CGRectGetMaxY(_forumL.frame) + 25, 135, 40)];
    chatView.layer.cornerRadius = 20;
    chatView.backgroundColor = [UIColor blackColor];
    chatView.alpha = 0.7f;
    [chatView addTarget:self action:@selector(chatClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgIV addSubview:chatView];
    
    UIImageView* chatIV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
    chatIV.image = [UIImage imageNamed:@"friend_chat.png"];
    [chatView addSubview:chatIV];
    
    UILabel* chatL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(chatIV.frame), 0, 60, 40)];
    chatL.text = @"私信";
    chatL.textAlignment = NSTextAlignmentCenter;
    chatL.textColor = [UIColor whiteColor];
    [chatView addSubview:chatL];
    
    
    UIControl* remarkView = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 0.5 + 5, CGRectGetMaxY(_forumL.frame) + 25, 135, 40)];
    remarkView.layer.cornerRadius = 20;
    remarkView.backgroundColor = [UIColor blackColor];
    remarkView.alpha = 0.7f;
    [remarkView addTarget:self action:@selector(remarkClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgIV addSubview:remarkView];
    
    UIImageView* remarkIV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
    remarkIV.image = [UIImage imageNamed:@"friend_remark.png"];
    [remarkView addSubview:remarkIV];
    
    UILabel* remarkL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(remarkIV.frame), 0, 60, 40)];
    remarkL.textAlignment = NSTextAlignmentCenter;
    remarkL.text = @"备注";
    remarkL.textColor = [UIColor whiteColor];
    [remarkView addSubview:remarkL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -头像点击
-(void) iconGesture
{
    NSLog(@"iconGesture");
    UIView *maskview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskview.backgroundColor = [UIColor blackColor];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController* rootVC = window.rootViewController.navigationController;

    UIView* addView = [[UIView alloc] initWithFrame:rootVC.view.bounds];
    addView.alpha = 1.0;
    addView.backgroundColor = [UIColor whiteColor];
    [rootVC.view addSubview:addView];
    ShowImageView* showImage = [[ShowImageView alloc] initWithFrame:self.view.frame circularImage:iconIV.image];
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

#pragma mark -点击聊天
- (void) chatClicked:(id) sender
{
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:[NSString stringWithFormat:@"%ld",self.peopleId] conversationType:EMConversationTypeChat];
    chatVC.title = _userNick;
    [self.navigationController  pushViewController:chatVC animated:YES];
}

#pragma mark -点击修改备注
- (void) remarkClicked:(id) sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = _nickL.text;
        textField.font = [UIFont systemFontOfSize:18];
        _textField = textField;
        [_textField addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString* name = _textField.text;
        if(name.length <= 1)
        {
            [MBProgressHUBTool textToast:self.view Tip:@"格式不正确"];
            return;
        }
        CGSize nickSize = [StringMD5 sizeWithString:name font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame), 20)];
        CGFloat nickX = (CGRectGetWidth(self.view.frame) - nickSize.width) * 0.5;
        CGRect frame = _nickL.frame;
        CGFloat nickY = frame.origin.y;
        _nickL.frame = CGRectMake(nickX, nickY, nickSize.width, 20);
        _nickL.text = name;
        _sexIV.frame = CGRectMake(CGRectGetMaxX(_nickL.frame) + 5, CGRectGetMinY(_nickL.frame) + 3, 14, 14);
        [self setRemarkNet];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -TextFieldDidChange
- (void)TextFieldDidChange:(UITextField*)textField
{
    if (textField.text.length > 10)
    {
        textField.text = [textField.text substringToIndex:10];
    }
}

#pragma mark -UITableViewDelegate UITableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    NSInteger row = indexPath.row;
    PeopleInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[PeopleInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    switch (row) {
        case 0:
        {
            cell.textLabel.text = @"昵称";
            cell.contentL.text = _userNick;
            cell.textLabel.enabled = NO;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"职业";
            cell.contentL.text = _profession;
            cell.textLabel.enabled = NO;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
        case  2:
        {
            cell.textLabel.text = @"所在地";
            cell.textLabel.enabled = NO;
            cell.contentL.text = _city;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"邻居圈";
            cell.textLabel.enabled = NO;
            cell.contentL.text = @"Ta邻居圈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
    {
        PersonTopicTVC *ptVC = [[PersonTopicTVC alloc] initWithStyle:UITableViewStyleGrouped];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle:@"他发的" style:UIBarButtonItemStylePlain target:nil action:nil];
        ptVC.userIdStr = [NSString stringWithFormat:@"%ld",self.peopleId];
        [self.parentViewController.navigationItem setBackBarButtonItem:backItem];
        [self.navigationController pushViewController:ptVC animated:YES];
    }
}

#pragma mark -获取个人信息网络请求
- (void) getPeopleInfoNet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"my_user_id%@user_id%ld",userId,self.peopleId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"my_user_id" : userId,
                                @"user_id" : [NSNumber numberWithInteger:self.peopleId],
                                @"apitype" : @"users",
                                @"salt" : @"1",
                                @"tag" : @"userdetailinfo",
                                @"hash" : hashString,
                                @"keyset" : @"my_user_id:user_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取个人信息网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            _city = [responseObject valueForKey:@"cur_city_name"];
            _profession = [responseObject valueForKey:@"user_profession"];
            _userNick = [responseObject valueForKey:@"current_nick"];
            NSInteger sex = [[responseObject valueForKey:@"user_gender"] integerValue];
            
            if([_profession isEqual:[NSNull null]])
            {
                _profession = @"未设置";
            }
            
            
            if(sex == 2)
            {
                _sexIV.image = [UIImage imageNamed:@"nvtubiao.png"];
            }
            else if(sex == 1)
            {
                _sexIV.image = [UIImage imageNamed:@"nan.png"];
            }
            else
            {
                _sexIV.image = [UIImage imageNamed:@"baomi.png"];
            }
            
            NSString* name = [responseObject valueForKey:@"user_nick"];
            CGSize nickSize = [StringMD5 sizeWithString:name font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(CGRectGetWidth(self.view.frame), 20)];
            CGFloat nickX = (CGRectGetWidth(self.view.frame) - nickSize.width) * 0.5;
            CGRect frame = _nickL.frame;
            CGFloat nickY = frame.origin.y;
            _nickL.frame = CGRectMake(nickX, nickY, nickSize.width, 20);
            _nickL.text = name;
            _sexIV.frame = CGRectMake(CGRectGetMaxX(_nickL.frame) + 5, CGRectGetMinY(_nickL.frame) + 3, 14, 14);
            _forumL.text = [responseObject valueForKey:@"cur_community_name"];

        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
 
}

#pragma mark -设置备注网络请求
- (void) setRemarkNet
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* name = _textField.text;
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@remarks_id%ldremarks_name%@",userId,self.peopleId,name]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"remarks_id" : [NSNumber numberWithInteger:self.peopleId],
                                @"remarks_name" : name,
                                @"apitype" : @"users",
                                @"salt" : @"1",
                                @"tag" : @"setuserremarks",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:remarks_id:remarks_name:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改备注网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
           
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}


@end
