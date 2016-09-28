//
//  BusinessCircleCVC.m
//  nfsYouLin
//
//  Created by jinhai on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "BusinessCircleCVC.h"
#import "SellerCVCell.h"
#import "SellerInfo.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "SqliteOperation.h"
#import "HeaderFile.h"
#import "MBProgressHUBTool.h"
#import "SellerInfo.h"
#import "DetailSellerInfoVC.h"
#import "MJRefresh.h"

@interface BusinessCircleCVC ()

@end

@implementation BusinessCircleCVC{

    NSMutableArray* sellerAry;
    UIActivityIndicatorView* _indicator;
    UIPanGestureRecognizer* _panGesture;
    NSInteger pageNo;

}

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    // 创建一个流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    //[layout setItemSize:CGSizeMake(screenWidth, 80)];
    // 设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 行间距
    layout.minimumLineSpacing = 1;
    
    // 设置cell之间的间距
    layout.minimumInteritemSpacing = 0;
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2-25 , 200, 50, 50)];
    [self.view addSubview:_indicator];
    _indicator.hidesWhenStopped = YES;
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    _indicator.color = UIColorFromRGB(0xFFD700);
     sellerAry = [[NSMutableArray alloc] init];
    [self getCommCircleInfo];
    //隐藏水平滚动条
     self.collectionView.showsHorizontalScrollIndicator = NO;
    //取消弹簧效果
     self.collectionView.bounces = NO;
     self.collectionView.backgroundColor = [UIColor whiteColor];
     self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];
    pageNo = 1;
    _panGesture = self.collectionView.panGestureRecognizer;
    [_panGesture addTarget:self action:@selector(handlePan:)];
    // Register cell classes
    [self.collectionView registerClass:[SellerCVCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

-(void) handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:self.collectionView];
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if(translation.y > 0)
        {
            self.collectionView.bounces = NO;
        }
        // 底部上拉
        else if(translation.y < 0)
        {
            self.collectionView.bounces = YES;
        }
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat h = self.collectionView.contentSize.height;
        CGFloat H = CGRectGetHeight(self.view.frame);
        if(h <= H)
        {
            self.collectionView.contentSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), H + 5);
        }
    }
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     self.collectionView.translatesAutoresizingMaskIntoConstraints=NO;
     self.collectionView.alwaysBounceVertical=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 获取商圈信息
-(void)getCommCircleInfo{

    NSLog(@"sortStr = %@\n bctagStr = %@\n",_sort,_bctag);
    [_indicator startAnimating];
    [sellerAry removeAllObjects];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* pageStr = @"0";
    NSString* sortStr = _sort;
    NSString* bctagStr = _bctag;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"sort%@community_id%@page%@bctag%@",sortStr,communityId,pageStr,bctagStr]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"sort" : sortStr,
                                @"community_id" : communityId,
                                @"page" : pageStr,
                                @"bctag" : bctagStr,
                                @"apitype" : @"address",
                                @"tag" : @"bizcir",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"sort:community_id:page:bctag:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"小区商圈请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++)
            {
                SellerInfo* sellerObj = [[SellerInfo alloc] init];
                sellerObj.sellerPicUrl = [[responseObject objectAtIndex:i] valueForKey:@"img_url"];
                sellerObj.sellerPosition = [[responseObject objectAtIndex:i] valueForKey:@"address"];
                sellerObj.sellerDistance = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"distance"]];
                sellerObj.sellerLevel = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"facility"]];
                sellerObj.sellerName = [[responseObject objectAtIndex:i] valueForKey:@"name"];
                sellerObj.sellerUuid = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"uid"]];
                [sellerAry addObject:sellerObj];
            
            }
            
        }else{
        
        
            [MBProgressHUBTool textToast:self.view Tip:[responseObject valueForKey:@"yl_msg"]];
        
        }
        [_indicator stopAnimating];
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}

// 上拉刷新获取更多商圈信息
-(void)upRefreshData{

    [sellerAry removeAllObjects];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* communityId = [defaults stringForKey:@"communityId"];
    NSString* sortStr = _sort;
    NSString* bctagStr = _bctag;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"sort%@community_id%@page%@bctag%@",sortStr,communityId,[NSString stringWithFormat:@"%ld",pageNo],bctagStr]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"sort" : sortStr,
                                @"community_id" : communityId,
                                @"page" : [NSString stringWithFormat:@"%ld",pageNo],
                                @"bctag" : bctagStr,
                                @"apitype" : @"address",
                                @"tag" : @"bizcir",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"sort:community_id:page:bctag:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"小区商圈上拉请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [responseObject count]; i++)
            {
                SellerInfo* sellerObj = [[SellerInfo alloc] init];
                sellerObj.sellerPicUrl = [[responseObject objectAtIndex:i] valueForKey:@"img_url"];
                sellerObj.sellerPosition = [[responseObject objectAtIndex:i] valueForKey:@"address"];
                sellerObj.sellerDistance = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"distance"]];
                sellerObj.sellerLevel = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"facility"]];
                sellerObj.sellerName = [[responseObject objectAtIndex:i] valueForKey:@"name"];
                sellerObj.sellerUuid = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:i] valueForKey:@"uid"]];
                [sellerAry addObject:sellerObj];
                
            }
            
            pageNo++;
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
            
        }else{
            
            
            [MBProgressHUBTool textToast:self.view Tip:[responseObject valueForKey:@"yl_msg"]];
            [self.collectionView.mj_footer endRefreshing];
            
        }
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];

}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [sellerAry count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.section is %ld",indexPath.section);
    SellerCVCell* cell = (SellerCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier  forIndexPath:indexPath];
    SellerInfo* cellSellers=[sellerAry objectAtIndex:indexPath.section];
    cell.sellerData=cellSellers;

    NSLog(@"UICollectionViewCell");
    return cell;
}

// 点击跳转至商家详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    NSLog(@"indexPath.section is %ld",indexPath.section);
    DetailSellerInfoVC *jumpDSIVC = [[DetailSellerInfoVC alloc] init];
    SellerInfo* cellSellers = [sellerAry objectAtIndex:indexPath.section];
    jumpDSIVC.uuid = cellSellers.sellerUuid;
    jumpDSIVC.insteadIVURL = cellSellers.sellerPicUrl;
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle:@"内容详情" style:UIBarButtonItemStylePlain target:nil action:nil];
    //[[self.navigationController.navigationBar.subviews objectAtIndex:1] removeFromSuperview];
     self.parentViewController.navigationItem.backBarButtonItem = backItem;
    [self.parentViewController.navigationController pushViewController:jumpDSIVC animated:NO];
    NSLog(@"jumpDSIVC.uuid is %@",jumpDSIVC.uuid);
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake([ UIScreen mainScreen ].bounds.size.width-1, 100);
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
