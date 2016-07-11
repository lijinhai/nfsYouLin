//
//  ChooseSexTypeViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ChooseSexTypeViewController.h"

@interface ChooseSexTypeViewController ()

@end

@implementation ChooseSexTypeViewController{
    
    UIColor * _viewColor;
    UIView *_rightView;
    UIImageView *imageView;
    NSInteger rowid;
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=_viewColor;
    rowid=-1;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

  /*表格初始化*/
    _sexTable.dataSource=self;
    _sexTable.delegate=self;
  /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([_sexTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_sexTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_sexTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_sexTable setLayoutMargins:UIEdgeInsetsZero];
    }
    self.navigationItem.title=@"";
    DataSource=@[@"男",@"女",@"保密"];
    
}
- (void)returnText:(ReturnSexTextBlock)block {
    
    self.returnSexTextBlock = block;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       return 3;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *CellIdentifier = @"infoid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_sex_duihao"]];
    _rightView.tag=119;

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        NSLog(@"%@",_sexValue);
        if([_sexValue isEqualToString:@"男"]&&rowNo==0)
        {
            _rightView.frame=CGRectMake(_sexTable.frame.size.width-25, 15, 30, 20);
            [_rightView addSubview:imageView];
            [cell.contentView addSubview:_rightView];
            
        }else if([_sexValue isEqualToString:@"女"]&&rowNo==1){
            
            _rightView.frame=CGRectMake(_sexTable.frame.size.width-25, 15, 30, 20);
            [_rightView addSubview:imageView];
            [cell.contentView addSubview:_rightView];
            
        }else if([_sexValue isEqualToString:@"保密"]&&rowNo==2){
            
            _rightView.frame=CGRectMake(_sexTable.frame.size.width-25, 15, 30, 20);
            [_rightView addSubview:imageView];
            [cell.contentView addSubview:_rightView];
            
        }
    }
    cell.textLabel.text=DataSource[rowNo];
    if(rowid==rowNo)
    {
    
        [(UIView *)[self.view viewWithTag:119] removeFromSuperview];
        _rightView.frame=CGRectMake(_sexTable.frame.size.width-25, 15, 30, 20);
        [_rightView addSubview:imageView];
        [cell.contentView addSubview:_rightView];
        if (self.returnSexTextBlock != nil) {
             self.returnSexTextBlock(cell.textLabel.text);
             NSLog(@"cell.textLabel.text is %@",cell.textLabel.text);
             timer=[NSTimer scheduledTimerWithTimeInterval:0.8
                                                   target:self
                                                 selector:@selector(jumpView)
                                                 userInfo:nil
                                                  repeats:NO];
        }
    }
    return cell;
}

-(void)jumpView{
    
[self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 520.0f;
}
- (UIView*)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = nil;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 520)];
    footerView.backgroundColor = _viewColor;
    return footerView;
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowInSection = indexPath.row;
    NSInteger section = indexPath.section;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    rowid= rowInSection;
    [_sexTable reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
