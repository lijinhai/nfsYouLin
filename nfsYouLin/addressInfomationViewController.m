//
//  addressInfomationViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "addressInfomationViewController.h"
#import "familyAddressViewController.h"
#import "FMDB.h"
#import "LewPopupViewController.h"
#import "PopupAddressSettingView.h"
@interface addressInfomationViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation addressInfomationViewController{

    familyAddressViewController *jumpFamilyAddressController;
    NSMutableArray *_addressAndStatuArray;
    NSMutableArray *_saveAddressArray;
    float tHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"添加地址" style:UIBarButtonItemStylePlain target:self action:@selector(addNewAddress)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    self.navigationItem.title=@"";
    /*跳转至家庭地址信息*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    jumpFamilyAddressController=[storyBoard instantiateViewControllerWithIdentifier:@"familyAddressController"];
    /*加载相关地址的TableView*/
    /*读取数据库，获取用户地址信息*/
    _addressAndStatuArray=[self getAddressList];
    _addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _addressTableView.dataSource=self;
    _addressTableView.delegate=self;
    //_addressTableView.scrollEnabled = NO;
    [_addressTableView setSeparatorInset:UIEdgeInsetsZero];
    [_addressTableView setLayoutMargins:UIEdgeInsetsZero];
    // 设置数据源
    NSLog(@"addressArray length is %ld",[_addressAndStatuArray count]);
    if([_addressAndStatuArray count]!=0)
    {
     
     //[_addressTableView reloadData];
     [self.view addSubview:_addressTableView];
    }else{
        //[self.view addSubview:_addressTableView];
        [_addressTableView removeFromSuperview];
    
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addNewAddress{

    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"填写家庭住址" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:jumpFamilyAddressController animated:YES];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [_addressAndStatuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*读取数据库，获取用户地址信息*/
    _addressAndStatuArray=[self getAddressList];
    static NSString *CellIdentifier = @"addressid";
    UIImageView* xImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_xuanzhong_a"]];
    /** NOTE: This method can return nil so you need to account for that in code */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSUInteger rowNumber=[indexPath row];
    UILabel *auditLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, 32)];
    UILabel *moveLable=[[UILabel alloc] initWithFrame:CGRectMake(120, 5, 100, 32)];
    // NOTE: Add some code like this to create a new cell if there are none to reuse
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaudit"] isEqualToString:@"0"])
        {
            auditLabel.text=@"【等待审核】";
            auditLabel.textColor=[UIColor redColor];
            auditLabel.font=[UIFont systemFontOfSize:15];
            auditLabel.backgroundColor=[UIColor whiteColor];
            
            moveLable.font=[UIFont systemFontOfSize:15];
            moveLable.text=[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"];
            cell.contentView.tag=[[[_addressAndStatuArray objectAtIndex:rowNumber] objectForKey:@"key_id"] intValue];
            NSLog(@" tag is  %ld",cell.contentView.tag);
            [cell.contentView addSubview:moveLable];
            [cell.contentView addSubview:auditLabel];
            [self startAnimationIfNeeded:moveLable];
            
            NSLog(@"saaaa %@",[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"]);
            
        }else if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaudit"] isEqualToString:@"1"]){
            
            if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyprimary"] isEqualToString:@"1"]){
                cell.textLabel.font=[UIFont fontWithName:@"Verdana" size:15];
                cell.textLabel.text=[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"];
                xImageView.frame = CGRectMake(375,14,16,16);
                cell.contentView.tag=[[[_addressAndStatuArray objectAtIndex:rowNumber] objectForKey:@"key_id"] intValue];
                [cell.contentView addSubview:xImageView];
                
            }else{
                cell.textLabel.font=[UIFont fontWithName:@"Verdana" size:15];
                cell.textLabel.text=[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"];
                cell.contentView.tag=[[[_addressAndStatuArray objectAtIndex:rowNumber] objectForKey:@"key_id"] intValue];
         
            }
        }else if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaudit"] isEqualToString:@"2"]){
            
            NSLog(@"sccc %@",[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"]);
            auditLabel.text=@"【审核失败】";
            auditLabel.textColor=[UIColor redColor];
            auditLabel.font=[UIFont systemFontOfSize:15];
            auditLabel.backgroundColor=[UIColor whiteColor];
            
            moveLable.font=[UIFont systemFontOfSize:15];
            moveLable.text=[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"];
            cell.contentView.tag=[[[_addressAndStatuArray objectAtIndex:rowNumber] objectForKey:@"key_id"] intValue];
            [cell.contentView addSubview:moveLable];
            [cell.contentView addSubview:auditLabel];
            [self startAnimationIfNeeded:moveLable];

        }

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowInSection = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyaudit"] isEqualToString:@"0"])
    {
        tHeight=250;
        PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView: 0 tFrame:CGRectMake(0, 0, 320, tHeight)];
        view.parentVC = self;
        view.celltag=cell.contentView.tag;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
            NSLog(@"动画结束");
        }];

    }else if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyaudit"] isEqualToString:@"1"]){
        
        if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyprimary"] isEqualToString:@"1"]){
            tHeight=150;
            PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView:3 tFrame:CGRectMake(0, 0, 320, tHeight)];
            view.parentVC = self;
            view.celltag=cell.contentView.tag;
            [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
                NSLog(@"动画结束");
            }];
        
        }else{
            tHeight=200;
            PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView:1 tFrame:CGRectMake(0, 0, 320, tHeight)];
            view.parentVC = self;
            view.celltag=cell.contentView.tag;
            [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
                NSLog(@"动画结束");
            }];

        }
        
    }else if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyaudit"] isEqualToString:@"2"]){
        tHeight=250;
        PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView:2 tFrame:CGRectMake(0, 0, 320, tHeight)];
        view.parentVC = self;
        view.celltag=cell.contentView.tag;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
            NSLog(@"动画结束");
        }];

    }
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)startAnimationIfNeeded:(UILabel *)moveLabel{
    //取消、停止所有的动画
    [moveLabel.layer removeAllAnimations];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys: moveLabel.font,NSFontAttributeName,nil];
    CGSize textSize = [moveLabel.text sizeWithAttributes:dict];
    CGRect lframe = moveLabel.frame;
    lframe.size.width = textSize.width;
    moveLabel.frame = lframe;
    const float oriWidth = 80;
    if (textSize.width > oriWidth) {
        float offset = textSize.width - oriWidth;
        [UIView animateWithDuration:5.0
                              delay:0
                            options:UIViewAnimationOptionRepeat //动画重复的主开关
         |UIViewAnimationOptionTransitionFlipFromRight //动画重复自动反向，需要和上面这个一起用
         |UIViewAnimationOptionCurveLinear //动画的时间曲线，滚动字幕线性比较合理
                         animations:^{
                             moveLabel.transform = CGAffineTransformMakeTranslation(-offset, 0);
                         }
                         completion:^(BOOL finished) {
                             
                         }
         ];
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 220)];
    [sectionView setBackgroundColor:[UIColor lightGrayColor]];

    return sectionView;
}
- (IBAction)writeAddressAction:(id)sender {
    
    [self.navigationController pushViewController:jumpFamilyAddressController animated:YES];
}
- (NSMutableArray*) getAddressList
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:100];
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory ,  NSUserDomainMask ,  YES );
    NSString* documentPath = [ paths objectAtIndex: 0 ];
    
    NSString* dbPath = [ documentPath stringByAppendingPathComponent: @"neighbors.db" ];
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
        NSInteger primaryFlag=[ resultSet intForColumn: @"primary_flag" ];
        NSInteger primaryId=[ resultSet intForColumn: @"_id" ];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setValue:addressInfo forKey:@"keyaddress"];
        [dic setValue:[NSString stringWithFormat:@"%ld",auditStatus] forKey:@"keyaudit"];
        [dic setValue:[NSString stringWithFormat:@"%ld",primaryFlag] forKey:@"keyprimary"];
        [dic setValue:[NSString stringWithFormat:@"%ld",primaryId] forKey:@"key_id"];
        //NSLog( @"key_id: %ld" , primaryId);
        [array addObject:dic];
    }
    
    [ database close ];
    return array;
}
@end
