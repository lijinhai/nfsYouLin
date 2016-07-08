//
//  ProfessionSettingViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ProfessionSettingViewController.h"

@interface ProfessionSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ProfessionSettingViewController{

    UIColor *_viewColor;
    UISwitch *switchWorkerButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=_viewColor;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"";
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    /*表格初始化*/
    _workSettingTable.dataSource=self;
    _workSettingTable.delegate=self;
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([_workSettingTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_workSettingTable setSeparatorInset:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    
    if ([_workSettingTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_workSettingTable setLayoutMargins:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    self.navigationItem.title=@"";
    _workerNameTextField.backgroundColor=[UIColor whiteColor];
    if(![_workerValue isEqualToString:@""])
    {
        _workerNameTextField.text=_workerValue;
    }
}

- (void)returnText:(ReturnWorkerTextBlock)block {
    
    self.returnWorkerTextBlock = block;
}

-(void)sureAction{


    if (self.returnWorkerTextBlock != nil) {
        self.returnWorkerTextBlock(_workerNameTextField.text);
        NSLog(@"_workerNameTextField is %@",_workerNameTextField.text);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *CellIdentifier = @"infoid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *tiplabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 40, tableView.frame.size.width,60)];
    tiplabel.font=[UIFont systemFontOfSize:14];
    tiplabel.text=@"找到更多同兴趣的好友，一起交流进步，与此同时也能与其他行\n业的好友进行沟通，扩展知识面，发现自己感兴趣的圈子，从而\n丰富自己的生活";
    //tiplabel.textAlignment=NSTextAlignmentCenter;
    tiplabel.textColor=[UIColor darkGrayColor];
    tiplabel.numberOfLines=0;
    
     UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width,20)];
    titleLabel.text=@"公开职业的好处";
    titleLabel.font=[UIFont systemFontOfSize:17];
    
    
    switchWorkerButton = [[UISwitch alloc] initWithFrame:CGRectMake(tableView.frame.size.width-70, 10, 40, 5)];
    [switchWorkerButton setOn:YES];
    [switchWorkerButton addTarget:self action:@selector(switchWorkerAction) forControlEvents:UIControlEventValueChanged];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
       
        if(rowNo==0)
        {
          
            [cell.contentView addSubview:switchWorkerButton];
             cell.textLabel.text=@"公开职业：";
            
        }else{
        
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:tiplabel];
        
        }
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        
    }
    //[tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    return cell;

}
- (void)switchWorkerAction
{
    
    NSLog(@"开启WorkerAction");

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row
       == 1)
    {
        return 100;
    }
    else
        return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 380.0f;
}
- (UIView*)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = nil;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 370)];
    footerView.backgroundColor = _viewColor;
    return footerView;
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
}
@end
