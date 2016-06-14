//
//  ShowImageView.h
//  nfsYouLin
//
//  Created by Macx on 16/5/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^didRemoveImage)(void);
@interface ShowImageView : UIView <UIScrollViewDelegate>
@property (nonatomic, copy) didRemoveImage removeImg;
@property (nonatomic, assign)CGRect selfFrame;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,assign)BOOL doubleClick;

- (void) show:(UIView*) bgView didFinish:(didRemoveImage)tempBlock;
// 展示圆形头像
- (id) initWithFrame:(CGRect)frame circularImage:(UIImage*) image;
// 展示图片
- (id) initWithFrame:(CGRect)frame byClickTag:(NSInteger)clickTag appendArray:(NSArray*)appendArray;


@end
