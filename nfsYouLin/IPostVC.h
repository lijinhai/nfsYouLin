//
//  IPostVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/8/24.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowImageView.h"
#import "MyPostsTableViewCell.h"
#import "MyPostsDataFrame.h"
@interface IPostVC : UIViewController<UITableViewDelegate,UITableViewDataSource,cellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *PostsTableView;


@property (nonatomic,strong)NSMutableArray *postsDataArray;
@property (assign, nonatomic)BOOL refresh;

@end
