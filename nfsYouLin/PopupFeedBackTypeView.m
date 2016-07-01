//
//  PopupFeedBackTypeView.m
//  nfsYouLin
//
//  Created by jinhai on 16/6/30.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PopupFeedBackTypeView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "FeedbackViewController.h"
@implementation PopupFeedBackTypeView{

    UIImageView *selectUIRadio;
    UIImageView *selectFunctionRadio;
    UIImageView *selectOtherRadio;
    UIView *rightView1;
    UIView *rightView2;
    UIView *rightView3;
    FeedbackViewController *feedbackController;
    NSUInteger selectNum;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    feedbackTypeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 120)];
    
    feedbackTypeTable.delegate=self;
    feedbackTypeTable.dataSource=self;
    [feedbackTypeTable.layer setCornerRadius:5];
    feedbackTypeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [feedbackTypeTable setSeparatorInset:UIEdgeInsetsZero];
    [feedbackTypeTable setLayoutMargins:UIEdgeInsetsZero];
    [self addSubview:feedbackTypeTable];
    
    return self;
}


+ (instancetype)defaultPopupView{
    return [[PopupFeedBackTypeView alloc]initWithFrame:CGRectMake(0, 0, 200, 120)];
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
    return 3;
}

//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             
                             SimpleTableIdentifier];
    NSUInteger rowNum=indexPath.row;
    UIImage *image1= [UIImage imageNamed:@"checked_sex"];
    UIImage *image2= [UIImage imageNamed:@"uncheck_sex"];
    
    rightView1 = [[UIView alloc] initWithFrame:CGRectMake(170, 13, 10, 10)];
    rightView2 = [[UIView alloc] initWithFrame:CGRectMake(170, 13, 10, 10)];
    rightView3 = [[UIView alloc] initWithFrame:CGRectMake(170, 13, 10, 10)];
    
    selectUIRadio = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck_sex"]];
    selectFunctionRadio = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck_sex"]];
    selectOtherRadio = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck_sex"]];
    //rightVeiw.tag=119;
    //rightVeiw2.tag=120;
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                
                                      reuseIdentifier: SimpleTableIdentifier] ;
        switch (rowNum) {
            case 0:
                cell.textLabel.text=@"界面";
                selectUIRadio.frame=CGRectMake(0,0,15,15);
                NSLog(@"self.feedTypeValue is %@",self.feedTypeValue);
                if([self.feedTypeValue isEqualToString:@"界面"])
                {
                 selectUIRadio.image=image1;
                }else{
                 selectUIRadio.image=image2;
                }
                [rightView1 addSubview:selectUIRadio];
                [cell.contentView addSubview:rightView1];
                break;
            case 1:
                cell.textLabel.text=@"功能";
                selectFunctionRadio.frame=CGRectMake(0,0,15,15);
                if([self.feedTypeValue isEqualToString:@"功能"])
                {
                
                 selectFunctionRadio.image=image1;
                }else{
                
                selectFunctionRadio.image=image2;
                }
                
                [rightView2 addSubview:selectFunctionRadio];
                [cell.contentView addSubview:rightView2];
                break;
            case 2:
      
                cell.textLabel.text=@"其他";
                selectOtherRadio.frame=CGRectMake(0,0,15,15);
                if([self.feedTypeValue isEqualToString:@"其他"])
                {
                 selectOtherRadio.image=image1;
                }else{
                
                 selectOtherRadio.image=image2;
                }
                [rightView3 addSubview:selectOtherRadio];
                [cell.contentView addSubview:rightView3];
                break;
                
            default:
                break;
        }
        
    }
    //NSLog(@"%ld",[indexPath section]);
    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cell.textLabel.text forKey:@"typeKey"];
    [defaults setInteger:indexPath.row forKey:@"typeId"];
    [defaults synchronize];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissMyTable];
}
@end
