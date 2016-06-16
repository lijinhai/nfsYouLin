//
//  myCommunityViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "myCommunityViewController.h"
#import "familyAddressViewController.h"

@interface myCommunityViewController ()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation myCommunityViewController{

    familyAddressViewController *familyAddressController;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *list = [NSArray arrayWithObjects:@"保利清华颐园",@"保利颐和家园",nil];
    self.listname = list;
    _communityTable.sectionFooterHeight = 800.0f;
    UIView *footView = [UIView new];
    _communityTable.tableFooterView=footView;
    footView.frame = CGRectMake(0, 0, 0, 0);
    [self.communityTable setTableFooterView:footView];

    }
- (void)viewWillAppear:(BOOL)animated
{
    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIImage *firstButtonImage = [UIImage imageNamed:@"dizhixinxi-nav"];
    UIButton *imageBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [imageBtn setImage:firstButtonImage forState:UIControlStateNormal];
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, 144, 32)];
    textlabel.text=@"哈尔滨市";
    textlabel.textColor=[UIColor whiteColor];
    UIView *rightBarItemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 35)];
    [rightBarItemsView addSubview:imageBtn];
    [rightBarItemsView addSubview:textlabel];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarItemsView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObject:rightBarItem]];    
    self.navigationItem.title=@"";
    /*跳转至填写家庭住址界面*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    familyAddressController = [storyBoard instantiateViewControllerWithIdentifier:@"familyAddressController"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    //NSString *key = [_keys objectAtIndex:section];
    //NSArray *nameSection = [_names objectForKey:key];
    NSLog(@"count is %ld",[self.listname count]);
    return [self.listname count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"community1";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Verdana" size:16];
    //NSLog(@"what is it?");
    
    NSUInteger rowNumber=[indexPath row];
    cell.textLabel.text=[_listname objectAtIndex:rowNumber]; //设置每一行要显示的值
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
    }
#pragma mark 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBarButtonItem* writeFamliyItem = [[UIBarButtonItem alloc] initWithTitle:@"填写家庭住址" style:UIBarButtonItemStylePlain target:nil action:nil];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    familyAddressController.communityNameValue=cell.textLabel.text;
    [self.navigationItem setBackBarButtonItem:writeFamliyItem];
    NSInteger rowInSection = indexPath.row;
    NSLog(@"row %ld",rowInSection);
    NSLog(@"communityNameValue %@",familyAddressController.communityNameValue);
    switch (rowInSection) {
        case 0:
            NSLog(@"点击1");
            [self.navigationController pushViewController:familyAddressController animated:YES];
            //[self findLocation:self];
            break;
        case 1:
            //[self createACard:self];
            NSLog(@"点击2");
            [self.navigationController pushViewController:familyAddressController animated:YES];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

/* 设置单元格宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


@end
