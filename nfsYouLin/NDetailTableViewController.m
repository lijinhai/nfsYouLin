//
//  NDetailTableViewController.m
//  nfsYouLin
//
//  Created by Macx on 16/6/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NDetailTableViewController.h"
#import "NDetailTableViewCell.h"
#import "StringMD5.h"

@interface NDetailTableViewController ()

@end

@implementation NDetailTableViewController
{
    NSMutableArray* _replyText;
    UIView* _footerView;
    CGFloat _cellHeight;        // 第二个表格行高度
    NSMutableArray* _cellOtherHeight;   // 回复表格行高度

}

- (void)viewWillAppear:(BOOL)animated
{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        cell.replyString = _replyText[indexPath.row - 3];
        cell.replySize = [StringMD5 sizeWithString: _replyText[indexPath.row - 3] font:[UIFont fontWithName:@"AppleGothic" size:16] maxSize:CGSizeMake(screenWidth - 6 * PADDING, MAXFLOAT)];
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
    self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:barType];
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
    cellHeight +=  [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@@%@",self.neighborData.accountName, self.neighborData.addressInfo] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    cellHeight += [StringMD5 sizeWithString:replyText font:[UIFont fontWithName:@"AppleGothic" size:16] maxSize:CGSizeMake(screenWidth - 6 * PADDING, MAXFLOAT)].height;
    return cellHeight;
}

// 计算第二个表格行高度
- (CGFloat) heightOfScondRow
{
    CGFloat cellHeight = 4 * PADDING;
    cellHeight += [StringMD5 sizeWithString:[NSString stringWithFormat:@"标题:#%@#%@",self.neighborData.titleCategory,self.neighborData.titleName] font:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    
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


@end



