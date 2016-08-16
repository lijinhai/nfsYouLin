//
//  FeedbackViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/6/28.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PlaceholderTextView.h"
#import "LewPopupViewController.h"
#import "PopupFeedBackTypeView.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "SqliteOperation.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"

#define kTextBorderColor     RGBCOLOR(227,224,216)

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface FeedbackViewController ()<UITextViewDelegate>


@property (nonatomic, strong) UIButton * sendButton;

@end

@implementation FeedbackViewController{
    
    UIColor *_viewColor;
    UILabel *uilabel;
    Boolean flag;
    UILabel *label1;
    Boolean tanhaoType;
    Boolean tanhaoContent;
    NSTimer *timer;
    UIActivityIndicatorView* _indicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=_viewColor;
    
     tanhaoType=NO;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     self.navigationItem.title=@"";
    /*设置表格*/
    _otherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width,40) style:UITableViewStylePlain];
    _otherTableView.dataSource=self;
    _otherTableView.delegate=self;
    _otherTableView.scrollEnabled=NO;
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([self.otherTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.otherTableView setSeparatorInset:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    
    if ([self.otherTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.otherTableView setLayoutMargins:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    [self.view addSubview:_otherTableView];
    /*提交按钮设置*/
    UIButton* submitButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    submitButton.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+60);
    submitButton.titleLabel.textColor=[UIColor blackColor];
    submitButton.titleLabel.font=[UIFont systemFontOfSize:16];
    submitButton.layer.cornerRadius=6;
    submitButton.backgroundColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitSuggestAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    /*初始化文本框*/
    PlaceholderTextView* suggestTextView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 280)];
    suggestTextView.tag=1024;
    suggestTextView.backgroundColor = [UIColor whiteColor];
    suggestTextView.delegate = self;
    suggestTextView.font = [UIFont systemFontOfSize:16.f];
    suggestTextView.textColor = [UIColor blackColor];
    suggestTextView.textAlignment =NSTextAlignmentLeft;
    suggestTextView.editable = YES;
    suggestTextView.layer.borderColor = kTextBorderColor.CGColor;
    suggestTextView.layer.borderWidth = 0.5;
    suggestTextView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
    suggestTextView.placeholder = @"在这里输入意见哦，亲";
    [self.view addSubview:suggestTextView];
    /*设置缓冲*/
    UILabel* indicatorText=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_indicator.frame), 60, 30)];
    indicatorText.text=@"发布中";
    indicatorText.textColor=[UIColor blackColor];
    indicatorText.textAlignment=NSTextAlignmentCenter;
    indicatorText.font=[UIFont systemFontOfSize:13];
    _indicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _indicator.center=self.view.center;
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicator setBackgroundColor:[UIColor lightGrayColor]];
    //indicatorText.center=_indicator.center;
    [_indicator addSubview:indicatorText];
    [self.view addSubview:_indicator];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        
        return YES;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
        if((UIView *)[self.view viewWithTag:119])
        {
            UIView *imageTanHao = (UIView *)[self.view viewWithTag:119];
            [imageTanHao removeFromSuperview];
        }

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView* xImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tanhao"]];
    rightView.tag=110;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    static NSString *CellIdentifier = @"otherid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
    }
    self.selectTypeValue = [defaults valueForKey:@"typeKey"];
    label1=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 20)];
    label1.tag=1001;
    if(self.selectTypeValue==NULL)
    {
    if((UILabel *)[self.view viewWithTag:1001]){
                [(UILabel *)[self.view viewWithTag:1001] removeFromSuperview];
    }
     label1.text=@"类别";
     
    
    }else{
     
    if((UILabel *)[self.view viewWithTag:1001]){
            [(UILabel *)[self.view viewWithTag:1001] removeFromSuperview];
    }
     label1.text=self.selectTypeValue;
     [defaults removeObjectForKey:@"typeKey"];
    }
    if(tanhaoType)
    {
        if((UIView *)[self.view viewWithTag:110]==NULL)
        {
        xImageView.center=CGPointMake(cell.frame.size.width-40, cell.frame.size.height/2);
        [rightView addSubview:xImageView];
        [cell.contentView addSubview:rightView];
        }
        
    }else{
        
        if((UIView *)[self.view viewWithTag:110])
        {
            UIView *imageTanHao = (UIView *)[cell viewWithTag:110];
            [imageTanHao removeFromSuperview];
        }
    
    }
    [cell.contentView addSubview:label1];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 40;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0,15, 0, 15)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0,15, 0, 15)];
        }
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PopupFeedBackTypeView *view = [PopupFeedBackTypeView defaultPopupView];
    view.parentVC = self;
    view.feedTypeValue=label1.text;
    NSLog(@"view.feedTypeValue is %@",view.feedTypeValue);
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        tanhaoType=NO;
        [self.otherTableView reloadData];
        
               NSLog(@"动画结束");
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)submitSuggestAction:(id)sender{

    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView* xImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tanhao"]];
    rightView.tag=119;
    PlaceholderTextView* sugTextView=(PlaceholderTextView *)[self.view viewWithTag:1024];
    if(self.selectTypeValue==NULL)
    {
        tanhaoType=YES;
        [MBProgressHUBTool textToast:self.view Tip:@"类别不能为空"];
        [_otherTableView reloadData];
        return;
    }else{
        
        tanhaoType=NO;
        
    }
    
    if([sugTextView.text isEqualToString:@""])
    {
        if((UIView *)[self.view viewWithTag:119]==NULL)
        {
            xImageView.center=CGPointMake(sugTextView.frame.size.width-20, 15);
            [rightView addSubview:xImageView];
            [sugTextView addSubview:rightView];
        }
        [MBProgressHUBTool textToast:self.view Tip:@"内容不能为空"];
        return;
    }
    [_indicator startAnimating];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* communityId = [NSString stringWithFormat:@"%ld", [SqliteOperation getNowCommunityId]];
    NSString* typeOptionStr=[self checkOptionType:self.selectTypeValue];
    NSLog(@"typeOptionStr is %@",typeOptionStr);
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"userId%@communityId%@opinionType%@opinionContent%@",userId,communityId,typeOptionStr,sugTextView.text]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@3",hashString]];
    NSDictionary* parameter = @{@"userId" : userId,
                                @"communityId" : communityId,
                                @"opinionType":typeOptionStr,
                                @"opinionContent": sugTextView.text,
                                @"deviceType":@"ios",
                                @"apitype" : @"feedback",
                                @"tag" : @"feedback",
                                @"salt" : @"3",
                                @"hash" : hashMD5,
                                @"keyset" : @"userId:communityId:opinionType:opinionContent:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject is %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            
            [_indicator stopAnimating];
           
            timer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(jumpView)
                                                 userInfo:nil
                                                  repeats:NO];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];
    
    
    
}
-(void)jumpView{
    
    [self.navigationController popViewControllerAnimated:YES];
     [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"发布成功"];
    PlaceholderTextView* sugTextView=(PlaceholderTextView *)[self.view viewWithTag:1024];
    [sugTextView removeFromSuperview];
    
    
}
-(NSString*)checkOptionType:(NSString*)typeStr
{
    NSString* opinionTypeNum=NULL;
    if([typeStr isEqualToString:@"界面"]){
        
        opinionTypeNum=@"1";
    }else if([typeStr isEqualToString:@"功能"]){
        
        opinionTypeNum=@"2";
    }else if([typeStr isEqualToString:@"其他"]){
        
        opinionTypeNum=@"3";
    }
    return opinionTypeNum;
}

@end
