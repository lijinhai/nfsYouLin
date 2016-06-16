//
//  ListTableView.h
//  nfsYouLin
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
// 获取父窗口跳转的代码
typedef void (^moveTo)(NSString*);

@interface ListTableView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* labelNameArray;
@property (strong, nonatomic) NSArray* imageNameArray;
@property (strong, nonatomic) moveTo move;

- (id) initWithFrame:(CGRect)frame;
- (void) setListTableView: (NSArray*) textArray image:(NSArray*) imageArray block:(moveTo) move;
@end
