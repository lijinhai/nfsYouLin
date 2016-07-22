//
//  FriendsVC.m
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FriendsVC.h"
#import "FriendViewCell.h"
#import "SegmentView.h"

@interface FriendsVC ()

@end

@implementation FriendsVC
{
    SegmentView* segmentView;
    UIColor *color;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    color = [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    segmentView = [[SegmentView alloc] init];
    
    UIButton* neighborsBtn = segmentView.neighborsBtn;
    segmentView.nLineView.backgroundColor = color;
    [neighborsBtn setTitleColor:color forState:UIControlStateNormal];

    [neighborsBtn addTarget:self action:@selector(neighborsAction:) forControlEvents:UIControlEventTouchDown];
    
    UIButton* chatBtn = segmentView.chatBtn;
    [chatBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:segmentView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(segmentView.frame)) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// 点击好友列表
- (void) neighborsAction: (id)sender
{
    [segmentView.neighborsBtn setTitleColor:color forState:UIControlStateNormal];
    segmentView.nLineView.backgroundColor = color;
    
    [segmentView.chatBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    segmentView.cLineView.backgroundColor = [UIColor whiteColor];
    
}

// 点击聊天记录
- (void) chatAction: (id) sender
{
    [segmentView.neighborsBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    segmentView.nLineView.backgroundColor = [UIColor whiteColor];
    
    [segmentView.chatBtn setTitleColor:color forState:UIControlStateNormal];
    segmentView.cLineView.backgroundColor = color;
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"sss";
//}

// 右侧索引
//- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return keys;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    FriendViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[FriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}




@end
