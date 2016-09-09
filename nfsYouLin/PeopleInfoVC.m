//
//  PeopleInfoVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/8.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PeopleInfoVC.h"

@interface PeopleInfoVC ()

@end

@implementation PeopleInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat bgY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    UIImageView* bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, bgY, CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame) - bgY) * 0.4)];
    bgIV.image = [UIImage imageNamed:@"beijing.png"];
    [self.view addSubview:bgIV];
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgIV.frame), CGRectGetWidth(self.view.frame), 200)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate UITableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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
    
}

@end
