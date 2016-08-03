//
//  ExchangingGiftsViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/8/1.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ExchangingGiftsViewController.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "SqliteOperation.h"
#import "HeaderFile.h"
#import "UIImageView+WebCache.h"
#import "GoodsCollectionViewCell.h"
#import "goodsInfo.h"
#import "MJRefresh.h"

@interface ExchangingGiftsViewController ()
{
    
    MJRefreshFooter *_footer;
}

@end

@implementation ExchangingGiftsViewController{

 UIActivityIndicatorView* _indicator;
 MJRefreshAutoNormalFooter *footer;
 NSMutableArray* goodsArr;
    
}
static NSString * const reuseIdentifier = @"Cell";


-(void) getExchangingGifts{
    
    goodsArr=[[NSMutableArray alloc] init];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* communityId = [NSString stringWithFormat:@"%ld", [SqliteOperation getNowCommunityId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@action_type%@list_type%@ue_id%@",userId,communityId,@"1",@"1",@"0"]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@3",hashString]];
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"action_type": @"1",
                                @"list_type": @"1",
                                @"ue_id" : @"0",
                                @"deviceType":@"ios",
                                @"apitype":@"exchange",
                                @"tag" : @"getmygiftlist",
                                @"salt" : @"3",
                                @"hash" : hashMD5,
                                @"keyset" : @"user_id:community_id:action_type:list_type:ue_id:",
                                };
    [_indicator startAnimating];
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *responseObjectAry=[responseObject objectForKey:@"info"];
        for(int i=0;i<[responseObjectAry count];i++){
            goodsInfo* goodsObj=[[goodsInfo alloc] init];
            goodsObj.goodsPicUrl=[[responseObjectAry objectAtIndex:i] objectForKey:@"gl_pic"];
            goodsObj.goodsName=[[responseObjectAry objectAtIndex:i] objectForKey:@"gl_name"];
            goodsObj.exchangeNums=[[responseObjectAry objectAtIndex:i] objectForKey:@"ue_count"];
            goodsObj.exchangePoints=[[responseObjectAry objectAtIndex:i] objectForKey:@"ue_credit"];
           
            [goodsArr addObject:goodsObj];
            
        };
        
        NSLog(@"goodsArr is %ld",[goodsArr count]);
        [_indicator stopAnimating];
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        
        [_indicator stopAnimating];
        return;
    }];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.collectionView registerClass:[GoodsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier ];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    footer  = [MJRefreshAutoNormalFooter   footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.collectionView.mj_footer = footer;
    
    footer.refreshingTitleHidden=YES;

    //footer.stateLabel.hidden=YES;
    //self.collectionView.bounces = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{

   [self getExchangingGifts];

}

-(void)loadMoreData{




}


-(id)init{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];

    if (self=[super initWithCollectionViewLayout:layout]) {
        
        // 设置cell的尺寸
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        // 设置滚动的方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 行间距
        layout.minimumLineSpacing = 1;
        // 设置cell之间的间距
        layout.minimumInteritemSpacing = 0;
        
    }
    return self;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    
    return [goodsArr count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsCollectionViewCell* cell = (GoodsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier  forIndexPath:indexPath];
    NSLog(@"indexPath.section is %ld",indexPath.section);
    goodsInfo* cellGoods=[goodsArr objectAtIndex:indexPath.section];
    cell.goodsData=cellGoods;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
