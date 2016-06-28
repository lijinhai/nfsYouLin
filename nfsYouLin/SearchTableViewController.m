//
//  SearchTableViewController.m
//  nfsYouLin
//
//  Created by Macx on 16/6/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchBarView.h"
#import "ListTableView.h"
#import "BackgroundView.h"
#import "NeighborTableViewCell.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController
{
    ListTableView* _listTableView;
    BackgroundView* _backGroundView;
    SearchBarView* _searchBar;
    UIButton* _leftButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSearchBar];
    [self setListView];
}


// 表格分区包含多少元素
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// 表格包含分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellOther = @"cellOther";
    static NSString* cellAnother = @"cellAnother";
     NeighborTableViewCell* cell;
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellOther];
        if(cell == nil)
        {
            cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOther];
            
        }

    }
    else if(indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellAnother];
        if(cell == nil)
        {
            cell = [[NeighborTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellAnother];
        }
    }

    cell.delegate = self;
    return cell;
}


// 表格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        return 40;
    }
    else
    {
//        NeighborDataFrame *frame = self.neighborDataArray[indexPath.section];
//        NSInteger height = frame.cellHeight + 1;
//        return height;
        return 80;
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SearchTableViewController didSelectRowAtIndexPath!");
}

- (void) createSearchBar
{
    _searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height / 4, self.view.bounds.size.width - 120, self.navigationController.navigationBar.frame.size.height / 2)];
    
    _searchBar.placeholder = @"请输入关键字";
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.font = [UIFont systemFontOfSize:14];
    
    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchItem:)];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mm_title_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItem:)];
    //    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItems = @[leftItem, searchItem];
    
    
    _leftButton = _searchBar.leftButton;
    [_leftButton setTitle:@"搜全部" forState:UIControlStateNormal];

    [_leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];


}

- (void) setListView
{
//     UINavigationController* navigationController = self.navigationController;
    
    _listTableView = [[ListTableView alloc] initWithFrame:CGRectMake(60 + 5, CGRectGetMaxY(self.navigationController.navigationBar.frame), 150, 250)];
    
    _backGroundView = [[BackgroundView alloc] initWithFrame:self.parentViewController.view.frame view:_listTableView];
    BackgroundView* backGroundView = _backGroundView;
    NSArray* nameArray = @[@"搜索全部", @"搜索话题", @"搜索活动", @"搜索公告", @"搜索建议"];
    NSArray* imageArray = @[@"quanbusou", @"huatisou", @"huodongsou", @"gonggaosou", @"jianyisou"];
    UIButton* leftButton = _leftButton;
    [_listTableView setListTableView:nameArray image:imageArray block:^(NSString* string){
        NSString* newString = [string stringByReplacingOccurrencesOfString:@"索" withString:@""];[leftButton setTitle:newString forState:UIControlStateNormal];
            [backGroundView removeFromSuperview];
    }];
}

- (IBAction)backItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
	
- (IBAction)searchItem:(id)sender
{
    [_searchBar resignFirstResponder];
    NSLog(@"搜索");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftButton:(UIButton *)leftButton
{

    [self.parentViewController.view addSubview:_backGroundView];
    [self.parentViewController.view addSubview:_listTableView];
}

@end
