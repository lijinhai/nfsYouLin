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
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "SqliteOperation.h"
#import "SqlDictionary.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation PopupAddressSettingView{
    
    addressInfomationViewController *addressInfomationController;
    familyAddressViewController * familyAddressController;
    myCommunityViewController * myCommunityController;
    UINavigationController *navigationController;
    UIBarButtonItem* naviItem;
    NSString* delFlag;
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
    if([cell.textLabel.text isEqualToString:@"设为当前地址"]){
        
        
        [self setCurrentAddress:self.celltag];
        //[self updateSetMyTable];
    
    }else if([cell.textLabel.text isEqualToString:@"修改地址"]){
        /*跳转至填写家庭住址界面*/
        self.changeAddressArray=[self changeFamliyAddress:self.celltag];
        if(self.changeAddressArray!=NULL)
        {
            self.addressFlag=@"jumpAddressInfo";
            NSLog(@"设置标志  %ld",self.celltag);
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
        [self deleteFamliyAddress:self.celltag];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];}];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self.parentVC presentViewController:alertController animated:YES completion:nil];
        
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
    
    NSString* newFamliyId=@"0";
    NSString* neStatus=@"";
    NSString* oldFamliyId=@"";
    NSString* oldNeStatus=@"";
    NSString* audiStatus=@"";
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory ,  NSUserDomainMask ,  YES );
    NSString* documentPath = [ paths objectAtIndex: 0 ];
    NSString* dbPath = [ documentPath stringByAppendingPathComponent: @"youLin-IOS.db" ];
    FMDatabase* database = [ FMDatabase databaseWithPath: dbPath ];
    if ( ![ database open ] )
    {
        NSLog(@"打开数据库失败");
    }
    //查找新famliyId
    NSString *nquery = [NSString stringWithFormat:@"select family_id,ne_status,entity_type from table_all_family where _id= '%ld'", _id];
    FMResultSet* resultSet1 = [ database executeQuery:nquery];
    while ( [ resultSet1 next ] )
    {
      
        newFamliyId=[NSString stringWithFormat:@"%lld",[resultSet1 longLongIntForColumn:@"family_id"]];
        neStatus=[NSString stringWithFormat:@"%d",[resultSet1 intForColumn:@"ne_status"]];
        audiStatus=[NSString stringWithFormat:@"%d",[resultSet1 intForColumn:@"entity_type"]];
        if([audiStatus isEqualToString:@"1"])
        {
            neStatus=@"0";
        }
    }
    NSString *oquery = [NSString stringWithFormat:@"select family_id,ne_status from table_all_family where primary_flag= '%d'", 1];
    FMResultSet* resultSet2 = [ database executeQuery:oquery];
    while ( [ resultSet2 next ] )
    {
        
        oldFamliyId=[NSString stringWithFormat:@"%lld",[resultSet2 longLongIntForColumn:@"family_id"]];
        oldNeStatus=[NSString stringWithFormat:@"%d",[resultSet2 intForColumn:@"ne_status"]];
    }
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* addrHandelCache=[defaults stringForKey:@"addrCache"];
    NSString* userId=[defaults stringForKey:@"userId"];

    
    NSLog(@"addrHandelCache is %@",addrHandelCache);
    NSLog(@"oldFamliyId is %@",oldFamliyId);
    NSLog(@"oldNeStatus is %@",oldNeStatus);
    NSLog(@"neStatus is %@",neStatus);
    NSLog(@"newFamliyId is %@",newFamliyId);
    
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"old_family_id%@old_ne_status%@family_id%@ne_status%@user_id%@addr_cache%@",oldFamliyId,oldNeStatus,newFamliyId,neStatus,userId,addrHandelCache]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1024",hashString]];
    
    
    NSDictionary* parameter = @{@"old_family_id" : oldFamliyId,
                                @"old_ne_status" : oldNeStatus,
                                @"family_id":newFamliyId,
                                @"ne_status":neStatus,
                                @"user_id":userId,
                                @"addr_cache" : addrHandelCache,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"curaddr",
                                @"salt" : @"1024",
                                @"hash" : hashMD5,
                                @"keyset" : @"old_family_id:old_ne_status:family_id:ne_status:user_id:addr_cache:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject is %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            // 查找表
            NSString *updateSQL1 = [[NSString alloc] initWithFormat:@"UPDATE table_all_family SET primary_flag = '%d' where _id = '%ld'", 1,_id];
            NSString *updateSQL2 = [[NSString alloc] initWithFormat:@"UPDATE table_all_family SET primary_flag = '%d' where _id != '%ld'", 0,_id];
            NSString *selectSQL1=[[NSString alloc] initWithFormat:@"SELECT family_community_id FROM table_all_family where _id = '%ld'",_id];
            // 查找表
            FMResultSet* resultSet = [ database executeQuery: selectSQL1];
            // 逐行读取数据
            while ( [ resultSet next ] )
            {
                 NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:[resultSet intForColumn:@"family_community_id"] forKey:@"communityId"];
            }
            [database executeUpdate:updateSQL2];
            BOOL res = [database executeUpdate:updateSQL1];
            // 逐行读取数据
            if (!res) {
                NSLog(@"error when update db table");
            } else {
                NSLog(@"success to update db table");
            }
            [database close];
            [self updateSetMyTable];
        }else{
        
            [database close];
            [self textToast:[responseObject objectForKey:@"yl_msg"]];
            [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);

            [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
    }];
    
}

/*改变家庭地址*/
- (NSMutableArray *) changeFamliyAddress:(NSInteger) _id{

    
//    NSDictionary* parameter = @{@"city_code":cityCode,//当前选择城市码
//                                @"city_id":cityId,// 当前选择城市Id
//                                @"city":city,// 当前选择城市名称
//                                @"community_id":commId,//当前选择小区Id
//                                @"community":commStr,//当前选择小区名称
//                                @"block_id":blockId,//当前选择区块Id，没有时传0
//                                @"block_name":blockStr,//当前选择区块名称
//                                @"buildnum_id":buildNumId,//当前选择楼栋Id
//                                @"buildnum":buildnumStr,//当前选择楼栋名称
//                                @"aptnum_id":aptNumId,//当前选择门牌Id
//                                @"aptnum":aptNumStr,//当前选择门牌名称
//                                @"user_id":userId,//当前用户UserId
//                                @"addr_cache":addrHandelCache,//地址操作次数
//                                @"primary_flag":primaryFlag,//是否为当前地址1表示当前地址，0表示非当前地址
//                                @"deviceType":@"ios",//常量值ios
//                                @"apitype":@"users",//常量值users
//                                @"tag":@"addfamily",//常量值addfamily,
//                                @"salt" : @"1024",
//                                @"hash" :hashMD5,
//                                @"keyset" :@"city_code:city_id:city:community_id:community:block_id:block_name:buildnum_id:buildnum:aptnum_id:aptnum:user_id:addr_cache:primary_flag:",
//                                };
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
        NSString* addressCommunity = [ resultSet stringForColumn: @"family_community_nickname"];
        NSString* addressname = [ resultSet stringForColumn: @"family_address"];
        NSString* addressPortrait=[ resultSet stringForColumn: @"family_building_num"];
        NSString* addressAptNum=[ resultSet stringForColumn: @"family_apt_num"];
        
        NSInteger entityTypeFlag=[ resultSet intForColumn: @"entity_type"];
        NSInteger  commId= [ resultSet intForColumn: @"family_community_id"];
        NSInteger  buildNumId= [ resultSet intForColumn: @"family_building_id"];
        long  familyId=[ resultSet  longLongIntForColumn:@"family_id"];
        NSInteger  neStatus=[ resultSet intForColumn: @"ne_status"];
        //family_building_id
        NSLog(@"familyId is %ld",familyId);
        NSLog(@"entity_type is %ld",entityTypeFlag);
        NSLog(@"addressCommunity is %@",addressCommunity);
        NSLog(@"addressPortrait is %@",addressPortrait);
        NSLog(@"addressAptNum is %@",addressAptNum);
        NSLog(@"neStatus is %ld",neStatus);
        if(entityTypeFlag==1){
        
            [self textToast:@"审核通过的地址不能修改" ];
             return NULL;
        }
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        
        [dic setValue:addressCity forKey:@"keycity"];
        [dic setValue:addressCommunity forKey:@"keycommunity"];
        [dic setValue:addressPortrait forKey:@"keyportrait"];
        [dic setValue:addressAptNum forKey:@"keyaptnum"];
        [dic setValue:[NSString stringWithFormat:@"%ld",commId] forKey:@"keycommid"];
        [dic setValue:[NSString stringWithFormat:@"%ld",buildNumId] forKey:@"keyBuildId"];
        [dic setValue:[NSString stringWithFormat:@"%ld",familyId] forKey:@"keyFamilyId"];
        [dic setValue:[NSString stringWithFormat:@"%ld",neStatus] forKey:@"keyNeStatus"];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:[[dic valueForKey:@"keycommid"] integerValue] forKey:@"keycommid"];
        [defaults setInteger:[[dic valueForKey:@"keyBuildId"] integerValue] forKey:@"keyBuildId"];
        [defaults setInteger:[[dic valueForKey:@"keyaptnum"] integerValue] forKey:@"keyaptnum"];
        [defaults setInteger:[[dic valueForKey:@"keyFamilyId"] integerValue] forKey:@"keyFamilyId"];
        [defaults setInteger:[[dic valueForKey:@"keyNeStatus"] integerValue] forKey:@"keyNeStatus"];
        [defaults setValue:addressPortrait forKey:@"keyportrait"];
        [defaults synchronize];
        
        [array addObject:dic];
    }
    
    [ database close ];
    return array;

}

/*删除家庭地址*/
- (void) deleteFamliyAddress:(NSInteger) _id{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory ,  NSUserDomainMask ,  YES );
    NSString* documentPath = [ paths objectAtIndex: 0 ];
    NSInteger primaryFlag = 0;
    NSInteger record=0;
    NSString* dbPath = [ documentPath stringByAppendingPathComponent: @"youLin-IOS.db" ];
    FMDatabase* database = [ FMDatabase databaseWithPath: dbPath ];
    if ( ![ database open ] )
    {
        NSLog(@"打开数据库失败");
    }
    NSString *query = [NSString stringWithFormat:@"select primary_flag,family_address_id from table_all_family where _id= '%ld'", _id];
    FMResultSet* resultSet = [ database executeQuery:query];
    while ( [ resultSet next ] )
    {
       primaryFlag=[ resultSet intForColumn: @"primary_flag" ];
       record=[ resultSet intForColumn: @"family_address_id" ];
    }
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy.allowInvalidCertificates = YES;
     manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     NSString* userId = [defaults stringForKey:@"userId"];
     NSString* addrHandelCache=[defaults stringForKey:@"addrCache"];
     NSString*  flagStr=[NSString stringWithFormat:@"%ld",primaryFlag];
     NSString* recordId=[NSString stringWithFormat:@"%ld",record];
     NSLog(@"flagStr is %@",flagStr);
     NSLog(@"recordId is %@",recordId);
     NSLog(@"addrHandelCache is %@",addrHandelCache);
     NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"record_id%@flag%@user_id%@addr_cache%@",recordId,flagStr,userId,addrHandelCache]];
     NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1024",hashString]];
     NSDictionary* parameter = @{@"record_id" : recordId,
                                @"flag" : flagStr,
                                @"user_id":userId,
                                @"addr_cache" : addrHandelCache,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"delfamily",
                                @"salt" : @"1024",
                                @"hash" : hashMD5,
                                @"keyset" : @"record_id:flag:user_id:addr_cache:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject is %@",responseObject);
        
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
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
         self.addressFlag=@"deleteAddressInfo";
        }else{
         self.addressFlag=@"other";
        }
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        self.addressFlag=@"other";
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
    }];

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
