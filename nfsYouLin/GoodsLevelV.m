//
//  GoodsLevelV.m
//  nfsYouLin
//
//  Created by Macx on 16/8/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "GoodsLevelV.h"
#import "GoodsLevelCell.h"

@implementation GoodsLevelV
{
    UITableView* _tableView;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 4, (CGRectGetHeight([UIScreen mainScreen].bounds) - 350) / 2, CGRectGetWidth([UIScreen mainScreen].bounds) / 2, 350);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }

        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark -UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString* cellId = @"cellId";
    GoodsLevelCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[GoodsLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    switch (row) {
        case 0:
        {
            cell.levelL.text = @"全新";
            break;
        }
        case 1:
        {
            cell.levelL.text = @"九成新";
            break;
        }
        case 2:
        {
            cell.levelL.text = @"八成新";
            break;
        }
        case 3:
        {
            cell.levelL.text = @"七成新";
            break;
        }
        case 4:
        {
            cell.levelL.text = @"六成新";
            break;
        }
        case 5:
        {
            cell.levelL.text = @"五成新";
            break;
        }
        case 6:
        {
            cell.levelL.text = @"五成新以下";
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            NSLog(@"全新");
            break;
        }
        case 1:
        {
            NSLog(@"九成新");
            break;
        }
        case 2:
        {
            NSLog(@"八成新");
            break;
        }
        case 3:
        {
            NSLog(@"七成");
            break;
        }
        case 4:
        {
            NSLog(@"六成");
            break;
        }
        case 5:
        {
            NSLog(@"五成");
            break;
        }
        case 6:
        {
            NSLog(@"五成新以下");
            break;
        }
        default:
            break;
    }
    [_delegate didSelectedLevel:row];
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
