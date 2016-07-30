//
//  PopupGoodsExchageView.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/26.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupGoodsExchageView : UIView


/* 左按钮 */
@property(strong, nonatomic) UIButton* leftBtn;

/* 右按钮 */
@property(strong, nonatomic) UIButton* rightBtn;

/*物品计数*/
@property(strong, nonatomic) UITextField* countTextField;

/*确定按钮*/
@property(strong, nonatomic) UIButton* sureBtn;

/*积分统计*/
@property(strong, nonatomic) UILabel* totalLabel;

/*当前用户积分*/
@property(strong, nonatomic) NSString* totalPoint;

@property(strong, nonatomic) NSMutableArray* popupViewsArray;
@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property (nonatomic, strong) NSMutableArray *popupGoodsArray;
+ (instancetype)defaultPopupView:(CGRect)framet arrayId:(NSInteger)goodsID allGoodsArray:(NSMutableArray *) goodsAry allPoints:(NSInteger)goodsPoints;
-(void) dismissPopupView;
@end
