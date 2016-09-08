//
//  PhonesView.m
//  nfsYouLin
//
//  Created by Macx on 16/9/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PhonesView.h"
#import "PhonesCell.h"
#import "HeaderFile.h"
@implementation PhonesView
{
    UITableView* _tableView;
    NSMutableArray* _phoneArr;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.layer.cornerRadius = 3;
        _tableView.layer.borderColor = [BackgroundColor CGColor];
        _tableView.layer.borderWidth = 1;
        [self addSubview:_tableView];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

- (void)reloadView:(CGRect)frame array:(NSMutableArray*)phoneArr
{
    _phoneArr = phoneArr;
    self.frame = frame;
    _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    [_tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_phoneArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell* ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    PhonesCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[PhonesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.phoneL.text = [_phoneArr objectAtIndex:indexPath.row];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate selectedPhone:[_phoneArr objectAtIndex:indexPath.row]];
    [self removeFromSuperview];
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



@end
