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
#import "MBProgressHUD.h"
#import "addressVerificationViewController.h"


@interface addressInfomationViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation addressInfomationViewController{

    familyAddressViewController *jumpFamilyAddressController;
    addressVerificationViewController *jumpAddressVerificationController;
    NSMutableArray *_addressAndStatuArray;
    NSMutableArray *_saveAddressArray;
    NSString *flag;
    NSUInteger num;
    UILabel *moveLable;
    float tHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = false;
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
    /*跳转至地址验证页面*/
    jumpAddressVerificationController=[storyBoard instantiateViewControllerWithIdentifier:@"addressVerificationController"];
    /*加载相关地址的TableView*/
    /*读取数据库，获取用户地址信息*/
    _addressAndStatuArray=[self getAddressList];
    _addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _addressTableView.dataSource=self;
    _addressTableView.delegate=self;
    _addressTableView.scrollEnabled=NO;
    _addressTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _addressTableView.bounds.size.width, 0.01)];
    [_addressTableView setSeparatorInset:UIEdgeInsetsZero];
    [_addressTableView setLayoutMargins:UIEdgeInsetsZero];
    // 设置数据源
    NSLog(@"addressArray length is %ld",[_addressAndStatuArray count]);
    if([_addressAndStatuArray count]!=0)
    {
     [self.view addSubview:_addressTableView];
    }else{
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
    //self.addressTableView.hidden = NO;
    
        NSLog(@"*******delete address info!!!!********");
    UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0,0,15,15)];
    rightVeiw.tag=3000;
    UIImageView* xImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_xuanzhong_a"]];
    xImageView.frame = CGRectMake(375,14,15,15);
    [rightVeiw addSubview:xImageView];
    //xImageView.tag=521;
    /** NOTE: This method can return nil so you need to account for that in code */
     static NSString *CellIdentifier = @"addressid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSUInteger rowNumber=[indexPath row];
    UILabel *auditLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, 32)];
    moveLable=[[UILabel alloc] initWithFrame:CGRectMake(120, 5, 100, 32)];
    // NOTE: Add some code like this to create a new cell if there are none to reuse
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    /*设置标记当前地址*/
    if([flag isEqualToString:@"update" ]&&rowNumber==num){
        
        NSLog(@"rowNumber is %ld",num);
        
        /*读取数据库，获取用户地址信息*/
        _addressAndStatuArray=[self getAddressList];
        
        if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaudit"] isEqualToString:@"0"])
        {
            
            NSLog(@"【等待审核】");
            UIView *selectedView = (UIView *)[self.view viewWithTag:3000];
            NSLog(@"%@",selectedView);
            [selectedView removeFromSuperview];
            [self textToast:@"该地址信息未通过审核!\n不能为你显示邻居"];
            
        }else if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaudit"] isEqualToString:@"1"]){
            NSLog(@"【审核成功】");
            UIView *selectedView = (UIView *)[self.view viewWithTag:3000];
            NSLog(@"%@",selectedView);
            [selectedView removeFromSuperview];
            
        }else if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaudit"] isEqualToString:@"2"]){
            
            NSLog(@"审核失败");
            UIView *selectedView = (UIView *)[self.view viewWithTag:3000];
            NSLog(@"%@",selectedView);
            [selectedView removeFromSuperview];
            [self textToast:@"该地址信息未通过审核!\n不能为你显示邻居"];
        }
        flag=@"";
        
    }
        /*地址表初始化*/
        _addressAndStatuArray=[self getAddressList];
        if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaudit"] isEqualToString:@"0"])
        {
            auditLabel.text=@"【等待审核】";
            auditLabel.textColor=[UIColor redColor];
            auditLabel.font=[UIFont systemFontOfSize:15];
            auditLabel.backgroundColor=[UIColor whiteColor];
            
            moveLable.font=[UIFont systemFontOfSize:15];
            moveLable.text=[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"];
            moveLable.tag=rowNumber;
            if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyprimary"] isEqualToString:@"1"]){
                [cell.contentView addSubview:rightVeiw];
            }
            cell.contentView.tag=[[[_addressAndStatuArray objectAtIndex:rowNumber] objectForKey:@"key_id"] intValue];
            NSLog(@" tag is  %ld",cell.contentView.tag);
            [cell.contentView addSubview:moveLable];
            [cell.contentView addSubview:auditLabel];
            [self startAnimationIfNeeded:moveLable];
            
        }else if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaudit"] isEqualToString:@"1"]){
            
            if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyprimary"] isEqualToString:@"1"]){
                
                cell.textLabel.font=[UIFont fontWithName:@"Verdana" size:15];
                cell.textLabel.text=[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"];

                cell.contentView.tag=[[[_addressAndStatuArray objectAtIndex:rowNumber] objectForKey:@"key_id"] intValue];
                [cell.contentView addSubview:rightVeiw];
                
            }else{
                
                cell.textLabel.font=[UIFont fontWithName:@"Verdana" size:15];
                cell.textLabel.text=[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"];
                cell.contentView.tag=[[[_addressAndStatuArray objectAtIndex:rowNumber] objectForKey:@"key_id"] intValue];
         
            }
        }else if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaudit"] isEqualToString:@"2"]){
            
            auditLabel.text=@"【审核失败】";
            auditLabel.textColor=[UIColor redColor];
            auditLabel.font=[UIFont systemFontOfSize:15];
            auditLabel.backgroundColor=[UIColor whiteColor];
            
            moveLable.font=[UIFont systemFontOfSize:15];
            moveLable.text=[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyaddress"];
            moveLable.tag=rowNumber;
            NSLog(@"moveLable.tag equal  %ld",moveLable.tag);
            if([[[_addressAndStatuArray objectAtIndex:rowNumber]objectForKey:@"keyprimary"] isEqualToString:@"1"]){
                [cell.contentView addSubview:rightVeiw];
            }
            cell.contentView.tag=[[[_addressAndStatuArray objectAtIndex:rowNumber] objectForKey:@"key_id"] intValue];
            [cell.contentView addSubview:moveLable];
            [cell.contentView addSubview:auditLabel];
            [self startAnimationIfNeeded:moveLable];
            /*设置线程           
             NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(refreshTable:) object:@(rowNumber)];
            thread.name=[NSString stringWithFormat:@"myThread%ld",rowNumber];
             [thread start];*/

        }
   
    /*删除地址后更新地址表*/
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowInSection = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyaudit"] isEqualToString:@"0"])
    {
        if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyprimary"] isEqualToString:@"1"]){
        tHeight=200;
        PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView:4 tFrame:CGRectMake(0, 0, 320, tHeight)];
        view.parentVC = self;
        view.celltag=cell.contentView.tag;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
            if([view.addressFlag isEqualToString:@"justnow"])
            {
                flag=@"update";
                num=indexPath.row;
                [self.addressTableView reloadData];
                [self.addressTableView layoutIfNeeded];
            }else if ([view.addressFlag isEqualToString:@"jumpAddressInfo"]){
                
                NSLog(@"进入跳转页面");
                jumpFamilyAddressController.changeAddressArry=view.changeAddressArray;
                [jumpFamilyAddressController.myfamilyAddressTableView reloadData];
                UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"填写家庭住址" style:UIBarButtonItemStylePlain target:nil action:nil];
                [self.navigationItem setBackBarButtonItem:neighborItem];
                [self.navigationController pushViewController:jumpFamilyAddressController animated:YES];
                
            }else if([view.addressFlag isEqualToString:@"valiyaddress"]){
              
                UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"住址验证" style:UIBarButtonItemStylePlain target:nil action:nil];
                [self.navigationItem setBackBarButtonItem:neighborItem];
                [self.navigationController pushViewController:jumpAddressVerificationController animated:YES];
              
            }else if([view.addressFlag isEqualToString:@"deleteAddressInfo"]){
                
                [_addressAndStatuArray removeObjectAtIndex:indexPath.row];
                [self.addressTableView reloadData];
            }
            NSLog(@"动画结束");
        }];}else{
            //等待审核
            tHeight=250;
            PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView:0 tFrame:CGRectMake(0, 0, 320, tHeight)];
            view.parentVC = self;
            view.celltag=cell.contentView.tag;
            
            [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
                NSLog(@"%@",view.addressFlag);
                if([view.addressFlag isEqualToString:@"justnow"])
                {
                    flag=@"update";
                    num=indexPath.row;
                    //self.addressTableView.hidden = YES;
                    [self.addressTableView reloadData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"刷新完成");
                    });
                }else if ([view.addressFlag isEqualToString:@"jumpAddressInfo"]){
                    
                    NSLog(@"进入跳转页面");
                    jumpFamilyAddressController.changeAddressArry=view.changeAddressArray;
                    [jumpFamilyAddressController.myfamilyAddressTableView reloadData];
                    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"填写家庭住址" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:neighborItem];
                    [self.navigationController pushViewController:jumpFamilyAddressController animated:YES];
                }else if([view.addressFlag isEqualToString:@"deleteAddressInfo"]){
                    
                    [_addressAndStatuArray removeObjectAtIndex:indexPath.row];
                    [self.addressTableView reloadData];
                }

                NSLog(@"success动画结束");
             
            }];
            
        }

    }else if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyaudit"] isEqualToString:@"1"]){
        
        if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyprimary"] isEqualToString:@"1"]){
            tHeight=150;
            PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView:3 tFrame:CGRectMake(0, 0, 320, tHeight)];
            view.parentVC = self;
            view.celltag=cell.contentView.tag;
            [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
                if([view.addressFlag isEqualToString:@"justnow"])
                {
                    flag=@"update";
                    num=indexPath.row;
                    [self.addressTableView reloadData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"刷新完成");
                    });                }
                NSLog(@"动画结束");
            }];
        
        }else{
            tHeight=200;
            PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView:1 tFrame:CGRectMake(0, 0, 320, tHeight)];
            view.parentVC = self;
            view.celltag=cell.contentView.tag;
           
            [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
                NSLog(@"%@",view.addressFlag);
                if([view.addressFlag isEqualToString:@"justnow"])
                {
                     flag=@"update";
                     num=indexPath.row;
                     [self.addressTableView reloadData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"刷新完成");
                    });
                }else if([view.addressFlag isEqualToString:@"deleteAddressInfo"]){
                    
                    [_addressAndStatuArray removeObjectAtIndex:indexPath.row];
                    [self.addressTableView reloadData];
                }
                     NSLog(@"success动画结束");
                        
            }];

        }
        
    }else if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyaudit"] isEqualToString:@"2"]){//审核失败
        if([[[_addressAndStatuArray objectAtIndex:rowInSection]objectForKey:@"keyprimary"] isEqualToString:@"1"]){
            tHeight=200;
            PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView:5 tFrame:CGRectMake(0, 0, 320, tHeight)];
            view.parentVC = self;
            view.celltag=cell.contentView.tag;
            [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
                if([view.addressFlag isEqualToString:@"justnow"])
                {
                    flag=@"update";
                    num=indexPath.row;
                    [self.addressTableView reloadData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"刷新完成");
                    });
                }else if ([view.addressFlag isEqualToString:@"jumpAddressInfo"]){
                
                    NSLog(@"进入跳转页面");
                    jumpFamilyAddressController.changeAddressArry=view.changeAddressArray;
                    [jumpFamilyAddressController.myfamilyAddressTableView reloadData];
                    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"填写家庭住址" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:neighborItem];
                    [self.navigationController pushViewController:jumpFamilyAddressController animated:YES];

                }else if([view.addressFlag isEqualToString:@"valiyaddress"]){
                    
                    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"住址验证" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:neighborItem];
                    [self.navigationController pushViewController:jumpAddressVerificationController animated:YES];
                    
                }else if([view.addressFlag isEqualToString:@"deleteAddressInfo"]){
                    
                    [_addressAndStatuArray removeObjectAtIndex:indexPath.row];
                    [self.addressTableView reloadData];
                }

                NSLog(@"动画结束");
            }];

                }else{
                    tHeight=250;
                    PopupAddressSettingView *view = [PopupAddressSettingView defaultPopupView:2 tFrame:CGRectMake(0, 0, 320, tHeight)];
                    view.parentVC = self;
                    view.celltag=cell.contentView.tag;
                    [self lew_presentPopupView:view animation:[LewPopupViewAnimationRight new] dismissed:^{
                        if([view.addressFlag isEqualToString:@"justnow"])
                        {
                            flag=@"update";
                            num=indexPath.row;
                            [self.addressTableView reloadData];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"刷新完成");
                            });}else if ([view.addressFlag isEqualToString:@"jumpAddressInfo"]){
                                
                                NSLog(@"进入跳转页面");
                                jumpFamilyAddressController.changeAddressArry=view.changeAddressArray;
                                [jumpFamilyAddressController.myfamilyAddressTableView reloadData];
                                UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"填写家庭住址" style:UIBarButtonItemStylePlain target:nil action:nil];
                                [self.navigationItem setBackBarButtonItem:neighborItem];
                                [self.navigationController pushViewController:jumpFamilyAddressController animated:YES];
                                
                            }else if([view.addressFlag isEqualToString:@"deleteAddressInfo"]){
                            
                                [_addressAndStatuArray removeObjectAtIndex:indexPath.row];
                                [self.addressTableView reloadData];
                            }
                            NSLog(@"动画结束");
                    }];}
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(refreshTable) object:@(rowNumber)];
thread.name=[NSString stringWithFormat:@"myThread%ld",rowNumber];
[thread start];*/
- (void) refreshTable{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_addressTableView reloadData];
    });
    NSLog(@"执行我了么");
}
- (void)textToast:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view    animated:YES];
    
    // Set the annular determinate mode to show task progress.navigationController.view
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor=[UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.minSize=CGSizeMake(50, 50);
    hud.label.text = NSLocalizedString(tips, @"HUD message title");
    hud.label.numberOfLines=0;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font= [UIFont systemFontOfSize:15];
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 0.f);
    
    [hud hideAnimated:YES afterDelay:1.f];
}

-(void)startAnimationIfNeeded:(UILabel*)moveLabel{
    //取消、停止所有的动画
    //NSLog(@"move label is %d",[sender intValue]);
    //UILabel *moveLabel=[(UILabel *)self.view viewWithTag:[sender intValue]];
    
   //[moveLabel.layer removeAllAnimations];
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
