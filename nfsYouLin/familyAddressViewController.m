//
//  familyAddressViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "familyAddressViewController.h"
#import "chooseCityViewController.h"
#import "myCommunityViewController.h"
#import "LewPopupViewController.h"
#import "PopupFloorView.h"
#import "addressInfomationViewController.h"
#import "MBProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface familyAddressViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@end

@implementation familyAddressViewController{

    chooseCityViewController *jumpChooseCityController;
    myCommunityViewController *jumpCommunityController;
    addressInfomationViewController *jumpAddressInfomationController;
    UILabel *floorLabelView;
    UIView *cityRowView;
    UILabel *communityLabelView;
    UITextField *doorPlateNumView;
    UIView *tipsView;
    UILabel *label;
    NSString *flag1;
    NSString *successFlag;
    UIView *rightVeiw;
    UIView *rightVeiw2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *list = [NSArray arrayWithObjects:@"选城市",@"填小区",@"楼栋号",@"门牌号",@"",nil];
    self.listtitle = list;
    UILabel *footLabelView=[[UILabel alloc] initWithFrame:CGRectMake(3, 3, 450.0,44.0)];
    footLabelView.font=[UIFont systemFontOfSize:13.0];
    footLabelView.textColor=[UIColor lightGrayColor];
    footLabelView.numberOfLines=0;
    footLabelView.text=@"  请用户填写您真实的地址，否则在申请地址认证的过程中给您和其他\n  用户带来不必要的麻烦。";
    _myfamilyAddressTableView.sectionFooterHeight = 800.0f;
    UIView *footView = [UIView new];
    [footView addSubview:footLabelView];
    _myfamilyAddressTableView.tableFooterView=footView;
    footView.frame = CGRectMake(0, 0, 0, 0);
    [self.myfamilyAddressTableView setTableFooterView:footView];
    _myfamilyAddressTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_myfamilyAddressTableView setSeparatorInset:UIEdgeInsetsMake(0,15, 0, 15)];
    [_myfamilyAddressTableView setLayoutMargins:UIEdgeInsetsMake(0,15, 0, 15)];
    if(_communityNameValue!=nil)
    {
     [self getFieldFocus];
    }

}

-(void)viewWillAppear:(BOOL)animated{

    /*设置导航*/
    self.navigationController.navigationBarHidden = NO;
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(selectCompleteAction)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    self.navigationItem.title=@"";
    /*跳转至相关界面*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    jumpChooseCityController = [storyBoard instantiateViewControllerWithIdentifier:@"cityController"];
    jumpCommunityController = [storyBoard instantiateViewControllerWithIdentifier:@"myCommunityController"];
    jumpAddressInfomationController=[storyBoard instantiateViewControllerWithIdentifier:@"addressInfomationController"];


}
- (void)textToast:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view    animated:YES];
    
    // Set the annular determinate mode to show task progress.navigationController.view
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor=[UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.minSize=CGSizeMake(50, 50);
    hud.label.text = NSLocalizedString(tips, @"HUD message title");
    
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font= [UIFont systemFontOfSize:15];
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:3.f];
}

-(void)selectCompleteAction{

    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"地址信息" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    UITextField *doorPlateText = (UITextField *)[self.view viewWithTag:1002];
    UITextField *floorText = (UITextField *)[self.view viewWithTag:1001];
    if([communityLabelView.text isEqualToString:@""]||[communityLabelView.text isEqualToString:@"未设置"])
    {
    
        [self textToast:@"请设置所在小区"];
        return;
    }
    if([floorText.text isEqualToString:@""])//_floorNumView.text
    {
        
        flag1=@"tag1001";
        successFlag=@"floorView";
        [self.myfamilyAddressTableView reloadData];
        [self textToast:@"请设置所在单元"];
        return;
    }
    if([doorPlateText.text isEqualToString:@""])//doorPlateNumView.text
    {
        
        flag1=@"tag1002";
        successFlag=@"doorView";
        [self.myfamilyAddressTableView reloadData];
        [self textToast:@"请设置门牌号"];
        return;
    }
    [self.navigationController pushViewController:jumpAddressInfomationController animated:YES];

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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    static NSString *TableSampleIdentifier = @"family";
    NSUInteger rowNumber=[indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    /*设置textField tips 图片*/
    rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    rightVeiw2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView* xImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tanhao"]];
    UIImageView* x2ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tanhao"]];
    rightVeiw.tag=119;
    rightVeiw2.tag=120;
    xImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *xImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xImageViewClick)];
    [xImageView addGestureRecognizer:xImageViewTap];
    
    x2ImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *x2ImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xImageViewClick)];
    [x2ImageView addGestureRecognizer:x2ImageViewTap];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
        /*选择城市*/
        UIImage *firstButtonImage = [UIImage imageNamed:@"dingwei"];
        UIButton *imageBtn=[[UIButton alloc] initWithFrame:CGRectMake(65, 0, 32, 32)];
        [imageBtn setImage:firstButtonImage forState:UIControlStateNormal];
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 144, 32)];
        textlabel.text=@"哈尔滨市";
        textlabel.font=[UIFont systemFontOfSize:15.0];
        textlabel.textColor=UIColorFromRGB(0xFFBA02);
        cityRowView = [[UIView alloc] initWithFrame:CGRectMake(80.0f, 14.0f, 150.0f, 44.0f)];
        [cityRowView addSubview:imageBtn];
        [cityRowView addSubview:textlabel];
        /*填小区*/
        communityLabelView=[[UILabel alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 150.0f,44.0f)];
        communityLabelView.font=[UIFont systemFontOfSize:15.0];
        if(_communityNameValue==nil)
        {
            
            [communityLabelView setText:@"未设置"];
        }else{
            
            [communityLabelView setText:_communityNameValue];
        }
        /*填楼栋号*/
        _floorNumView=[[UITextField alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 250.0f,44.0f)];
        floorLabelView=[[UILabel alloc] initWithFrame:CGRectMake(3, 3, 250.0,44.0)];
        floorLabelView.font=[UIFont systemFontOfSize:13.0];
        floorLabelView.textColor=[UIColor lightGrayColor];
        floorLabelView.numberOfLines=0;
        floorLabelView.text=@"(1—A表示1栋A单元\n3335-43表示3335弄43号)";
        floorLabelView.tag=30001;
        
        _floorNumView.clearButtonMode = UITextFieldViewModeAlways;
        _floorNumView.borderStyle = UITextBorderStyleNone;
        _floorNumView.delegate = self;
        _floorNumView.tag=1001;
        [_floorNumView addTarget:self action:@selector(getFieldFocus) forControlEvents:UIControlEventEditingDidBegin];

        /*填门牌号*/
        doorPlateNumView=[[UITextField alloc] initWithFrame:CGRectMake(80.0f, 9.0f, 250.0f,44.0f)];
        doorPlateNumView.placeholder=@"如1802";
        doorPlateNumView.font=[UIFont systemFontOfSize:15];
        doorPlateNumView.clearButtonMode = UITextFieldViewModeAlways;
        doorPlateNumView.borderStyle = UITextBorderStyleNone;
        doorPlateNumView.clearsOnBeginEditing = YES;
        doorPlateNumView.tag=1002;
        doorPlateNumView.delegate=self;
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 450, 0.5)];
        label.backgroundColor = [UIColor lightGrayColor];
        
        /*温馨提示*/
        UIImage *leftheartImage = [UIImage imageNamed:@"gray_heart"];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 16)];
        imageView.image=leftheartImage;
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 144, 16)];
        tipsLabel.text=@"温馨提示";
        tipsLabel.font=[UIFont systemFontOfSize:13.0];
        tipsLabel.textColor=[UIColor grayColor];
        tipsView = [[UIView alloc] initWithFrame:CGRectMake(150.0f, 55.0f, 150.0f, 44.0f)];
        [tipsView addSubview:imageView];
        [tipsView addSubview:tipsLabel];
        NSUInteger rowNumber=[indexPath row];
        switch (rowNumber) {
            case 0:
                NSLog(@"rowNumber 1");
                [cell.contentView addSubview:cityRowView];
                break;
            case 1:
                NSLog(@"rowNumber 2");
                [cell.contentView addSubview:communityLabelView];
                break;
            case 2:
                NSLog(@"啊飒飒的  %@",self.floorNumValue);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [_floorNumView addSubview:floorLabelView];
                [cell.contentView addSubview:_floorNumView];
                break;
            case 3:
                NSLog(@"rowNumber 4");
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:doorPlateNumView];
                
                break;
            case 4:
                NSLog(@"rowNumber 5");
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:label];
                [cell.contentView addSubview:tipsView];
                break;
            default:
                break;
        }
        cell.textLabel.font=[UIFont fontWithName:@"Verdana" size:16];
        cell.textLabel.textColor=[UIColor lightGrayColor];
        cell.textLabel.text=[_listtitle objectAtIndex:rowNumber];
    }else{
        
        [cell removeFromSuperview];
    }
    
        self.floorNumValue = [defaults valueForKey:@"floorKey"];
        if(self.floorNumValue!=NULL&&rowNumber==2&&[flag1 isEqualToString:@"tag1001"])
        {
                NSLog(@"floorlabel is %@",floorLabelView.text);
                UILabel *floorLabel = (UILabel *)[cell viewWithTag:30001];
                [floorLabel removeFromSuperview];
                UITextField *floorTextField = (UITextField *)[cell viewWithTag:1001];
                [floorTextField removeFromSuperview];
                NSLog(@"floorNumValue是：  %@",self.floorNumValue);
                _floorNumView.text=self.floorNumValue;
                _floorNumView.textColor=[UIColor blackColor];
                _floorNumView.font=[UIFont systemFontOfSize:15];
                UIView *imageTanHao = (UIView *)[cell viewWithTag:119];
                [imageTanHao removeFromSuperview];
                [cell.contentView addSubview:_floorNumView];
                [defaults removeObjectForKey:@"floorKey"];
                flag1=nil;
            
        }else if(self.floorNumValue==NULL&&rowNumber==2&&[_floorNumView.text length] == 0&&[flag1 isEqualToString:@"tag1001"]){
                UILabel *floorLabel = (UILabel *)[cell viewWithTag:30001];
                UITextField *floorText = (UITextField *)[cell viewWithTag:1001];
            
                if(floorLabel==NULL&&[floorText.text isEqualToString:@""])
                {
                  NSLog(@" what is %@",floorText.text);
                 [_floorNumView addSubview:floorLabelView];
                 [cell.contentView addSubview:_floorNumView];
                }
                if([successFlag isEqualToString:@"floorView"])
                {
                    NSLog(@"floorView");
                    UIView *viewTanHao = (UIView *)[cell viewWithTag:119];
                    if(viewTanHao==NULL)
                    {
                    xImageView.frame = CGRectMake(307,22,15,15);
                    [rightVeiw addSubview:xImageView];
                    [cell.contentView addSubview:rightVeiw];
                    }
                    successFlag=@"";
                }
        }
    
    /*相关限制条件待补充*/
 
    self.floorNumValue = [defaults valueForKey:@"floorKey"];
    
    UITextField *doorPlateText = (UITextField *)[cell viewWithTag:1002];
    if(self.floorNumValue!=NULL&&rowNumber==3&&[flag1 isEqualToString:@"tag1002"])
    {
        NSLog(@"new begin1");
        UITextField *doorPlateText = (UITextField *)[cell viewWithTag:1002];
        [doorPlateText removeFromSuperview];
        doorPlateNumView.text=self.floorNumValue;
        doorPlateNumView.textColor=[UIColor blackColor];
        doorPlateNumView.font=[UIFont systemFontOfSize:15];
        UIView *imageTanHao = (UIView *)[cell viewWithTag:120];
        [imageTanHao removeFromSuperview];
        [cell.contentView addSubview:doorPlateNumView];
        [defaults removeObjectForKey:@"floorKey"];
        
    }else if(self.floorNumValue==NULL&&rowNumber==3&&[doorPlateText.text length] == 0){
        NSLog(@"new begin2");
        if([successFlag isEqualToString:@"doorView"])
        {
            NSLog(@"doorView");
            UIView *viewTanHao = (UIView *)[cell viewWithTag:120];
            if(viewTanHao==NULL)
            {
            x2ImageView.frame = CGRectMake(307,24,15,15);
            [rightVeiw2 addSubview:x2ImageView];
            [cell.contentView addSubview:rightVeiw2];
            }
            successFlag=@"";
        }
    }
    
   /*修改家庭住址时初始化*/
    if([_changeAddressArry count]!=0)
    {
        /*设置小区*/
        [communityLabelView setText:[[_changeAddressArry objectAtIndex:0]objectForKey:@"keycommunity"]];
        /*初始化楼栋号*/
        if((UILabel *)[cell viewWithTag:30001])
        {
          [(UILabel *)[cell viewWithTag:30001] removeFromSuperview];
          _floorNumView.font=[UIFont systemFontOfSize:15];
          _floorNumView.text=[[_changeAddressArry objectAtIndex:0]objectForKey:@"keyportrait"];
        }
        /*初始化门牌号*/
        [doorPlateNumView setText:@""];
         doorPlateNumView.text=[[_changeAddressArry objectAtIndex:0]objectForKey:@"keyaptnum"];

    }
    return cell;
}
- (void)xImageViewClick{

    NSLog(@"click image");
}
#pragma mark 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowInSection = indexPath.row;
    NSLog(@"row %ld",rowInSection);

    UIBarButtonItem* neighborCommunityItem = [[UIBarButtonItem alloc] initWithTitle:@"我的小区" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem* neighborCityItem = [[UIBarButtonItem alloc] initWithTitle:@"请选择城市" style:UIBarButtonItemStylePlain target:nil action:nil];

    switch (rowInSection) {
        case 0:
            NSLog(@"点击1");
            [self.navigationItem setBackBarButtonItem:neighborCityItem];
            [self.navigationController pushViewController:jumpChooseCityController animated:YES];
            break;
        case 1:
            NSLog(@"点击2");
            [self.navigationItem setBackBarButtonItem:neighborCommunityItem];
            [self.navigationController pushViewController:jumpCommunityController animated:YES];
            break;
        case 2:
            NSLog(@"点击3");
            break;
        case 3:
            NSLog(@"点击4");
            break;
        case 4:
            NSLog(@"点击5");
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
        [cell setSeparatorInset:UIEdgeInsetsMake(0,15, 0, 15)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,15, 0, 15)];
    }
}

/*设置单元格宽度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowInSection = indexPath.row;
    if(rowInSection==4)
    {
      return 90.0f;
    }else{
    
      return 60.0f;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_changeAddressArry removeAllObjects];
    if (textField.tag == 1001&&[communityLabelView.text compare:@"未设置" ]) {
        UIView *imageTanHao = (UIView *)[self.myfamilyAddressTableView viewWithTag:119];
        if(imageTanHao!=NULL)
        {
            [imageTanHao removeFromSuperview];
        }
        NSLog(@"textFieldShouldBeginEditing1");
        PopupView *view = [PopupView defaultPopupView:1001];
        view.parentVC = self;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
            [textField resignFirstResponder];
            NSLog(@"刷新数据");
            flag1=@"tag1001";
            [self.myfamilyAddressTableView reloadData];
            NSLog(@"动画结束");
        }];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        return NO;
    }
    if (textField.tag == 1002&&[communityLabelView.text compare:@"未设置" ]) {
        UIView *imageTanHao2 = (UIView *)[self.myfamilyAddressTableView viewWithTag:120];
        if(imageTanHao2!=NULL)
        {
            
            [imageTanHao2 removeFromSuperview];
        }
        PopupView *view = [PopupView defaultPopupView:1002];
        view.parentVC = self;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
            [textField resignFirstResponder];
            NSLog(@"刷新数据");
            flag1=@"tag1002";
            [self.myfamilyAddressTableView reloadData];
            NSLog(@"动画结束");
        }];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        return NO;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return NO;
}

-(void)getFieldFocus{
    
    NSLog(@"getFieldFocus");
    [self.view endEditing:YES];
    PopupView *view = [PopupView defaultPopupView:1001];
    view.parentVC = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        flag1=@"tag1001";
        [self.myfamilyAddressTableView reloadData];
        NSLog(@"动画结束");
    }];

}

@end
