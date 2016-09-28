//
//  DownListView.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DownListView.h"
#import "DownListCell.h"
#import "Masonry.h"
#import "HeaderFile.h"
@implementation DownListView
{
    NSMutableArray* _nameArray;
    UITableView* _tableView;
    UIView *blackView ;
}
- (id)initWithArray:(CGRect)frame array:(NSMutableArray*)nameArray
{
    self = [super init];
    if(self)
    {
        _nameArray = nameArray;
        self.frame = frame;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        //_tableView.separatorColor = [UIColor darkGrayColor];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }

        blackView = [[UIView alloc] initWithFrame:CGRectMake(-screenWidth/2-1, 0,screenWidth*2, screenHeight)];
        blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:blackView];
        UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
        [recognizerTap setNumberOfTapsRequired:1];
         recognizerTap.cancelsTouchesInView = NO;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
        [self addSubview:_tableView];
        
    }
    
    return self;
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![self pointInside:[self convertPoint:location fromView:self.window] withEvent:nil]){
            if(_selectId == 1)
            {
             
                _parentVC.typeRL.textColor = UIColorFromRGB(0x000000);
                _parentVC.leftUpArrowIV.image = [UIImage imageNamed:@"sanjiao_2"];
            }else{
                
                _parentVC.orderRL.textColor = UIColorFromRGB(0x000000);
                _parentVC.rightUpArrowIV.image = [UIImage imageNamed:@"sanjiao_2"];
            }
            [self removeGestureRecognizer:sender];
            [self removeFromSuperview];
        }  
    }  
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell* ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    DownListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[DownListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.defaultV = _defaultSV;
    cell.action = [_nameArray objectAtIndex:indexPath.row];
   
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_selectId == 1)
    {
      
       _parentVC.typeRL.text = _nameArray[indexPath.row];
       _parentVC.typeRL.textColor = UIColorFromRGB(0x000000);
       _parentVC.leftUpArrowIV.image = [UIImage imageNamed:@"sanjiao_2"];
    }else{
    
       _parentVC.orderRL.text = _nameArray[indexPath.row];
       _parentVC.orderRL.textColor = UIColorFromRGB(0x000000);
       _parentVC.rightUpArrowIV.image = [UIImage imageNamed:@"sanjiao_2"];
    }
    [self removeFromSuperview];
    [_parentVC refreshChildViewController];
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
