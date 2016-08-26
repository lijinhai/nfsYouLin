//
//  IntegralMallViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "IntegralMallViewController.h"
#import "UIImageView+WebCache.h"
#import "PopupGoodsExchageView.h"
#import "PopupExchangeTipView.h"
#import "LewPopupViewController.h"
#import "IntegralRulesViewController.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "SqliteOperation.h"
#import "HeaderFile.h"
#import "Users.h"
#import "MBProgressHUBTool.h"
#import "MJRefresh.h"
#import "MyGiftsViewController.h"

@interface IntegralMallViewController ()
{
    
    MJRefreshFooter *_footer;
}


@end

@implementation IntegralMallViewController{
 
    UIColor *_viewColor;
    PopupGoodsExchageView *view;
    IntegralRulesViewController *IntegralRulesController;
    MyGiftsViewController *MyGiftsController;
    Users* user;
    NSTimer *timer;
    MJRefreshAutoNormalFooter *footer;
    NSMutableArray* dataArray;
    NSInteger sectionNum;
    NSInteger updateNum;
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=_viewColor;
    _integralRuleLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(integralRuleTouchUpInside:)];
    [_integralRuleLabel addGestureRecognizer:labelTapGestureRecognizer];
    /*数据源初始化*/
    [self collectViewDataInit];
    footer  = [MJRefreshAutoNormalFooter   footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.goodsCollectView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];

}

-(void)collectViewDataInit{

    dataArray=[[NSMutableArray alloc] init];
    if([_goodsArray count]<=6)
    {
    
        [dataArray addObjectsFromArray:_goodsArray];

    }else{
        
        
        for(int i=0;i<6;i++){
        
            [dataArray addObject:[_goodsArray objectAtIndex:i]];
        
        }
         /*更新数据计数初始化*/
        updateNum=[_goodsArray count]-6;
    }
    sectionNum=ceilf([dataArray count]/2.0);

}

-(void)viewWillAppear:(BOOL)animated{

    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     self.navigationItem.title=@"";
    self.backView.backgroundColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    /*积分label设置*/
    _integralValueLabel.attributedText=[self setIntegralLabel:self.pointStr];
    _integralValueLabel.textAlignment=NSTextAlignmentLeft;
    /*CollectView初始化*/
    self.goodsCollectView.backgroundColor=_viewColor;
    self.goodsCollectView.delegate=self;
    self.goodsCollectView.dataSource=self;
    self.goodsCollectView.translatesAutoresizingMaskIntoConstraints=NO;
    self.goodsCollectView.alwaysBounceVertical=YES;
    [self.goodsCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GoodsCell"];
    /*me label设置*/
    _meLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(meLabelTouchUpInside:)];
    
    [_meLabel addGestureRecognizer:labelTapGestureRecognizer];

    /*页面跳转*/
    UIStoryboard* iStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    IntegralRulesController=[iStoryBoard instantiateViewControllerWithIdentifier:@"integralrulescontroller"];
    MyGiftsController=[iStoryBoard instantiateViewControllerWithIdentifier:@"mygiftscontroller"];
    /*底部view*/
    _downRectLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height-20, self.goodsCollectView.frame.size.width, 20)];
    _downRectLabel.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:_downRectLabel];


}

-(void) meLabelTouchUpInside:(UITapGestureRecognizer *)recognizer{
   
    /*跳转至我的礼品*/
    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"我的礼品" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:MyGiftsController animated:YES];
    
    
}
- (void)returnText:(ReturnTextBlock)block {
    
    self.returnTextBlock = block;
}
/*设置积分标签*/
-(NSMutableAttributedString *)setIntegralLabel:(NSString *) integralStr{

    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:55.0f];
    NSString *integralsInfo=[NSString stringWithFormat:@"%@%@",integralStr,@"  分"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:integralsInfo];
    
    [AttributedStr setAttributes:@{NSFontAttributeName:fnt}
                           range:NSMakeRange(0, AttributedStr.length-3)];
    [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                           range:NSMakeRange(AttributedStr.length-3, 3)];
    return AttributedStr;
}

/*跳转至积分规则*/
-(void) integralRuleTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    /*跳转至积分规则*/
    UIBarButtonItem* neighborItem = [[UIBarButtonItem alloc] initWithTitle:@"积分规则" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:neighborItem];
    [self.navigationController pushViewController:IntegralRulesController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadMoreData{
    
    [self.goodsCollectView.mj_footer beginRefreshing];
    if([_goodsArray count]<=6)
    {
        
     [self.goodsCollectView.mj_footer endRefreshing];
      return;
    }
    else{
    
       if(updateNum/6!=0)
       {
         for (NSUInteger i = [dataArray count]; i<[dataArray count]+6; i++) {
            
            [dataArray addObject:[_goodsArray objectAtIndex:i]];
            
          }
           updateNum=updateNum-6;
       }else{
       
           for (NSUInteger i = [dataArray count]; i<[_goodsArray count]; i++) {
               
               [dataArray addObject:[_goodsArray objectAtIndex:i]];
               
           }
       
       }
    }
     sectionNum=ceilf([dataArray count]/2.0);
    [self performSelector:@selector(doneWithView) withObject:nil afterDelay:2.0];

}
- (void)doneWithView
{
    [self.goodsCollectView reloadData];
   
    [self.goodsCollectView.mj_footer endRefreshing];
}

#pragma mark - UICollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int lastSection=ceilf([dataArray count]/2.0)-1;
    if([dataArray count]%2==0)
    {
        return 2;
    }else{
       if(section==lastSection)
        {
            return 1;
        }else{
        
            return 2;
        }
       
        }
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return sectionNum;
    //ceilf([dataArray count]/2.0);
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger rowNo = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *CellIdentifier = @"GoodsCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UICollectionViewCell alloc]init ];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
     cell.backgroundColor = [UIColor whiteColor];
    
    UIColor *fontColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    
    NSURL* url = [NSURL URLWithString:[[dataArray objectAtIndex:(section*2+rowNo)] objectForKey:@"gl_pic"]];
    NSLog(@"url is %@",url);
    float scale=0.6;//缩放比例
    UIImageView* goodsPic=[[UIImageView alloc] init];
    UILabel* pointsLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    pointsLable.center=CGPointMake(cell.frame.size.width/2+30, 25);
    pointsLable.textColor=fontColor;
    NSString *pointsInfo=[NSString stringWithFormat:@"%@%@",[[dataArray objectAtIndex:(section*2+rowNo)] objectForKey:@"gl_credit"],@"  分"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:pointsInfo];
    
    [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}
                          range:NSMakeRange(0, pointsInfo.length-3)];
    [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                           range:NSMakeRange(pointsInfo.length-3, 3)];
    pointsLable.attributedText = AttributedStr;
    pointsLable.textAlignment=NSTextAlignmentLeft;

    UILabel* nameLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    nameLable.text=[[dataArray objectAtIndex:(section*2+rowNo)] objectForKey:@"gl_name"];
    nameLable.font=[UIFont systemFontOfSize:14];
    nameLable.center=CGPointMake(cell.frame.size.width/2+30, 47);
    
    UIButton* clickGetGoods=[[UIButton alloc] init];
    clickGetGoods.frame=CGRectMake(0,0,75, 25);
    clickGetGoods.center=CGPointMake(cell.frame.size.width/2, cell.frame.size.height-25);
    clickGetGoods.tag=section*2+rowNo;
    clickGetGoods.titleLabel.textColor=[UIColor whiteColor];
    clickGetGoods.titleLabel.font=[UIFont systemFontOfSize:14];
    clickGetGoods.layer.cornerRadius=12;
    clickGetGoods.backgroundColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    [clickGetGoods setTitle:@"点击领取" forState:UIControlStateNormal];
    [clickGetGoods addTarget:self action:@selector(clickGetGoods:) forControlEvents:UIControlEventTouchUpInside];

    [goodsPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:(SDWebImageAllowInvalidSSLCertificates) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        goodsPic.frame = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
        goodsPic.center=CGPointMake(55, 40);
    }];
    [cell.contentView addSubview:goodsPic];
    [cell.contentView addSubview:nameLable];
    [cell.contentView addSubview:pointsLable];
    [cell.contentView addSubview:clickGetGoods];
    }
    return cell;
}

-(void)clickGetGoods:(UIButton *)btn
{

    view = [PopupGoodsExchageView defaultPopupView:CGRectMake(0, 0, 160, 200) arrayId:btn.tag allGoodsArray:self.goodsArray allPoints:[self.pointStr intValue]];
    view.parentVC = self;
    UIButton *leftButton=view.leftBtn;
    leftButton.tag=btn.tag;
    UIButton *rightButton=view.rightBtn;
    rightButton.tag=btn.tag;
    UIButton *sureButton=view.sureBtn;
    
    [leftButton addTarget:self action:@selector(jiaCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(jianCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
     [self lew_presentPopupViews:(view.popupViewsArray) animation:[LewPopupViewAnimationRight new] dismissed:^{
        NSLog(@"动画结束");
     }];
   
}

/*确定兑换商品*/
-(void)submitAction:(id) sender{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* communityId = [NSString stringWithFormat:@"%ld", [SqliteOperation getNowCommunityId]];
    NSString* countStr=view.countTextField.text;
    NSString* glIdStr=[NSString stringWithFormat:@"%ld",[sender tag]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@count%@gl_id%@",userId,communityId,countStr,glIdStr]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@3",hashString]];
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"count": countStr,
                                @"gl_id": glIdStr,
                                @"deviceType":@"ios",
                                @"apitype" : @"exchange",
                                @"tag" : @"exchangegifts",
                                @"salt" : @"3",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:community_id:count:gl_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [view dismissPopupView];
        NSLog(@"responseObject is %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            
            [self updateUserIntegral:[SqliteOperation getUserId]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];
    
   
}

/*更新用户积分*/
-(void)updateUserIntegral:(long) userid{
    
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.5
                                           target:self
                                         selector:@selector(popupExchangeSuccessView)
                                         userInfo:nil
                                          repeats:NO];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* myId = [NSString stringWithFormat:@"%ld",userid];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@",myId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1024",hashString]];
    NSDictionary* parameter = @{@"user_id" : myId,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"usercredit",
                                @"salt" : @"1024",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.pointStr=[responseObject objectForKey:@"credit"];
        NSMutableAttributedString *AttributedStr=[self setIntegralLabel:self.pointStr];
        _integralValueLabel.attributedText=AttributedStr;
        if (self.returnTextBlock != nil) {
            self.returnTextBlock(self.pointStr);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        return;
    }];
}

/*弹出兑换成功view*/
-(void)popupExchangeSuccessView{

    PopupExchangeTipView *tipView = [PopupExchangeTipView defaultPopupView];
    tipView.parentVC = self;
    [self lew_presentPopupView:tipView animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束ing");
    }];
    [MBProgressHUBTool textToast:self.view Tip:@"兑换礼品成功"];


}
/*加计数*/
-(void)jiaCountAction:(id) sender{
    
    NSLog(@"sender is %ld",[sender tag]);
    NSInteger goodsNum=[view.countTextField.text intValue];
    NSInteger goodCredit=[[[dataArray objectAtIndex:[sender tag]] objectForKey:@"gl_credit"] intValue];
    NSString* goodsNumStr=[NSString stringWithFormat:@"%ld",++goodsNum];
    [self checkCountIntregal:[goodsNumStr intValue] goodsCredit:goodCredit];
    [view.countTextField setText:goodsNumStr];
}
/*减计数*/
-(void)jianCountAction:(id) sender{
    
    NSInteger goodCredit=[[[dataArray objectAtIndex:[sender tag]] objectForKey:@"gl_credit"] intValue];
    NSInteger goodsNum=[view.countTextField.text intValue];
    if(goodsNum>1)
    {
      NSString* goodsNumStr=[NSString stringWithFormat:@"%ld",--goodsNum];
      [self checkCountIntregal:[goodsNumStr intValue] goodsCredit:goodCredit];
      [view.countTextField setText:goodsNumStr];
    }else
        return;
}
/*判断当前积分是否足够*/
-(void)checkCountIntregal:(NSInteger) goodsCount goodsCredit:(NSInteger) creditValue{
    
     UIColor *fontColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
     NSInteger totalIntregal=goodsCount*creditValue;
     NSString *tip=nil;
    if(totalIntregal>[self.pointStr intValue])
    {
    
            tip=@"（你的积分未达到）";
            view.sureBtn.backgroundColor=[UIColor lightGrayColor];
            view.sureBtn.userInteractionEnabled=NO;
        
    }else{
            
            tip=@"";
            view.sureBtn.backgroundColor=fontColor;
            view.sureBtn.userInteractionEnabled=YES;
     }
        NSString *jifenStr=@" 积分";
        NSString *pointsInfo=[NSString stringWithFormat:@"%@%ld%@%@",@"合计：",totalIntregal,jifenStr,tip];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:pointsInfo];
        /*合计*/
        [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 3)];
        /*分数*/
        [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:fontColor}
                               range:NSMakeRange(3, pointsInfo.length-6-tip.length)];
        /*积分*/
        [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:fontColor}
                               range:NSMakeRange(pointsInfo.length-tip.length-3, 3)];
        
        /*tip*/
        if(tip.length>0)
        {
            [AttributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}range:NSMakeRange(pointsInfo.length-tip.length, tip.length)];
            
        }
        [view.totalLabel setAttributedText:AttributedStr];
    
    
}
#pragma mark- *UIScrollViewDelegate*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    float offset=self.goodsCollectView.contentOffset.y;
    if(offset<=0)
    {
        [self.goodsCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float offset=self.goodsCollectView.contentOffset.y;
    NSLog(@"offset is %f",offset);
    if(offset<5.0){
    
    [self.goodsCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        [footer endRefreshingWithNoMoreData];
    }else{
        [footer setTitle:@"正在载入中..." forState:MJRefreshStateRefreshing];

    }

}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([ UIScreen mainScreen ].bounds.size.width/2.0-1, _goodsCollectView.bounds.size.height/3);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);//分别为上、左、下、右
}

@end
