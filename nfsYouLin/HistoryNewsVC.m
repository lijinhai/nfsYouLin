//
//  HistoryNewsVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/14.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "HistoryNewsVC.h"
#import "NewsCell.h"
#import "NewsDetailVC.h"
#import "SqlDictionary.h"
#import "SqliteOperation.h"
#import "HeaderFile.h"
#import "AppDelegate.h"
#import "JSONKit.h"
@interface HistoryNewsVC ()

@end

@implementation HistoryNewsVC
{
    UIScrollView* _scrollView;
    NSMutableArray* _newInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = BackgroundColor;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    _newInfo = [NSMutableArray array];
    [self excuteSql];
}

#pragma mark -数据库新闻表获取
- (void) excuteSql
{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    FMDatabase *db = delegate.db;
    
    if([db open])
    {
        NSMutableDictionary* newsDict = [[NSMutableDictionary alloc] init];
        FMResultSet *result = [db executeQuery:@"SELECT * FROM table_news_receive"];
        while ([result next])
        {
            NSString* pushTime = [NSString stringWithFormat:@"%d",[result intForColumn:@"news_push_time"]];
            newsDict[pushTime] = [result stringForColumn:@"news_others"];
        }
        [db close];
        
        for(id key in newsDict)
        {
            NSString* newsStr = newsDict[key];
            NSDictionary* newsDict = (NSDictionary*)[newsStr objectFromJSONString];
            [_newInfo addObject:newsDict];
            [self loadNewsContent:0 end:[_newInfo count]];
        }
        
    }
    else
    {
        NSLog(@"CreateTopicVC table_all_family: db open error!");
    }
//    [self loadNewsContent:0 end:[_newInfo count]];
}

#pragma mark -UITableDelegate UITableDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* newsDict = [_newInfo objectAtIndex:tableView.tag];
    NSArray* newsArr = [newsDict valueForKey:@"otherNew"];
    return [newsArr count] + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if(row == 0)
    {
        return 150;
    }
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* titleId = @"titleId";
    static NSString* otherId = @"otherId";
    NSInteger row = indexPath.row;
    NewsCell* cell;
    
    NSDictionary* infoNew = [_newInfo objectAtIndex:tableView.tag];
    
    if(row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:titleId];
        if(cell == nil)
        {
            cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleId];
        }
        cell.titleNew = infoNew;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:otherId];
        if(cell == nil)
        {
            cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherId];
        }
        NSArray* infoArr = [infoNew valueForKey:@"otherNew"];
        NSDictionary* singleNew = [infoArr objectAtIndex:row - 1];
        cell.newsInfo = singleNew;
        
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
    NSInteger row = indexPath.row;
    NSDictionary* newsDict = [_newInfo objectAtIndex:tableView.tag];
    NSArray* newsArr = [newsDict valueForKey:@"otherNew"];
    NSString* itemStr = [newsDict valueForKey:@"subName"];
    NewsDetailVC *newsDetailVC = [[NewsDetailVC alloc] init];
    if(row == 0)
    {
        newsDetailVC.newsUrl = [newsDict valueForKey:@"new_url"];
    }
    else
    {
        NSDictionary* subDict = [newsArr objectAtIndex:row - 1];
        newsDetailVC.newsUrl = [subDict valueForKey:@"new_url"];
    }
    
    UIBarButtonItem* newsItem = [[UIBarButtonItem alloc] initWithTitle:itemStr style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newsItem];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
    
}


#pragma mark -加载新闻内容控件
- (void) loadNewsContent:(NSInteger)start end:(NSInteger)end
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    CGFloat Y = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10;
    for(NSInteger i = start;i < end;i ++)
    {
        NSDictionary* infoDict = [_newInfo objectAtIndex:i];
        NSInteger time = [[infoDict valueForKey:@"push_time"] integerValue]  / 1000;
        NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSString* timeStr = [formatter stringFromDate:timeDate];
        
        UILabel* timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, Y, CGRectGetWidth(self.view.frame), 40)];
        timeL.text = timeStr;
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.enabled = NO;
        [_scrollView addSubview:timeL];
        
        Y = CGRectGetMaxY(timeL.frame) + 10;
        
        NSArray* otherNews = [infoDict valueForKey:@"otherNew"];
        
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, Y, CGRectGetWidth(self.view.frame) - 70, 60 * [otherNews count] + 153)];
        tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tableView.layer.borderWidth = 1.5f;
        tableView.layer.cornerRadius = 6;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
        tableView.bounces = NO;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_scrollView addSubview:tableView];
        Y = CGRectGetMaxY(tableView.frame) + 10;
    }
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), Y);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
