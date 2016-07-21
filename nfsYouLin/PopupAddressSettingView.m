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
#import "MBProgressHUD.h"
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
    }else if (flagValue==4)//等待审核的当前地址
    {
        [dataSource removeAllObjects];
        dataSource=[NSMutableArray arrayWithObjects:@"修改地址",@"删除地址",@"快速验证",@"取消",nil];
        addressSettingTable = [[UITableView alloc] initWithFrame:frame];
    
    }else if (flagValue==5)//审核失败的当前地址
    {
        [dataSource removeAllObjects];
        dataSource=[NSMutableArray arrayWithObjects:@"修改地址",@"删除地址",@"快速验证",@"取消",nil];
        addressSettingTable = [[UITableView alloc] initWithFrame:frame];
    }
    else if(flagValue==1)//审核成功但非当前地址
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
     return self;
}


+ (instancetype)defaultPopupView:(NSInteger) flagValue tFrame:(CGRect)frame{
    return [[PopupAddressSettingView alloc]initWithFrame:frame clickFieldValue:flagValue];
}
-(void)testfunc{

[addressInfomationController refreshTable];

}
-(void) updateSetMyTable{
    
     self.addressFlag=@"justnow";
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
}

-(void)updateModifyMyTable{

    [addressInfomationController.addressTableView reloadData];
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
}
-(void)hideAddressSettingTable{
    [self setHidden:YES];
    [_parentVC.lewOverlayView removeFromSuperview];
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
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    addressInfomationController=[storyBoard instantiateViewControllerWithIdentifier:@"addressInfomationController"];

    /*通过RGB来定义背景色*/
    UIColor *ycolor = UIColorFromRGB(0xFFBA02);
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = ycolor;
    /**/
     NSLog(@"%@",cell.textLabel.text);
     NSLog(@"celltag is  %ld",self.celltag);
    if([cell.textLabel.text isEqualToString:@"设为当前地址"]){
        
        
        [self setCurrentAddress:self.celltag];
        [self updateSetMyTable];
    
    }else if([cell.textLabel.text isEqualToString:@"修改地址"]){
        /*跳转至填写家庭住址界面*/
        self.changeAddressArray=[self changeFamliyAddress:self.celltag];
        if(self.changeAddressArray!=NULL)
        {
            self.addressFlag=@"jumpAddressInfo";
            NSLog(@"设置标志  %@",self.addressFlag);
        }
        [self updateModifyMyTable];
        
    }else if([cell.textLabel.text isEqualToString:@"删除地址"]){
        
        [self hideAddressSettingTable];
        NSMutableAttributedString *attributedMessage= [[NSMutableAttributedString alloc] initWithString:@"删除后无法恢复，是否删除地址" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:attributedMessage.string preferredStyle:UIAlertControllerStyleAlert];
        [alertController setValue:attributedMessage forKey:@"attributedMessage"];
        alertController.view.tintColor = [UIColor blackColor];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action) {
        NSLog(@"点击了确定按钮");
        self.addressFlag=@"deleteAddressInfo";    
        [self deleteFamliyAddress:self.celltag];
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {  NSLog(@"点击了取消按钮");
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];}];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self.parentVC presentViewController:alertController animated:YES completion:nil];
        
        //[self deleteFamliyAddress:self.celltag];
        
    }else if([cell.textLabel.text isEqualToString:@"快速验证"]){
        
        [self quickVerifyAddress:self.celltag];
        [self updateModifyMyTable];
    
    }else if([cell.textLabel.text isEqualToString:@"取消"]){
    
        [self cancelAddressOprTable];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)textToast:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window  animated:YES];
    
    // Set the annular determinate mode to show task progress.navigationController.view
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor=[UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.minSize=CGSizeMake(50, 50);
    hud.label.text = NSLocalizedString(tips, @"HUD message title");
    
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font= [UIFont systemFontOfSize:15];
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:0.8f];
}

/*设置当前地址*/
- (void) setCurrentAddress:(NSInteger) _id
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory ,  NSUserDomainMask ,  YES );
    NSString* documentPath = [ paths objectAtIndex: 0 ];
    NSString* dbPath = [ documentPath stringByAppendingPathComponent: @"youLin-IOS.db" ];
    FMDatabase* database = [ FMDatabase databaseWithPath: dbPath ];
    if ( ![ database open ] )
    {
        NSLog(@"打开数据库失败");
    }
    // 查找表
    NSString *updateSQL1 = [[NSString alloc] initWithFormat:@"UPDATE table_all_family SET primary_flag = '%d' where _id = '%ld'", 1,_id];
    NSString *updateSQL2 = [[NSString alloc] initWithFormat:@"UPDATE table_all_family SET primary_flag = '%d' where _id != '%ld'", 0,_id];
    [database executeUpdate:updateSQL2];
    BOOL res = [database executeUpdate:updateSQL1];
    // 逐行读取数据
    if (!res) {
        NSLog(@"error when update db table");
    } else {
        NSLog(@"success to update db table");
    }
    [ database close ];

    
}

/*改变家庭地址*/
- (NSMutableArray *) changeFamliyAddress:(NSInteger) _id{

    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:1];
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory ,  NSUserDomainMask ,  YES );
    NSString* documentPath = [ paths objectAtIndex: 0 ];
    NSString* dbPath = [ documentPath stringByAppendingPathComponent: @"youLin-IOS.db" ];
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
        NSInteger entityTypeFlag=[ resultSet intForColumn: @"entity_type" ];
        NSLog(@"entity_type is %ld",entityTypeFlag);
        if(entityTypeFlag==1){
        
            [self textToast:@"审核通过的地址不能修改" ];
             return NULL;
        }
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
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory ,  NSUserDomainMask ,  YES );
    NSString* documentPath = [ paths objectAtIndex: 0 ];
    NSString* dbPath = [ documentPath stringByAppendingPathComponent: @"youLin-IOS.db" ];
    FMDatabase* database = [ FMDatabase databaseWithPath: dbPath ];
    if ( ![ database open ] )
    {
        NSLog(@"打开数据库失败");
    }
    // 查找表
    NSString *updateSQL1 = [[NSString alloc] initWithFormat:@"DELETE  from table_all_family where _id = '%ld'",_id];
    BOOL res = [database executeUpdate:updateSQL1];
    // 逐行读取数据
    if (!res) {
        NSLog(@"error when update db table");
    } else {
        NSLog(@"success to update db table");
    }
    [ database close ];
}

/*快速验证地址*/
- (void) quickVerifyAddress:(NSInteger) _id{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory ,  NSUserDomainMask ,  YES );
    NSString* documentPath = [ paths objectAtIndex: 0 ];
    NSString* dbPath = [ documentPath stringByAppendingPathComponent: @"youLin-IOS.db" ];
    FMDatabase* database = [ FMDatabase databaseWithPath: dbPath ];
    if ( ![ database open ] )
    {
        NSLog(@"打开数据库失败");
        return;
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
        NSInteger primaryFlag=[ resultSet intForColumn: @"primary_flag" ];
        NSLog(@"primaryFlag is %ld",primaryFlag);
        if(primaryFlag==0){
            
            [self textToast:@"请先设置为当前地址" ];
            return;
        }else{
        
            self.addressFlag=@"valiyaddress";
        
        }
        //NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        //[dic setValue:addressCity forKey:@"keycity"];
        //[dic setValue:addressCommunity forKey:@"keycommunity"];
        //[dic setValue:addressPortrait forKey:@"keyportrait"];
        //[dic setValue:addressAptNum forKey:@"keyaptnum"];
        //[array addObject:dic];
    }
    
    [ database close ];
    
}

/*取消*/
-(void) cancelAddressOprTable{

    [self updateModifyMyTable];
}
@end
