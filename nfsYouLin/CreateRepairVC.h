//
//  CreateRepairVC.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController/TZImagePickerController.h"

@interface CreateRepairVC : UIViewController<TZImagePickerControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

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
@property (nonatomic, strong) NSString *selectedType;

- (id) init;
@end

