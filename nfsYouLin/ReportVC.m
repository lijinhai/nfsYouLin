//
//  ReportVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ReportVC.h"
#import "ReportCell.h"
#import "StringMD5.h"
#import "MBProgressHUBTool.h"
#import "AFHTTPSessionManager.h"
#import "HeaderFile.h"

@interface ReportVC ()

@end

@implementation ReportVC
{
    UIScrollView* _bgView;
    UITableView* _tableView;
    NSArray* _reasonArr;
    
    UITextView* _textView;
    UILabel* _placeholderL;
    
    NSInteger _selectedRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    
    _reasonArr = [NSArray arrayWithObjects:@"敏感信息",@"版权问题",@"暴力色情",@"诈骗和虚假信息",@"骚扰",@"其他", nil];
    
    _bgView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bgView.bounces = NO;
    [self.view addSubview:_bgView];

    UIView* declareView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame), 80)];
    declareView.backgroundColor = [UIColor whiteColor];
    _bgView.contentSize = CGSizeMake(CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame) - 100);
    [_bgView addSubview:declareView];
    
    UIImageView* declareIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
    declareIV.layer.masksToBounds = YES;
    declareIV.layer.cornerRadius = 30;
    declareIV.image = [UIImage imageNamed:@"police_portrait.png"];
    UILabel* declareL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(declareIV.frame) + 10, 10, CGRectGetWidth(self.view.frame) - 120, 60)];
    declareL.numberOfLines = 0;
    declareL.font = [UIFont systemFontOfSize:12];
    declareL.text = @"优邻一直努力为用户打造健康的阅读环境，我们坚决反对违法、色情、欺诈等信息内容。欢迎广大读者积极举报不良的文章，以便我们更加及时和精确的处理。";
    declareL.enabled = NO;
    [declareView addSubview:declareIV];
    [declareView addSubview:declareL];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(declareView.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 30)];
    titleL.text = @"请选择举报原因";
    titleL.font = [UIFont systemFontOfSize:11];
    titleL.enabled = NO;
    [_bgView addSubview:titleL];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleL.frame), CGRectGetWidth(self.view.frame), 300) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    [_bgView addSubview:_tableView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_tableView.frame) + 10 , CGRectGetWidth(_tableView.frame), 100)];
    _textView.delegate = self;
    _textView.bounces = NO;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.returnKeyType = UIReturnKeyDone;
    [_bgView addSubview:_textView];
    
    _placeholderL = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, CGRectGetWidth(_textView.frame), 15)];
    _placeholderL.text = @"请输入举报内容";
    _placeholderL.font = [UIFont systemFontOfSize:15];
    _placeholderL.enabled = NO;
    [_textView addSubview:_placeholderL];
    
    UIButton* rebortBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_textView.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 40)];
    [rebortBtn setTitle:@"确认举报" forState:UIControlStateNormal];
    [rebortBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rebortBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:222/255.0 blue:31/255.0 alpha:1]];
    [rebortBtn addTarget:self action:@selector(rebortAction:) forControlEvents:UIControlEventTouchUpInside];
    rebortBtn.layer.masksToBounds = YES;
    rebortBtn.layer.cornerRadius = 6;
    [_bgView addSubview:rebortBtn];
    _selectedRow = -1;
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -selector
-(void) rebortAction:(id)sender
{
    [self reportNet];
}

#pragma mark -UITableViewDelegate UITableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString* cellId = @"cellId";
    ReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[ReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if(row == _selectedRow)
    {
        cell.selectedIV.hidden = NO;
    }
    else
    {
        cell.selectedIV.hidden = YES;
    }
    cell.textLabel.text = [_reasonArr objectAtIndex:row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = indexPath.row;
    [self.view endEditing:YES];
    [_tableView reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -UITextViewDelegate
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
    if(textView.text.length > 0)
    {
        _placeholderL.text = @"";
    }
    else
    {
        _placeholderL.text = @"请输入举报内容";
    }

    if(textView.text.length > 150)
    {
        textView.text = [textView.text substringToIndex:150];
    }
}

#pragma mark NSNotificationCenter UIKeyboard
//当键出现时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    CGFloat height = _bgView.contentSize.height;
    _bgView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), keyboardH + height);
    _bgView.contentOffset = CGPointMake(0, CGRectGetMidX(_tableView.frame));
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    CGFloat height = _bgView.contentSize.height;
    _bgView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), height - keyboardH);

}

#pragma mark -举报 服务器请求
// 举报网络请求
- (void)reportNet
{
    
    if(_selectedRow == -1)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"举报原因不能为空"];
        return;
    }
    NSString* reportTitle = [_reasonArr objectAtIndex:_selectedRow];
    NSString* detailContent = _textView.text;

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"complain_id%@topic_id%ldcommunity_id%@sender_id%ld",userId,self.topicId,communityId,self.senderId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"complain_id" : userId,
                                @"sender_id" : [NSNumber numberWithInteger:self.senderId],
                                @"topic_id" : [NSNumber numberWithInteger:self.topicId],
                                @"community_id" : communityId,
                                @"title" : reportTitle,
                                @"content" : detailContent,
                                @"apitype" : @"comm",
                                @"salt" : @"1",
                                @"tag" : @"report",
                                @"hash" : hashString,
                                @"keyset" : @"complain_id:topic_id:community_id:sender_id:",
                                };
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"举报网络请求:%@", responseObject);
        if([[responseObject valueForKey:@"flag"] isEqualToString:@"ok"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"举报成功"];
//            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
    
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
