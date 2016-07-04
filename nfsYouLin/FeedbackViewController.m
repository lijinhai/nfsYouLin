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

#define kTextBorderColor     RGBCOLOR(227,224,216)

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface FeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) PlaceholderTextView * textView;

@property (nonatomic, strong) UIButton * sendButton;

@end

@implementation FeedbackViewController{
    UIColor *_viewColor;
    UILabel *uilabel;
    Boolean flag;
    UILabel *label1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=_viewColor;
    [self.view addSubview:self.textView];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
}
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 280)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment =NSTextAlignmentLeft;
        //NSTextAlignmentLeft;
        _textView.editable = YES;
        //_textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = kTextBorderColor.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
        _textView.placeholder = @"在这里输入意见哦，亲";
    }
    
    return _textView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        
        return NO;
    }
    
    return YES;
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger rowNo = indexPath.row;
    NSInteger section = indexPath.section;
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
    //NSInteger rowInSection = indexPath.row;
    //NSInteger section = indexPath.section;
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    PopupFeedBackTypeView *view = [PopupFeedBackTypeView defaultPopupView];
    view.parentVC = self;
    view.feedTypeValue=label1.text;
    NSLog(@"view.feedTypeValue is %@",view.feedTypeValue);
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        [self.otherTableView reloadData];
        
               NSLog(@"动画结束");
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)submitAction:(id)sender {
    
    NSLog(@"=======%@",self.textView.text);
}
@end
