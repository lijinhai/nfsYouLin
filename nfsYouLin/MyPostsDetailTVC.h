//
//  MyPostsDetailTVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/8/26.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderFile.h"
#import "MyPostsData.h"
#import "MyPostsDataFrame.h"
#import "NCellDelegate.h"
#import "ApplyDetailView.h"
#import "ShowImageView.h"
@interface MyPostsDetailTVC : UITableViewController<EMChatToolbarDelegate,cellDelegate>

@property (nonatomic, strong) MyPostsData* myPostsData;
@property (assign, nonatomic) NSInteger sectionNum;
@property (nonatomic, strong) MyPostsDataFrame* myPostsDF;
@property (nonatomic, strong) NSMutableArray* myPostsDA;


/*!
 @property
 @brief 底部输入控件
 */
@property (strong, nonatomic) UIView *chatToolbar;

/*!
 @property
 @brief 底部功能控件
 */
@property(strong, nonatomic) EaseChatBarMoreView *chatBarMoreView;
/*!
 @property
 @brief 底部表情控件
 */
@property(strong, nonatomic) EaseFaceView *faceView;

/*!
 @property
 @brief 底部录音控件
 */
@property(strong, nonatomic) EaseRecordView *recordView;


- (id) init;
@end
