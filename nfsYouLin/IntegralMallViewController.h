//
//  IntegralMallViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralMallViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *integralValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *integralRuleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meLabel;
@property (weak, nonatomic) IBOutlet UIImageView *meImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectView;

@end
