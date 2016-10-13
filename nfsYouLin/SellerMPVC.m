//
//  SellerMPVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DownListView.h"
#import "BusinessCircleCVC.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "SqliteOperation.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"


@interface SellerMPVC (){
    UISegmentedControl *segment;
    UIScrollView *_scrollView;
    UILabel *line1;
    UILabel *line2;
    
}
@end

@implementation SellerMPVC{
    
    BusinessCircleCVC *busCirCVContoller;
    //ExchangedGiftsViewController *exchangedGiftView;
    
    UIColor *_viewColor;
    DownListView *listView;
    UIImageView *backIV;
    UILabel *backLabel;
    NSMutableArray *typeName;
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor whiteColor];
     
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    [self setSegmentedControl];
    [self build];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    UIBarButtonItem *barrightBtn = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemSearch target: self action: @selector(searchBussessCircle:)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    self.navigationController.navigationBar.backgroundColor = MainColor;
}

-(void)searchBussessCircle:(id)sender{

    CGSize size = [StringMD5 sizeWithString:@"搜索" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _backView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0,self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    _backView.backgroundColor = MainColor;
    _backView.tag = 101;
    backIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, _backView.frame.size.height / 4, 20, _backView.frame.size.height / 2)];
    backIV.image = [UIImage imageNamed:@"mm_title_back.png"];
    backLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backIV.frame) + 5, 0, size.width, _backView.frame.size.height)];
    
    backLabel.text = @"搜索";
    backLabel.textColor = [UIColor whiteColor];
    UIView *paddingView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(95, 8, self.navigationController.navigationBar.frame.size.width-110,29)];
    _searchTF.layer.cornerRadius = 9;
    _searchTF.backgroundColor = [UIColor whiteColor];
    _searchTF.placeholder = @"请输入您想要搜索的关键字";
    _searchTF.font = [UIFont systemFontOfSize:13.f];
    _searchTF.leftView = paddingView0;
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.returnKeyType = UIReturnKeyNext;
    _searchTF.tag = 102;
    UIImageView *rightView = [[UIImageView alloc]init];
    rightView.image = [UIImage imageNamed:@"sousuohuang"];
    rightView.frame = CGRectMake(0, 0, 20, 20);
    rightView.userInteractionEnabled = YES;
   [rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    
    _searchTF.contentMode = UIViewContentModeCenter;
    _searchTF.rightView = rightView;
    _searchTF.rightViewMode = UITextFieldViewModeAlways;
    
    
    [_backView addSubview:backIV];
    [_backView addSubview:backLabel];
    
    [_backView addTarget:self action:@selector(changeAlpha) forControlEvents:UIControlEventTouchDown];
    [_backView addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_backView];
    [self.navigationController.navigationBar addSubview:_searchTF];

}
-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"click");
    if([_searchTF.text isEqualToString:@""])
    {
        [MBProgressHUBTool textToast:self.view Tip:@"请输入正确的✅搜索关键字"];
         return;
    }
    [self searchTypeAndOrder];
    [busCirCVContoller  viewDidLoad];
}



-(void)changeAlpha{

    backLabel.alpha = 0.2;
    backIV.alpha = 0.2;
}

-(void)backAction{

    backLabel.alpha = 1.0;
    backIV.alpha = 1.0;
    [_backView removeFromSuperview];
    [_searchTF removeFromSuperview];

}
-(void)searchTypeAndOrder
{
    // bctag 值
    if([_typeRL.text isEqualToString:@"全部"]){
        
        busCirCVContoller.bctag = @"0";
        
    }else if([_typeRL.text isEqualToString:@"宾馆"]){
        
        busCirCVContoller.bctag = @"1";
        
    }else if([_typeRL.text isEqualToString:@"餐饮"]){
        
        busCirCVContoller.bctag = @"2";
        
    }else{
        
        busCirCVContoller.bctag = @"3";
        
    }
    
    // sort 值
    if([_orderRL.text isEqualToString:@"智能排序"])
    {
        
        busCirCVContoller.sort = @"0";
        
    }else if([_orderRL.text isEqualToString:@"离我最近"]){
        
        busCirCVContoller.sort = @"1";
        
    }else if([_orderRL.text isEqualToString:@"好评优先"]){
        
        busCirCVContoller.sort = @"2";
        
    }else{
        
        busCirCVContoller.sort = @"3";
        
    }

}
-(void)refreshChildViewController{
    

    [self searchTypeAndOrder];
    [busCirCVContoller  viewDidLoad];

}

-(void)build
{

    busCirCVContoller = [[BusinessCircleCVC alloc] init];
    busCirCVContoller.sort = @"0";
    busCirCVContoller.bctag = @"0";
    busCirCVContoller.view.frame = CGRectMake(0,41,screenWidth,self.view.bounds.size.height-41);
    [self addChildViewController:busCirCVContoller];
    [self.view addSubview:busCirCVContoller.view];
}

-(void)setSegmentedControl{
    _leftUpArrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/4+27, 18, 9, 7)];
    _leftUpArrowIV.image = [UIImage imageNamed:@"sanjiao_2"];
    _rightUpArrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/4+38, 18, 9, 7)];
    _rightUpArrowIV.image = [UIImage imageNamed:@"sanjiao_2"];
    
    _typeCL = [[UIControl alloc] init];
    _typeCL.frame = CGRectMake(0, 0, screenWidth/2, 40);
    _typeCL.tag = 1;
    [_typeCL addTarget:self action:@selector(touchDownCL:) forControlEvents:UIControlEventTouchDown];
    _typeRL = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/4-20, 10, 60, 20)];
    _typeRL.text = @"全部";
    
    _orderCL = [[UIControl alloc] init];
    _orderCL.frame = CGRectMake(screenWidth/2+1,0, screenWidth/2, 40);
    _orderCL.tag = 2;
    [_orderCL addTarget:self action:@selector(touchDownCL:) forControlEvents:UIControlEventTouchDown];
    
    _orderRL = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/4-40, 10, 100, 20)];
    _orderRL.text = @"智能排序";
    
    UIView* segView = [[UIView alloc] init];
    segView.frame=CGRectMake(0, 0, screenWidth, 40);
    [_typeCL addSubview:_leftUpArrowIV];
    [_orderCL addSubview:_rightUpArrowIV];
    [_typeCL addSubview:_typeRL];
    [_orderCL addSubview:_orderRL];
    
    [segView addSubview:_typeCL];
    [segView addSubview:_orderCL];
     segView.backgroundColor = [UIColor whiteColor];
    line1=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2, 8, 0.6, 24)];
    line1.backgroundColor=[UIColor blackColor];
    line2=[[UILabel alloc] initWithFrame:CGRectMake(0,40, screenWidth, 0.5)];
    line2.backgroundColor = [UIColor blackColor];
    [segView addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:segView];
    
}
-(void)touchDownCL:(id)sender{

    switch ([sender tag]) {
        case 1:{
            
            _leftUpArrowIV.image = [UIImage imageNamed:@"sanjiao_1"];
            _rightUpArrowIV.image = [UIImage imageNamed:@"sanjiao_2"];
            _typeRL.textColor = UIColorFromRGB(0xFFBA02);
            _orderRL.textColor = [UIColor blackColor];
            typeName=[[NSMutableArray alloc] initWithObjects:@"全部",@"宾馆",@"餐饮",@"生活", nil];
            if(listView)
            {
                [listView removeFromSuperview];
            }
            listView = [[DownListView alloc] initWithArray:CGRectMake(0, CGRectGetMaxY(_typeCL.frame)+0.5, screenWidth/2, 160) array:typeName];
            NSLog(@"CGRectGetMaxY(_typeCL.frame) is %f",screenWidth/2);
            //CGRectMake(0, CGRectGetMaxY(_typeCL.frame)+0.5, _typeCL.frame.size.width, 160)
            listView.backgroundColor=[UIColor whiteColor];
            listView.selectId = 1;
            listView.defaultSV = _typeRL.text;
            listView.parentVC=self;
            [self.view addSubview:listView];
            break;
        }
        case 2:{
            
            _leftUpArrowIV.image = [UIImage imageNamed:@"sanjiao_2"];
            _rightUpArrowIV.image = [UIImage imageNamed:@"sanjiao_1"];
            _orderRL.textColor = UIColorFromRGB(0xFFBA02);
            _typeRL.textColor = [UIColor blackColor];
            typeName=[[NSMutableArray alloc] initWithObjects:@"智能排序",@"离我最近",@"好评优先",@"人气最高", nil];
            if(listView)
            {
                [listView removeFromSuperview];
            }
            listView = [[DownListView alloc] initWithArray:CGRectMake(screenWidth/2+1, CGRectGetMaxY(_orderCL.frame)+0.5, screenWidth/2-1, 160) array:typeName];
            listView.backgroundColor=[UIColor whiteColor];
            listView.selectId = 2;
            listView.defaultSV = _orderRL.text;
            listView.parentVC=self;
            [self.view addSubview:listView];
            break;
        }
        default:
            break;
    }
}

@end

