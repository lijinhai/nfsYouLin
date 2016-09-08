//
//  ApplyDetailTVC.m
//  nfsYouLin
//
//  Created by Macx on 16/8/30.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ApplyDetailTVC.h"
#import "ApplyDetailCell.h"

@interface ApplyDetailTVC ()

@end

@implementation ApplyDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置分割线的风格
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    self.tableView.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.peopleA count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"  报名人数：%ld个",self.totalNum];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    ApplyDetailCell* cell;
    NSString* managerCellId = @"manager";
    NSString* otherCellId = @"other";
    if(row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:managerCellId];
        if(cell == nil)
        {
            cell = [[ApplyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:managerCellId];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:otherCellId];
        if(cell == nil)
        {
            cell = [[ApplyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellId];
            cell.detailDict = [self.peopleA objectAtIndex:row - 1];
        }
    }
    
    return cell;
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

@end
