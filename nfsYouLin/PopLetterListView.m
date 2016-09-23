//
//  PopLetterListView.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PopLetterListView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "ChatViewController.h"


@implementation PopLetterListView{
    
    UIImageView *selectUIRadio;
    UIImageView *selectFunctionRadio;
    UIImageView *selectOtherRadio;
    UIView *rightView1;
    UIView *rightView2;
    UIView *rightView3;
    NSUInteger selectNum;
    NSMutableArray *letterDS;
    
}


- (id)initWithFrame:(CGRect)frame letterData:(NSMutableArray*) mtAry
{
    self = [super initWithFrame:frame];
    letterDS=[mtAry mutableCopy];
    letterTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 350)];
    
    letterTable.delegate=self;
    letterTable.dataSource=self;
    [letterTable.layer setCornerRadius:5];
    letterTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [letterTable setSeparatorInset:UIEdgeInsetsZero];
    [letterTable setLayoutMargins:UIEdgeInsetsZero];
    [self addSubview:letterTable];
    
    return self;
}


+ (instancetype)defaultPopupView:(NSMutableArray*) nickMA{
    return [[PopLetterListView alloc]initWithFrame:CGRectMake(0, 0, 250, 350) letterData:nickMA];
}

-(void) dismissMyTable{
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}
//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return [letterDS count];
}

//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             
                             SimpleTableIdentifier];
    NSUInteger rowNum=indexPath.row;
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(205, 10, 10, 10)];
    UIImageView *rIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck_sex"]];

    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                
                                      reuseIdentifier: SimpleTableIdentifier] ;
        cell.textLabel.text=[NSString stringWithFormat:@"%@%@%@",@"物业(",[[letterDS objectAtIndex:rowNum] valueForKey:@"user_nick"],@")"];
        [rightView addSubview:rIV];
        [cell.contentView addSubview:rightView];
    }
    return cell;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//改变行的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}

//选中Cell响应事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* senderId =[NSString stringWithFormat:@"%@",[[letterDS objectAtIndex:indexPath.row] valueForKey:@"user_id"]];
    NSString* nickName = [[letterDS objectAtIndex:indexPath.row] valueForKey:@"user_nick"];
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:senderId conversationType:EMConversationTypeChat];
    chatVC.title = nickName;
    [self.parentVC.navigationController  pushViewController:chatVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissMyTable];
}
@end
