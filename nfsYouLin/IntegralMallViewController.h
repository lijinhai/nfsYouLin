//
//  IntegralMallViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralMallViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *integralValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *integralRuleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meLabel;
@property (weak, nonatomic) IBOutlet UIImageView *meImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) NSString *pointStr;
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectView;





typedef void (^ReturnTextBlock)(NSString *showText);
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
