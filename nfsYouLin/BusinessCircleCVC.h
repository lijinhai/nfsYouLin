//
//  BusinessCircleCVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCircleCVC : UICollectionViewController

-(instancetype)init;


@property (nonatomic, strong) NSString *sort;// 0智能排序 1离我最近 2好评优先 3人气最高
@property (nonatomic, strong) NSString *bctag;// 0全部 1酒店 2美食 3生活

@end
