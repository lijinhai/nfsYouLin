//
//  PopChangeAddress.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PopChangeAddress.h"
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
#import "addressInfoTVC.h"

@implementation PopChangeAddress{
    
    addressInfomationViewController *addressInfomationController;
    familyAddressViewController * familyAddressController;
    myCommunityViewController * myCommunityController;
    UINavigationController *navigationController;
    UIBarButtonItem* naviItem;
    NSString* delFlag;
    NSString *sectionTitle;
}


- (id)initWithFrame:(CGRect)frame clickFieldValue:(NSString*) flagValue
{
    self = [super initWithFrame:frame];
    UIView* backV=[[UIView alloc] initWithFrame:frame];
    backV.backgroundColor=[UIColor whiteColor];
    backV.layer.cornerRadius=6;
    self.layer.cornerRadius=6;
    if([flagValue isEqualToString:@""])
    {
    
      sectionTitle=@"  您还没有设置地址";
    }else{
      NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
      sectionTitle=[NSString stringWithFormat:@"  %@%@%@",[defaults valueForKey:@"nick"],@"@",flagValue];
    }
    
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, frame.size.width, 30);
    label.font=[UIFont systemFontOfSize:14];
    label.text = sectionTitle;
    label.textColor=UIColorFromRGB(0xFFBA02);
    label.backgroundColor=[UIColor whiteColor];
    label.layer.cornerRadius=6;
    
      [dataSource removeAllObjects];
       dataSource = [self getAddressList];
     addressSettingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, frame.size.width, frame.size.height-62)];
     addressSettingTable.delegate=self;
     addressSettingTable.dataSource=self;
     addressSettingTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [addressSettingTable setSeparatorInset:UIEdgeInsetsZero];
    [addressSettingTable setLayoutMargins:UIEdgeInsetsZero];
    
    UIView *jumpV=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width, 20)];
    jumpV.backgroundColor=[UIColor whiteColor];
    jumpV.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAddressSettingAction)];
    [jumpV addGestureRecognizer:tapGesture];

    UILabel *jumpLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, frame.size.width-60, 20)];
    jumpLab.text=@"   地址信息";
    jumpLab.font=[UIFont systemFontOfSize:13];
    jumpLab.textColor=[UIColor darkGrayColor];
    UILabel *jiantouLab=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-53, 5, 60, 20)];
    jiantouLab.text=@">";
    jiantouLab.font=[UIFont systemFontOfSize:13];
    jiantouLab.textColor=[UIColor lightGrayColor];
    [jumpV addSubview:jiantouLab];
    [jumpV addSubview:jumpLab];
    
    UIImage *fenGeXianImage = [UIImage imageNamed:@"fengexian"];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 31, frame.size.width, 1)];
    imageView.image=fenGeXianImage;
    
    [backV addSubview:imageView];
    [backV addSubview:label];
    [backV addSubview:addressSettingTable];
    [backV addSubview:jumpV];
    [self addSubview:backV];
     return self;
}


+ (instancetype)defaultPopupView:(NSString*) addrValue tFrame:(CGRect)frame{
    return [[PopChangeAddress alloc]initWithFrame:frame clickFieldValue:addrValue];
}
-(void) jumpAddressSettingAction
{
    UIBarButtonItem* neighborCityItem = [[UIBarButtonItem alloc] initWithTitle:@"地址信息" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.parentVC.navigationItem setBackBarButtonItem:neighborCityItem];
    addressInfomationViewController* jumpAddressInfoVC=[[addressInfomationViewController alloc] init];
    [self.parentVC.navigationController pushViewController:jumpAddressInfoVC animated:YES];
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
    NSLog(@"点击jumpAddressSettingAction");

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
    
    [dataSource removeAllObjects];
     dataSource = [self getAddressList];
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    addressInfoTVC* cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    cell = [[addressInfoTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableIdentifier" dataV:[dataSource objectAtIndex:[indexPath row]]];

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
    NSLog(@"keyaddress is %@", [[dataSource objectAtIndex:indexPath.row] valueForKey:@"keyaddress"]);
    [self setCurrentAddress:[dataSource objectAtIndex:indexPath.row]];
    NSLog(@"设置当前地址");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


/*设置当前地址*/
- (void) setCurrentAddress:(NSDictionary*) nowAddressdic
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
    newFamliyId=[nowAddressdic valueForKey:@"keyFamilyId"];
    neStatus=[nowAddressdic valueForKey:@"keyNeStatus"];
    audiStatus=[nowAddressdic valueForKey:@"keyaudit"];
    if([audiStatus isEqualToString:@"1"])
    {
            neStatus=@"0";
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
            NSString *updateSQL1 = [[NSString alloc] initWithFormat:@"UPDATE table_all_family SET primary_flag = '%d' where family_id = '%lld'", 1,[[nowAddressdic valueForKey:@"keyFamilyId"] longLongValue]];
            NSString *updateSQL2 = [[NSString alloc] initWithFormat:@"UPDATE table_all_family SET primary_flag = '%d' where family_id != '%lld'", 0,[[nowAddressdic valueForKey:@"keyFamilyId"]longLongValue]];
            NSString *selectSQL1=[[NSString alloc] initWithFormat:@"SELECT family_community_id FROM table_all_family where family_id = '%lld'",[[nowAddressdic valueForKey:@"keyFamilyId"] longLongValue]];
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
            [addressSettingTable reloadData];
            [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
        }else{
            
            [database close];
            [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationRight new]];
    }];
    
}
- (NSMutableArray*) getAddressList
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:100];
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory ,  NSUserDomainMask ,  YES );
    NSString* documentPath = [ paths objectAtIndex: 0 ];
    
    NSString* dbPath = [ documentPath stringByAppendingPathComponent: @"youLin-IOS.db" ];
    NSLog(@"%@",dbPath);
    FMDatabase* database = [ FMDatabase databaseWithPath: dbPath ];
    if ( ![ database open ] )
    {
        NSLog(@"打开数据库失败");
        return nil;
    }
    // 查找表
    FMResultSet* resultSet = [ database executeQuery: @"select * from table_all_family" ];
    // 逐行读取数据
    while ( [ resultSet next ] )
    {
        // 对应字段来取数据
        NSString* addressInfo = [ resultSet stringForColumn: @"family_address" ];
        NSInteger auditStatus = [ resultSet intForColumn: @"entity_type" ];
        NSInteger primaryFlag =[ resultSet intForColumn: @"primary_flag" ];
        NSInteger primaryId =[ resultSet intForColumn: @"_id" ];
        NSInteger neStatus =[ resultSet intForColumn: @"ne_status" ];//ne_status
        long familyId=[resultSet longLongIntForColumn:@"family_id"];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setValue:addressInfo forKey:@"keyaddress"];
        [dic setValue:[NSString stringWithFormat:@"%ld",auditStatus] forKey:@"keyaudit"];
        [dic setValue:[NSString stringWithFormat:@"%ld",primaryFlag] forKey:@"keyprimary"];
        [dic setValue:[NSString stringWithFormat:@"%ld",primaryId] forKey:@"key_id"];
        [dic setValue:[NSString stringWithFormat:@"%ld",neStatus] forKey:@"keyNeStatus"];
        [dic setValue:[NSString stringWithFormat:@"%ld",familyId] forKey:@"keyFamilyId"];

        [array addObject:dic];
    }
    
    [ database close ];
    return array;
}

@end
