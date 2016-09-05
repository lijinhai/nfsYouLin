//
//  CreateTopicVC.h
//  nfsYouLin
//
//  Created by Macx on 16/8/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController/TZImagePickerController.h"

@interface CreateTopicVC : UIViewController<TZImagePickerControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(strong, nonatomic) UIScrollView* scrollView;
@property(strong, nonatomic) UIScrollView* bgView;

@property(strong, nonatomic) UITextView* titleTV;
@property(strong, nonatomic) UILabel* titlePlaceholder;


@property(strong, nonatomic) UITextView* contentTV;
@property(strong, nonatomic) UILabel* contentPlaceholder;

@property(strong, nonatomic) UILabel* limitsL;


@property (nonatomic, strong) UICollectionView *imagesCView;
@property (nonatomic, strong) UIImagePickerController *imagesPickerVC;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *topicInfo;

- (id) init;
@end
