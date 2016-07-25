//
//  IntegralMallViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "IntegralMallViewController.h"
#import "UIImageView+WebCache.h"

@interface IntegralMallViewController ()

@end

@implementation IntegralMallViewController{
 
    UIColor *_viewColor;

}

- (void)viewDidLoad {
    [super viewDidLoad];
     _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=_viewColor;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{

    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     self.navigationItem.title=@"";
    self.backView.backgroundColor=[UIColor colorWithRed:255/255.0 green:186/255.0 blue:2/255.0 alpha:1];
    
    /*CollectView初始化*/
    self.goodsCollectView.backgroundColor=_viewColor;
    self.goodsCollectView.delegate=self;
    self.goodsCollectView.dataSource=self;

    [self.goodsCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CalendarCell"];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int lastSection=ceilf([_goodsArray count]/2.0)-1;
    if([_goodsArray count]%2==0)
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
    
    if(ceilf([_goodsArray count]/2.0)<=3)
        return ceilf([_goodsArray count]/2.0);
    else
        return 3;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger rowNo = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *CellIdentifier = @"CalendarCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    //    for(int i=0;i<[_goodsArray count];i++)
    //    {
    //
    //       NSLog(@"decodeString is %@",[[_goodsArray objectAtIndex:i] objectForKey:@"gl_name"]);
    //
    //    }
    
    NSURL* url = [NSURL URLWithString:[[_goodsArray objectAtIndex:rowNo] objectForKey:@"gl_pic"]];
    NSLog(@"url is %@",url);
    UIImageView* goodsPic=[[UIImageView alloc] init];
    [goodsPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_error.png"] options:SDWebImageAllowInvalidSSLCertificates];
    [cell.contentView addSubview:goodsPic];
    return cell;
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
