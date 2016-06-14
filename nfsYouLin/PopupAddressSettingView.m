//
//  PopupAddressSettingView.m
//  nfsYouLin
//
//  Created by jinhai on 16/6/8.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PopupAddressSettingView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationRight.h"
#import "addressInfomationViewController.h"
#import "familyAddressViewController.h"
#import "myCommunityViewController.h"
#import "FMDB.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation PopupAddressSettingView{
    
    addressInfomationViewController *addressInfomationController;
    familyAddressViewController * familyAddressController;
    myCommunityViewController * myCommunityController;
    UINavigationController *navigationController;
    UIBarButtonItem* naviItem;
    //NSString *sectionTitle;
}


- (id)initWithFrame:(CGRect)frame clickFieldValue:(NSInteger) flagValue
{
    self = [super initWithFrame:frame];
    if(flagValue==2)//审核失败
    {
      [dataSource removeAllObjects];
      dataSource=[NSMutableArray arrayWithObjects:@"设为当前地址",@"修改地址",@"删除地址",@"快速验证",@"取消",nil];
       addressSettingTable = [[UITableView alloc] initWithFrame:frame];
    }else if(flagValue==1)//审核成功但非当前地址
    {
       [dataSource removeAllObjects];
        dataSource=[NSMutableArray arrayWithObjects:@"设为当前地址",@"修改地址",@"删除地址",@"取消",nil];
        addressSettingTable = [[UITableView alloc] initWithFrame:frame];
       
    }else if(flagValue==3){//审核成功且为当前地址
 
     [dataSource removeAllObjects];
      dataSource=[NSMutableArray arrayWithObjects:@"修改地址",@"删除地址",@"取消",nil];
        addressSettingTable = [[UITableView alloc] initWithFrame:frame];
    
    }else if(flagValue==0){//等待审核
        
    
     [dataSource removeAllObjects];
      dataSource=[NSMutableArray arrayWithObjects:@"设为当前地址",@"修改地址",@"删除地址",@"快速验证",@"取消",nil];
      addressSettingTable = [[UITableView alloc] initWithFrame:frame];
    }
     addressSettingTable.delegate=self;
     addressSettingTable.dataSource=self;
    [addressSettingTable.layer setCornerRadius:5];
     addressSettingTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [addressSettingTable setSeparatorInset:UIEdgeInsetsZero];
    [addressSettingTable setLayoutMargins:UIEdgeInsetsZero];
    [self addSubview:addressSettingTable];
    /*跳转至填写家庭住址界面*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    familyAddressController = [storyBoard instantiateViewControllerWithIdentifier:@"familyAddressController"];

    return self;
}


+ (instancetype)defaultPopupView:(NSInteger) flagValue tFrame:(CGRect)frame{
    return [[PopupAddressSettingView alloc]initWithFrame:frame clickFieldValue:flagValue];
}

-(void) dismissMyTable{
    
    [addressInfomationController.addressTableView reloadData];
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
}


//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
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
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.text=[dataSource objectAtIndex:[indexPath row]];
    return cell;
    
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

//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    navigationController = (UINavigationController *)self.window.rootViewController;

    /*通过RGB来定义背景色*/
    UIColor *ycolor = UIColorFromRGB(0xFFBA02);
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = ycolor;
    /**/
     NSLog(@"%@",cell.textLabel.text);
     NSLog(@"celltag is  %ld",self.celltag);
    if([cell.textLabel.text isEqualToString:@"设为当前地址"]){
        
        [self setCurrentAddress:self.celltag];
    
    }else if([cell.textLabel.text isEqualToString:@"修改地址"]){
        
        naviItem = [[UIBarButtonItem alloc] initWithTitle:@"填写家庭住址" style:UIBarButtonItemStylePlain target:nil action:nil];
        navigationController.navigationItem.title=@"填写家庭住址";
        //[navigationController.navigationItem setBackBarButtonItem:naviItem];
        familyAddressController.changeAddressArry=[self changeFamliyAddress:self.celltag];
        [familyAddressController.myfamilyAddressTableView reloadData];
        [navigationController pushViewController:familyAddressController animated:YES];
        
    }else if([cell.textLabel.text isEqualToString:@"删除地址"]){
        
        [self deleteFamliyAddress:self.celltag];
        
    }else if([cell.textLabel.text isEqualToString:@"快速验证"]){
        
        [self quickVerifyAddress:self.celltag];
    
    }else if([cell.textLabel.text isEqualToString:@"取消"]){
    
        [self cancelAddressOprTable];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissMyTable];
}

/*设置当前地址*/
- (void) setCurrentAddress:(NSInteger) _id
{
    
}

/*改变家庭地址*/
- (NSMutableArray *) changeFamliyAddress:(NSInteger) _id{

    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:1];
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory ,  NSUserDomainMask ,  YES );
    NSString* documentPath = [ paths objectAtIndex: 0 ];
    NSString* dbPath = [ documentPath stringByAppendingPathComponent: @"neighbors.db" ];
    FMDatabase* database = [ FMDatabase databaseWithPath: dbPath ];
    if ( ![ database open ] )
    {
        NSLog(@"打开数据库失败");
        return nil;
    }
    // 查找表
    NSString *query = [NSString stringWithFormat:@"select * from table_all_family where _id= '%ld'", _id];
    FMResultSet* resultSet = [ database executeQuery:query];
    // 逐行读取数据
    while ( [ resultSet next ] )
    {
        // 对应字段来取数据
        NSString* addressCity = [ resultSet stringForColumn: @"family_city" ];
        NSString* addressCommunity = [ resultSet stringForColumn: @"family_community" ];
        NSString* addressPortrait=[ resultSet stringForColumn: @"family_portrait" ];
        NSString* addressAptNum=[ resultSet stringForColumn: @"family_apt_num" ];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        
        [dic setValue:addressCity forKey:@"keycity"];
        [dic setValue:addressCommunity forKey:@"keycommunity"];
        [dic setValue:addressPortrait forKey:@"keyportrait"];
        [dic setValue:addressAptNum forKey:@"keyaptnum"];
        [array addObject:dic];
    }
    
    [ database close ];
    return array;

}

/*删除家庭地址*/
- (void) deleteFamliyAddress:(NSInteger) _id{
    
    
    
}

/*快速验证地址*/
- (void) quickVerifyAddress:(NSInteger) _id{
    
    
    
}

/*取消*/
-(void) cancelAddressOprTable{

    [self dismissMyTable];
}
@end
