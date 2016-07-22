//
//  youLinDiscoveryController.m
//  nfsYouLin
//
//  Created by Macx on 16/5/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "discoveryController.h"
#import "FriendsVC.h"


@interface discoveryController ()

@end

@implementation discoveryController
{
    NSArray* _discoveryServiceName;
    NSArray* _discoveryServiceImages;
    UIColor* _viewColor;
    FriendsVC* _friendsController;
    UITabBarController* _parentController;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    
    self.view.backgroundColor = _viewColor;
    
    /*改变BarItem 图片系统颜色为 自定义颜色 ffba20 */
    UIImage *iImageA = [UIImage imageNamed:@"btn_faxian_a.png"];
    iImageA = [iImageA imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.discoveryTabBarItem.selectedImage = iImageA;
    [self.discoveryTabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : [UIColor whiteColor]
                                               } forState:UIControlStateSelected];
    
    /* uicolor ffba20*/
    UIColor *fontColor= [UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    
    [self.discoveryTabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : fontColor
                                               } forState:UIControlStateSelected];
    
    /*设置页眉控件*/
//    self.tableView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_faxian_a.png"]];
    
    _discoveryServiceName = @[@"邻居", @"商圈", @"公告" ,@"新闻" ,@"天气" ,@"社区服务", @"物业"];
    _discoveryServiceImages = @[@"icon_linju.png", @"icon_shangquan.png" ,@"icon_gonggao.png", @"icon_xinwen.png" ,@"icon_xinwen.png", @"icon_shequfuwu.png", @"icon_wuye.png"];
    
    
    
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
    _friendsController = [storyBoard instantiateViewControllerWithIdentifier:@"friends"];
    
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger elementOfSection;
    switch (section) {
        case 0:
            elementOfSection = 1;
            break;
        case 1:
            elementOfSection = 1;
            break;
        case 2:
            elementOfSection = 3;
            break;
        case 3:
            elementOfSection = 2;
            break;
        default:
            elementOfSection = -1;
            break;
    }
    return elementOfSection;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    NSInteger sectionNo = indexPath.section;
    switch (sectionNo) {
        case 0:
            rowNo = rowNo;
            break;
        case 1:
            rowNo += 1;
            break;
        case 2:
            rowNo += 2;
            break;
        case 3:
            rowNo += 5;
            break;
        default:
            break;
    }
    NSString* identifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_discoveryServiceImages[rowNo]];
    cell.textLabel.text = _discoveryServiceName[rowNo];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 16.f;
    }else
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 3) {
//        return 80.f;
//    }else
    return 8.0f;
}


- (UIView*)tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* headerView = nil;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    headerView.backgroundColor = _viewColor;
    return headerView;
}


- (UIView*)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = nil;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    footerView.backgroundColor = _viewColor;
    return footerView;
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


// 单元格选中
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowInSection = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            // 邻居
            UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"邻居" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.parentViewController.navigationItem setBackBarButtonItem:neighborItem];
            [self.navigationController pushViewController:_friendsController animated:YES];
            
            break;
        }
        case 1:
        {
            // 商圈
            break;
        }
        case 2:
        {
            switch (rowInSection) {
                case 0:
                {
                    // 公告
                    break;
                }
                case 1:
                {
                    // 新闻
                    break;
                }
                case 2:
                {
                    // 天气
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 3:
        {
            switch (rowInSection) {
                case 0:
                {
                    // 社区服务
                    break;
                }
                case 1:
                {
                    // 物业
                    break;
                }
                    
                default:
                    break;
            }
        }
        default:
            break;
    }
}


/* 设置单元格宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

@end
