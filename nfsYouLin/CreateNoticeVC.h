//
//  CreateNoticeVC.h
//  nfsYouLin
//
//  Created by Macx on 16/9/28.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController/TZImagePickerController.h"

@interface CreateNoticeVC : UIViewController<TZImagePickerControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITextViewDelegate>

@property(strong, nonatomic) UIScrollView* scrollView;
@property(strong, nonatomic) UIScrollView* bgView;

@property(strong, nonatomic) UITextView* titleTV;
@property(strong, nonatomic) UILabel* titlePlaceholder;


@property(strong, nonatomic) UITextView* contentTV;
@property(strong, nonatomic) UILabel* contentPlaceholder;


@property (nonatomic, strong) UICollectionView *imagesCView;
@property (nonatomic, strong) UIImagePickerController *imagesPickerVC;

@property (nonatomic, strong) NSMutableDictionary *topicInfo;

- (id) init;


@end
