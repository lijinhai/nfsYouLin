//
//  PopupView.m
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import "PopupFloorView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationDrop.h"
#import "familyAddressViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation PopupView{

    familyAddressViewController *familyAddressController;
    NSString *sectionTitle;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame textFieldTag:(NSInteger) tagValue
{
    NSString *path=nil;
    self = [super initWithFrame:frame];
    floorOrPlateDataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 320)];
    if(tagValue==1001)
    {
        path = [[NSBundle mainBundle] pathForResource:@"floor" ofType:@"plist"];
        self.floororPlateDic = [[NSDictionary alloc]initWithContentsOfFile:path];
        self.floorOrPlateNumAry= [[self.floororPlateDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        sectionTitle=@"请选择下列楼栋号";
    }else{
    
        path = [[NSBundle mainBundle] pathForResource:@"doorplate" ofType:@"plist"];
        self.floororPlateDic = [[NSDictionary alloc]initWithContentsOfFile:path];
        self.floorOrPlateNumAry= [[self.floororPlateDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        sectionTitle=@"请选择下列门牌号";
    
    }
    floorOrPlateDataTable.delegate=self;
    floorOrPlateDataTable.dataSource=self;
    [floorOrPlateDataTable.layer setCornerRadius:5];
    floorOrPlateDataTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [floorOrPlateDataTable setSeparatorInset:UIEdgeInsetsMake(0,15, 0, 15)];
    [floorOrPlateDataTable setLayoutMargins:UIEdgeInsetsMake(0,15, 0, 15)];
    [self addSubview:floorOrPlateDataTable];
    
    return self;
}


+ (instancetype)defaultPopupView:(NSInteger) tagValue{
    return [[PopupView alloc]initWithFrame:CGRectMake(0, 0, 250, 320)textFieldTag:tagValue];
}

-(void) dismissMyTable{

    [familyAddressController.myfamilyAddressTableView reloadData];
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDrop new]];
}
//Section总数
// Section Titles

//每个section显示的标题

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //NSString *sectionTitle=@"请选择下列楼栋号";
    return sectionTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionNowTitle = [self tableView:tableView titleForHeaderInSection:section];
    UIImage *fenGeXianImage = [UIImage imageNamed:@"fengexian"];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 29, 250, 1)];
    imageView.image=fenGeXianImage;
    if (sectionNowTitle == nil) {
        return  nil;
    }
    
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 4, 220, 22);
    label.font=[UIFont systemFontOfSize:13];
    label.text = sectionNowTitle;
    label.textColor=UIColorFromRGB(0xFFBA02);
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
    [sectionView addSubview:label];
    [sectionView addSubview:imageView];
    return sectionView;
}

//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_floorOrPlateNumAry count];
}

//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             
                             SimpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                 
                                       reuseIdentifier: SimpleTableIdentifier] ;
        
    }
    //NSLog(@"%ld",[indexPath section]);
    NSString *floorNum = [self.floorOrPlateNumAry objectAtIndex:[indexPath row]];
    cell.textLabel.text =[_floororPlateDic objectForKey:floorNum];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*tableViewCell 下划线 长度设置为屏幕的宽*/
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,15, 0, 15)];
    }
}
//改变行的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
    
}

//选中Cell响应事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cell.textLabel.text forKey:@"floorKey"];
    [defaults synchronize];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissMyTable];
   }
@end
