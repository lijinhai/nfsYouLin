//
//  NeighborDetailTVC.h
//  nfsYouLin
//
//  Created by Macx on 16/6/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCellDelegate.h"
#import "NeighborData.h"
#import "NeighborDataFrame.h"
#import "ShowImageView.h"
#import "DetailListView.h"

@interface NeighborDetailTVC : UITableViewController <DetailListViewDelegate,EMChatToolbarDelegate, EaseChatBarMoreViewDelegate,EMLocationViewDelegate,cellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NeighborData* neighborData;
@property (assign, nonatomic) NSInteger sectionNum;
@property (nonatomic, strong) NeighborDataFrame* neighborDF;
@property (nonatomic, strong) NSMutableArray* neighborDA;


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


/*!
 @property
 @brief 图片选择器
 */
@property (strong, nonatomic) UIImagePickerController *imagePicker;

- (void) getReplyNet;

- (id) init;
@end
