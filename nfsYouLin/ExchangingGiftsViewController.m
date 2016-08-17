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
#define SCREEN_WIDTH   ([[UIScreen mainScreen] bounds].size.width)

@interface ExchangingGiftsViewController ()
{
    
    MJRefreshFooter *_footer;
}

@end

@implementation ExchangingGiftsViewController{

 UIActivityIndicatorView* _indicator;
 MJRefreshAutoNormalFooter *footer;
 NSMutableArray* goodsArr;
 NSString*  lastGoodsIdStr;
 BOOL updateFlag;
 NSTimer *timer;
    
}
static NSString * const reuseIdentifier = @"Cell";


-(void) getExchangingGifts:(NSString *)actionType ueId:(NSString *)goodsId{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* communityId = [NSString stringWithFormat:@"%ld", [SqliteOperation getNowCommunityId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%@action_type%@list_type%@ue_id%@",userId,communityId,actionType,@"1",goodsId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@3",hashString]];
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : communityId,
                                @"action_type": actionType,
                                @"list_type": @"1",
                                @"ue_id" :goodsId,
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
        
        NSLog(@"responseObject is %@",responseObject);
        NSMutableArray *responseObjectAry=[responseObject objectForKey:@"info"];
        for(int i=0;i<[responseObjectAry count];i++){
            goodsInfo* goodsObj=[[goodsInfo alloc] init];
            goodsObj.goodsPicUrl=[[responseObjectAry objectAtIndex:i] objectForKey:@"gl_pic"];
            goodsObj.goodsName=[[responseObjectAry objectAtIndex:i] objectForKey:@"gl_name"];
            goodsObj.exchangeNums=[[responseObjectAry objectAtIndex:i] objectForKey:@"ue_count"];
            goodsObj.exchangePoints=[[responseObjectAry objectAtIndex:i] objectForKey:@"ue_credit"];
           

            [goodsArr addObject:goodsObj];
            
        };
        lastGoodsIdStr=[[responseObjectAry objectAtIndex:[responseObjectAry count]-1] objectForKey:@"ue_id"];
        if(lastGoodsIdStr==NULL)
        {
            NSLog(@"lastGoodsIdStr is %@",lastGoodsIdStr);
            updateFlag=NO;
        }else{
        
            updateFlag=YES;
        }
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
    
    
    footer  = [MJRefreshAutoNormalFooter   footerWithRefreshingTarget:self refreshingAction:@selector(loadExchangeData)];
    self.collectionView.mj_footer = footer;
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"放开以刷新" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在载入" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    [self setUpdateLabelState];
    
}

- (void)viewWillAppear:(BOOL)animated{

    self.collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    self.collectionView.alwaysBounceVertical=YES;
    goodsArr=[[NSMutableArray alloc] init];
    [self getExchangingGifts:@"1" ueId:@"0"];
    
}

-(void)loadExchangeData{
   
    if(updateFlag)
    {
    [self.collectionView.mj_footer beginRefreshing];
    [self getExchangingGifts:@"2" ueId:lastGoodsIdStr];
    
    [self performSelector:@selector(doneWithView) withObject:nil afterDelay:2.0];
    }
}
- (void)doneWithView
{
    [self.collectionView reloadData];
    
    [self.collectionView.mj_footer endRefreshing];
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
#pragma mark- *UIScrollViewDelegate*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float offset=self.collectionView.contentOffset.y;
    if(offset<=0)
    {
        [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
        //[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float offset=self.collectionView.contentOffset.y;
    NSLog(@"offset is %f",offset);
    if(offset<5.0){
        
        [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
        //[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        [footer endRefreshingWithNoMoreData];
    }else{
        [footer setTitle:@"正在载入中..." forState:MJRefreshStateRefreshing];
        
    }
    [self setUpdateLabelState];
    
}
-(void)dismissLabelText{
    
    UILabel* label1=(UILabel *)[self.view viewWithTag:101];
    label1.text=@"";
}
/*设置下拉刷新后标签显示状态*/
-(void)setUpdateLabelState{

    if(updateFlag==NO)
    {
        UILabel* label1=(UILabel *)[self.view viewWithTag:101];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.font=[UIFont systemFontOfSize:12];
        label1.text=@"没有更多";
        timer=[NSTimer scheduledTimerWithTimeInterval:3
                                               target:self
                                             selector:@selector(dismissLabelText)
                                             userInfo:nil
                                            repeats:NO];
    }
    
}

@end