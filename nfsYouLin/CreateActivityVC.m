//
//  CreateActivityVC.m
//  nfsYouLin
//
//  Created by Macx on 16/8/23.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "CreateActivityVC.h"
#import "LxGridViewFlowLayout.h"
#import "PickerCVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "CreateTVC.h"
#import "AppDelegate.h"
#import "HeaderFile.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "ChatDemoHelper.h"
#import "WaitView.h"
#import "PublishLimitVC.h"
#import "DialogView.h"
#import "MapVC.h"
#import "MBProgressHUBTool.h"

@interface CreateActivityVC ()

@end

@implementation CreateActivityVC
{
    CGFloat titlePreHeight;
    CGFloat titleMinHeight;
    
    CGFloat contentPreHeight;
    CGFloat contentMinHeight;
    CGFloat contentMaxHeight;
    
    
    UIView* line1;
    UIView* line2;
    UIView* line3;
    UIView* line4;
    
    NSMutableArray *selectedPhotos;
    NSMutableArray *selectedAssets;
    
    BOOL isSelectOriginalPhoto;
    LxGridViewFlowLayout* imagesLayout;
    CGFloat imageWH;
    CGFloat imageMargin;
    CGRect imageCVFrame1;
    CGRect imageCVFrame2;
    CGRect imageCVFrame3;
    CGFloat originalCVH;
    
    PublishLimitVC* limitVC;
    MapVC* mapVC;
    
    UIImageView* emptyIV;
    
    NSString* userId;
    NSString* familyId;
    NSString* portrait;
    NSString* nick;
    NSString* familyAddress;
    NSString* communityAddress;
    long cityId;
    long communityId;
    
    UIImageView* _backIV;
    UILabel* _backLabel;
    UIView* backgroundView;
//    UIView* dateBgView;
    DialogView* dialogView;
    UIViewController* rootVC;
    KMDatePicker *datePicker;
    
    UILabel* startL;
    UILabel* endL;
    NSInteger timeRow;
    
    // yyyy年MM月dd日HH时mm分
    NSString* startStr;
    NSString* endStr;
    
    // yyyy-MM-dd HH:mm
    NSString* startStr1;
    NSString* endStr1;

    
    BOOL startB;
    BOOL endB;
    BOOL addressB;
    
    long startTime;
    long endTime;
    

}

- (id) init
{
    self = [super init];
    if(self)
    {
        startB = true;
        endB = true;
        addressB = true;
    }
    return self;
}


- (UIImagePickerController *)imagePickerVC {
    if (_imagesPickerVC == nil) {
        _imagesPickerVC = [[UIImagePickerController alloc] init];
        _imagesPickerVC.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagesPickerVC.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagesPickerVC.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagesPickerVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendResult:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIColor* lineColor = [UIColor colorWithRed:217.0 / 255.0 green:216.0 / 255.0 blue:213.0 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 80)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.scrollView.bounces = NO;
 
    self.scrollView.delegate = self;
    self.bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 450)];
    self.bgView.bounces = NO;
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), 1)];
    line1.backgroundColor = lineColor;
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake(40, 40, CGRectGetWidth(self.bgView.frame) - 80, 1)];
    line2.backgroundColor = lineColor;
    
    line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bgView.frame) - 200, CGRectGetWidth(self.bgView.frame), 1)];
    line3.backgroundColor = lineColor;
    
    line4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bgView.frame)-1, CGRectGetWidth(self.bgView.frame), 1)];
    line4.backgroundColor = lineColor;
    
    self.titleTV = [[UITextView alloc] initWithFrame:CGRectMake(20, 1, CGRectGetWidth(self.bgView.frame) - 40, 38)];
    self.titleTV.backgroundColor = [UIColor whiteColor];
    self.titleTV.scrollEnabled = NO;
    self.titleTV.font = [UIFont boldSystemFontOfSize:18];
    self.titleTV.delegate = self;
    self.titleTV.returnKeyType = UIReturnKeyDone;
    self.titleTV.autoresizingMask = UIViewAutoresizingNone;
    titlePreHeight = ceilf([self.titleTV sizeThatFits:self.titleTV.frame.size].height);
    titleMinHeight = titlePreHeight;
    
    self.titlePlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, CGRectGetWidth(self.titleTV.frame), 18)];
    self.titlePlaceholder.text = @"标题";
    self.titlePlaceholder.textAlignment = NSTextAlignmentLeft;
    self.titlePlaceholder.font = [UIFont boldSystemFontOfSize:18];
    self.titlePlaceholder.enabled = NO;
    [self.titleTV addSubview:self.titlePlaceholder];
    [self.bgView addSubview:self.titleTV];
    
    emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line2.frame) - 10, 10, 20, 20)];
    emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
    emptyIV.layer.masksToBounds = YES;
    emptyIV.layer.cornerRadius = 10;
    emptyIV.hidden = YES;
    [self.bgView addSubview:emptyIV];
    
    
    self.contentTV = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line2.frame), CGRectGetWidth(self.bgView.frame) - 40, 38)];
    
    self.contentTV.backgroundColor = [UIColor whiteColor];
    self.contentTV.scrollEnabled = NO;
    self.contentTV.font = [UIFont systemFontOfSize:14];
    self.contentTV.returnKeyType = UIReturnKeyDone;
    self.contentTV.delegate = self;
    
    self.contentTV.autoresizingMask = UIViewAutoresizingNone;
    contentPreHeight = ceilf([self.contentTV sizeThatFits:self.contentTV.frame.size].height);
    contentMinHeight = contentPreHeight;
    self.contentPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, CGRectGetWidth(self.contentTV.frame), 14)];
    self.contentPlaceholder.text = @"描述内容...";
    self.contentPlaceholder.textAlignment = NSTextAlignmentLeft;
    self.contentPlaceholder.font = [UIFont systemFontOfSize:14];
    self.contentPlaceholder.enabled = NO;
    [self.contentTV addSubview:self.contentPlaceholder];
    [self.bgView addSubview:self.contentTV];
    
    selectedPhotos = [NSMutableArray array];
    selectedAssets = [NSMutableArray array];
    imageMargin = 4;
    imageWH = (self.view.frame.size.width - 5 * imageMargin - 32) / 5;
    imagesLayout = [[LxGridViewFlowLayout alloc] init];
    imagesLayout.itemSize = CGSizeMake(imageWH, imageWH);
    imagesLayout.minimumLineSpacing = imageMargin;
    imagesLayout.minimumLineSpacing = imageMargin;
    CGFloat frameY = CGRectGetMaxY(line3.frame) - imageWH - 15;
    imageCVFrame1 = CGRectMake(16,frameY, CGRectGetWidth(self.view.frame) - 32 , imageWH + imageMargin);
    imageCVFrame2 = CGRectMake(16, frameY, CGRectGetWidth(self.view.frame) - 32, 2*(imageWH + imageMargin));
    imageCVFrame3 = CGRectMake(16, frameY, CGRectGetWidth(self.view.frame) - 32, 3*(imageWH + imageMargin));
    originalCVH = imageWH + imageMargin;
    
    _imagesCView = [[UICollectionView alloc] initWithFrame:imageCVFrame1 collectionViewLayout:imagesLayout];
    _imagesCView.alwaysBounceVertical = YES;
    _imagesCView.scrollEnabled = NO;
    _imagesCView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _imagesCView.backgroundColor = [UIColor whiteColor];
    
    _imagesCView.dataSource = self;
    _imagesCView.delegate = self;
    [_imagesCView registerClass:[PickerCVC class] forCellWithReuseIdentifier:@"PickerCVC"];
    [self.bgView addSubview:_imagesCView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line3.frame), CGRectGetWidth(self.bgView.frame), 200) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor orangeColor];
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.bgView addSubview:self.tableView];
    
    [self.bgView addSubview:line1];
    [self.bgView addSubview:line2];
    [self.bgView addSubview:line3];
    [self.bgView addSubview:line4];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.scrollView addSubview:self.bgView];
    [self.view addSubview:self.scrollView];
    [self searchSql];
    limitVC = [[PublishLimitVC alloc] init];
    mapVC = [[MapVC alloc] init];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    rootVC = window.rootViewController.navigationController;
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.8;
    
    datePicker = [[KMDatePicker alloc]
                  initWithFrame:CGRectMake(30, (CGRectGetHeight(self.view.frame) - 216) / 2, CGRectGetWidth(self.view.frame) - 60, 216)
                  delegate:self
                  datePickerStyle:KMDatePickerStyleYearMonthDayHourMinute];
    timeRow = 0;
    startTime = 0;
    endTime = 0;
    dialogView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createBackItemBtn];
    if(mapVC.address != nil && mapVC.address.length > 0)
    {
        addressB = true;
    }
    [self.tableView reloadData];
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PickerCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PickerCVC" forIndexPath:indexPath];
    if (indexPath.row == [selectedPhotos count]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_addpic_unfocused.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        
        cell.imageView.image = selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == selectedPhotos.count) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        [sheet showInView:self.view];
    }
    else
    {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:selectedAssets selectedPhotos:selectedPhotos index:indexPath.row];
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL selectOriginalPhoto) {
            selectedPhotos = [NSMutableArray arrayWithArray:photos];
            selectedAssets = [NSMutableArray arrayWithArray:assets];
            isSelectOriginalPhoto = selectOriginalPhoto;
            imagesLayout.itemCount = selectedPhotos.count;
            [_imagesCView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= selectedPhotos.count || destinationIndexPath.item >= selectedPhotos.count) return;
    UIImage *image = selectedPhotos[sourceIndexPath.item];
    if (image) {
        [selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_imagesCView reloadData];
    }
}

#pragma mark - UIActionSheetDelegate

// take photo / 去拍照
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.selectedAssets = selectedAssets;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^{
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models firstObject];
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    [selectedAssets addObject:assetModel.asset];
                    [selectedPhotos addObject:image];
                    [_imagesCView reloadData];
                }];
            }];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVC.sourceType = sourceType;
            if(iOS8Later) {
                _imagesPickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagesPickerVC animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    selectedPhotos = [NSMutableArray arrayWithArray:photos];
    selectedAssets = [NSMutableArray arrayWithArray:assets];
    isSelectOriginalPhoto = isSelectOriginalPhoto;
    originalCVH = CGRectGetHeight(_imagesCView.frame);
    NSInteger imageNum = [selectedPhotos count];
    if(imageNum < 4)
    {
        _imagesCView.frame = imageCVFrame1;
    }
    else if(imageNum >= 4 && imageNum < 8)
    {
        _imagesCView.frame = imageCVFrame2;
    }
    else if(imageNum >= 8)
    {
        _imagesCView.frame = imageCVFrame3;
    }
    [self changeViewHeight];
    
    [_imagesCView reloadData];
    imagesLayout.itemCount = selectedPhotos.count;
}


#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [selectedPhotos removeObjectAtIndex:sender.tag];
    [selectedAssets removeObjectAtIndex:sender.tag];
    imagesLayout.itemCount = selectedPhotos.count;
    originalCVH = CGRectGetHeight(_imagesCView.frame);
    NSInteger imageNum = [selectedPhotos count];
    if(imageNum < 4)
    {
        _imagesCView.frame = imageCVFrame1;
    }
    else if(imageNum >= 4 && imageNum < 8)
    {
        _imagesCView.frame = imageCVFrame2;
    }
    else if(imageNum >= 8)
    {
        _imagesCView.frame = imageCVFrame3;
    }
    [self changeViewHeight];
    [_imagesCView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_imagesCView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_imagesCView reloadData];
    }];
    
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CreateTVC* cell;
    NSString* cellId;
    if(row == 0)
    {
        cellId = @"limit";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[CreateTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = @"发布给";
        cell.where = limitVC.which;
    }
    else if(row == 1)
    {
        cellId = @"start";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[CreateTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = @"开始时间";
        if(startStr != nil && startStr.length > 0)
        {
            cell.startL.text = startStr;
            cell.startL.enabled = YES;
        }
        else
        {
            cell.startL.text = @"开始时间";
            cell.startL.enabled = NO;
        }
        cell.startB = startB;
    }
    else if(row == 2)
    {
        cellId = @"end";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[CreateTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = @"结束时间";
        if(endStr != nil && endStr.length > 0)
        {
            cell.endL.text = endStr;
            cell.endL.enabled = YES;
        }
        else
        {
            cell.endL.text = @"结束时间";
            cell.endL.enabled = NO;
        }
        
        cell.endB = endB;
    }
    else if(row == 3)
    {
        cellId = @"address";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[CreateTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = @"活动地点";
        if(mapVC.address != nil && mapVC.address.length > 0)
        {
            cell.addressL.text = mapVC.address;
            cell.addressL.enabled = YES;
        }
        else
        {
            cell.addressL.text= @"详细地址";
        }
        cell.addressB = addressB;
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row == 0)
    {
        UIBarButtonItem* backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"选择可见范围" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItemTitle];
        limitVC.communityName = communityAddress;
        [self.navigationController pushViewController:limitVC animated:YES];
    }
    else if(row == 1)
    {
        [datePicker initNowDate];
        timeRow = 1;
        [self.parentViewController.view addSubview:backgroundView];
        [self.parentViewController.view addSubview:datePicker];
    }
    else if(row == 2)
    {
        [datePicker initNowDate];
        timeRow = 2;
        [self.parentViewController.view addSubview:backgroundView];
        [self.parentViewController.view addSubview:datePicker];
    }
    else if(row == 3)
    {
        UIBarButtonItem* backItemTitle = [[UIBarButtonItem alloc] initWithTitle:@"活动地点" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItemTitle];
        [self.navigationController pushViewController:mapVC animated:YES];
    }

 
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(textView == self.titleTV)
    {
        if(self.titleTV.autoresizingMask == UIViewAutoresizingNone)
        {
            self.titleTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            self.contentTV.autoresizingMask = UIViewAutoresizingNone;
        }
        
        if(textView.text.length > 0)
        {
            self.titlePlaceholder.text = @"";
            [emptyIV setHidden:YES];
        }
        else
        {
            self.titlePlaceholder.text = @"标题";
        }
        
        CGFloat toHeight = ceilf([textView sizeThatFits:textView.frame.size].height);
        if(textView.text.length > 64)
        {
            textView.text = [textView.text substringToIndex:64];
        }
        
        if(toHeight == titlePreHeight)
        {
            return;
        }
        
        if (toHeight < titleMinHeight) {
            toHeight = titleMinHeight;
        }
        
        if(toHeight >= 102)
        {
            toHeight = 102;
        }
        
        CGFloat changeHeight = toHeight - titlePreHeight;
        
        CGFloat textViewW = CGRectGetWidth(textView.frame);
        CGFloat textViewH = CGRectGetHeight(textView.frame);
        
        CGRect textViewFrame = textView.frame;
        textViewFrame.size = CGSizeMake(textViewW, toHeight);
        
        if(changeHeight > 0)
        {
            textViewFrame.size = CGSizeMake(textViewW, textViewH);
        }
        else
        {
            textViewFrame.size = CGSizeMake(textViewW, titlePreHeight + 3.6);
        }
        
        textView.frame= textViewFrame;
        titlePreHeight = toHeight;
        
        CGFloat backViewX = self.bgView.frame.origin.x;
        CGFloat backViewY = self.bgView.frame.origin.y;
        CGFloat backViewW = self.bgView.frame.size.width;
        CGFloat backViewH = self.bgView.frame.size.height + changeHeight;
        self.bgView.frame = CGRectMake(backViewX,backViewY, backViewW, backViewH);
        
        CGFloat line2X = line2.frame.origin.x;
        CGFloat line2Y = line2.frame.origin.y + changeHeight;
        CGFloat line2W = line2.frame.size.width;
        CGFloat line2H = line2.frame.size.height;
        line2.frame = CGRectMake(line2X, line2Y, line2W, line2H);
        
        CGFloat line3X = line3.frame.origin.x;
        CGFloat line3Y = line3.frame.origin.y + changeHeight;
        CGFloat line3W = line3.frame.size.width;
        CGFloat line3H = line3.frame.size.height;
        line3.frame = CGRectMake(line3X, line3Y, line3W, line3H);
        
        CGFloat line4X = line4.frame.origin.x;
        CGFloat line4Y = line4.frame.origin.y + changeHeight;
        CGFloat line4W = line4.frame.size.width;
        CGFloat line4H = line4.frame.size.height;
        line4.frame = CGRectMake(line4X, line4Y, line4W, line4H);
        
        CGFloat contentX = self.contentTV.frame.origin.x;
        CGFloat contentY = self.contentTV.frame.origin.y + changeHeight;
        CGFloat contentW = self.contentTV.frame.size.width;
        CGFloat contentH = self.contentTV.frame.size.height;
        self.contentTV.frame = CGRectMake(contentX, contentY, contentW, contentH);
        
        CGFloat tableViewX = self.tableView.frame.origin.x;
        CGFloat tableViewY = self.tableView.frame.origin.y + changeHeight;
        CGFloat tableViewW = self.tableView.frame.size.width;
        CGFloat tableViewH = self.tableView.frame.size.height;
        self.tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
        
        
        CGFloat imagesCVX = self.imagesCView.frame.origin.x;
        CGFloat imagesCVY = self.imagesCView.frame.origin.y + changeHeight;
        CGFloat imagesCVW = self.imagesCView.frame.size.width;
        CGFloat imagesCVH = self.imagesCView.frame.size.height;
        self.imagesCView.frame = CGRectMake(imagesCVX, imagesCVY, imagesCVW, imagesCVH);
        imageCVFrame1.origin.y = imagesCVY;
        imageCVFrame2.origin.y = imagesCVY;
        imageCVFrame3.origin.y = imagesCVY;
        
    }
    else if(textView == self.contentTV)
    {
        if(self.contentTV.autoresizingMask == UIViewAutoresizingNone)
        {
            self.contentTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            self.titleTV.autoresizingMask = UIViewAutoresizingNone;
        }
        
        if(textView.text.length > 0)
        {
            self.contentPlaceholder.text = @"";
        }
        else
        {
            self.contentPlaceholder.text = @"描述内容...";
        }
        
        CGFloat toHeight = ceilf([textView sizeThatFits:textView.frame.size].height);
        
        if(toHeight == contentPreHeight)
        {
            return;
        }
        
        if (toHeight < contentMinHeight) {
            toHeight = contentMinHeight;
        }
        
        
        CGFloat changeHeight = toHeight - contentPreHeight;
        
        CGFloat textViewW = CGRectGetWidth(textView.frame);
        CGFloat textViewH = CGRectGetHeight(textView.frame);
        
        CGRect textViewFrame = textView.frame;
        textViewFrame.size = CGSizeMake(textViewW, toHeight);
        
        if(changeHeight > 0)
        {
            textViewFrame.size = CGSizeMake(textViewW, textViewH);
        }
        else
        {
            textViewFrame.size = CGSizeMake(textViewW, contentPreHeight + 3.6);
        }
        
        textView.frame = textViewFrame;
        contentPreHeight = toHeight;
        
        CGFloat backViewX = self.bgView.frame.origin.x;
        CGFloat backViewY = self.bgView.frame.origin.y;
        CGFloat backViewW = self.bgView.frame.size.width;
        CGFloat backViewH = self.bgView.frame.size.height + changeHeight;
        self.bgView.frame = CGRectMake(backViewX,backViewY, backViewW, backViewH);
        
        CGFloat y = self.scrollView.contentOffset.y + changeHeight;
        if(y > 0)
        {
            self.scrollView.contentOffset = CGPointMake(0, y);
        }
        
        CGFloat tableViewX = self.tableView.frame.origin.x;
        CGFloat tableViewY = self.tableView.frame.origin.y + changeHeight;
        CGFloat tableViewW = self.tableView.frame.size.width;
        CGFloat tableViewH = self.tableView.frame.size.height;
        self.tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
        
        
        CGFloat line3X = line3.frame.origin.x;
        CGFloat line3Y = line3.frame.origin.y + changeHeight;
        CGFloat line3W = line3.frame.size.width;
        CGFloat line3H = line3.frame.size.height;
        line3.frame = CGRectMake(line3X, line3Y, line3W, line3H);
        
        CGFloat line4X = line4.frame.origin.x;
        CGFloat line4Y = line4.frame.origin.y + changeHeight;
        CGFloat line4W = line4.frame.size.width;
        CGFloat line4H = line4.frame.size.height;
        line4.frame = CGRectMake(line4X, line4Y, line4W, line4H);
        
        CGFloat imagesCVX = self.imagesCView.frame.origin.x;
        CGFloat imagesCVY = self.imagesCView.frame.origin.y + changeHeight;
        CGFloat imagesCVW = self.imagesCView.frame.size.width;
        CGFloat imagesCVH = self.imagesCView.frame.size.height;
        self.imagesCView.frame = CGRectMake(imagesCVX, imagesCVY, imagesCVW, imagesCVH);
        imageCVFrame1.origin.y = imagesCVY;
        imageCVFrame2.origin.y = imagesCVY;
        imageCVFrame3.origin.y = imagesCVY;
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.bgView.frame));
    
}



- (void) changeViewHeight
{
    self.contentTV.autoresizingMask = UIViewAutoresizingNone;
    self.titleTV.autoresizingMask = UIViewAutoresizingNone;
    
    CGFloat lastCVH = CGRectGetHeight(_imagesCView.frame);
    CGFloat changeHeight = lastCVH - originalCVH;
    if(changeHeight == 0)
    {
        return;
    }
    else
    {
        CGFloat backViewX = self.bgView.frame.origin.x;
        CGFloat backViewY = self.bgView.frame.origin.y;
        CGFloat backViewW = self.bgView.frame.size.width;
        CGFloat backViewH = self.bgView.frame.size.height + changeHeight;
        self.bgView.frame = CGRectMake(backViewX,backViewY, backViewW, backViewH);
        
        CGFloat line3X = line3.frame.origin.x;
        CGFloat line3Y = line3.frame.origin.y + changeHeight;
        CGFloat line3W = line3.frame.size.width;
        CGFloat line3H = line3.frame.size.height;
        line3.frame = CGRectMake(line3X, line3Y, line3W, line3H);
        
        CGFloat tableViewX = self.tableView.frame.origin.x;
        CGFloat tableViewY = self.tableView.frame.origin.y + changeHeight;
        CGFloat tableViewW = self.tableView.frame.size.width;
        CGFloat tableViewH = self.tableView.frame.size.height;
        self.tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
        
        CGFloat line4X = line4.frame.origin.x;
        CGFloat line4Y = line4.frame.origin.y + changeHeight;
        CGFloat line4W = line4.frame.size.width;
        CGFloat line4H = line4.frame.size.height;
        line4.frame = CGRectMake(line4X, line4Y, line4W, line4H);
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.bgView.frame));
    
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark NSNotificationCenter UIKeyboard

//当键出现时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardH, 0);
    NSLog(@"键盘高度是  %f",keyboardH);
    NSLog(@"键盘宽度是  %d",width);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendResult:(id)sender
{
    NSLog(@"发送");
    
    NSString* title = self.titleTV.text;
    NSString* content = self.contentTV.text;
    
    if(title.length == 0)
    {
        [emptyIV setHidden:NO];
        return;
    }
    
    if(content.length > 1000)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法发送" message:@"发送内容过长" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(startTime == 0)
    {
        startB = false;
        [self.tableView reloadData];
        return;
    }
    
    if(endTime == 0)
    {
        endB = false;
        [self.tableView reloadData];
        return;
    }
    
    if(endTime <= startTime)
    {
        [MBProgressHUBTool textToast:self.view Tip:@"结束时间小于或等于开始时间"];
        return;
    }
    
    if(!(mapVC.address != nil && mapVC.address.length > 0))
    {
        addressB = false;
        [self.tableView reloadData];
        return;
    }
    
    
    WaitView* waitView = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"正在发布..."];
    //    UIView* backgroundView = [[UIView alloc] initWithFrame:self.parentViewController.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:waitView];
    [self.parentViewController.view addSubview:backgroundView];
    
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    long topicTime = [date timeIntervalSince1970]*1000;
    NSString* displayName = [NSString stringWithFormat:@"%@@%@",nick,communityAddress];
    
    // 手机序列号
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    
    NSInteger forumId = limitVC.which;
    NSString* forumName;
    switch (forumId) {
        case 0:
            forumName = @"本小区";
            break;
        case 1:
            forumName = @"周边";
            break;
        case 2:
            forumName = @"同城";
            break;
        default:
            break;
    }

    
    // 发布新活动网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* topicContent = [NSString stringWithFormat:@"<font color='#323232'>开始时间：</font><font color='#808080'>%@<br></font><font color='#323232'>结束时间：</font><font color='#808080'>%@<br></font><font color='#323232'>地址：%@<br>内容：%@</font>",startStr1, endStr1,mapVC.address,content];
    NSString* topicTitle = [NSString stringWithFormat:@"#活动#%@",title];
    
    
    NSString* MD5String;
    if([selectedPhotos count] == 0)
    {
        MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"topic_title%@content%@forum_id%ldforum_name%@sender_id%@sender_name%@sender_portrait%@sender_family_id%@sender_family_address%@sender_city_id%ldsender_community_id%ldsend_status0display_name%@topic_time%ldtokenvalue%@",topicTitle, content, forumId,forumName,userId,nick,portrait,familyId,familyAddress,cityId,communityId,displayName,topicTime,identifierNumber]];
    }
    else
    {
        MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"topic_title%@content%@forum_id%ldforum_name%@sender_id%@sender_name%@sender_portrait%@sender_family_id%@sender_family_address%@sender_city_id%ldsender_community_id%ldsend_status1display_name%@topic_time%ldtokenvalue%@",topicTitle, content,forumId,forumName,userId,nick,portrait,familyId,familyAddress,cityId,communityId,displayName,topicTime,identifierNumber]];
    }
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    NSString* keySet = @"topic_title:content:forum_id:forum_name:sender_id:sender_name:sender_portrait:sender_family_id:sender_family_address:sender_city_id:sender_community_id:send_status:display_name:topic_time:tokenvalue:";
    NSMutableDictionary* parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      topicTitle, @"topic_title",
                                      topicContent, @"topic_content",
                                      content, @"content",
                                      @"2",  @"topic_category_type",
                                      [NSNumber numberWithInteger:forumId], @"forum_id",
                                      forumName, @"forum_name" ,
                                      userId, @"sender_id",
                                      nick, @"sender_name",
                                      portrait, @"sender_portrait",
                                      @"0", @"sender_nc_role",
                                      familyId, @"sender_family_id",
                                      familyAddress, @"sender_family_address",
                                      @"1", @"object_data_id",
                                      @"1", @"circle_type",
                                      identifierNumber, @"tokenvalue",
                                      [NSNumber numberWithLong:cityId], @"sender_city_id",
                                      [NSNumber numberWithLong:communityId], @"sender_community_id",
                                      [NSNumber numberWithLong:topicTime], @"topic_time",
                                      displayName, @"display_name",
                                      [NSNumber numberWithLong:startTime],@"startTime",
                                      [NSNumber numberWithLong:endTime],@"endTime",
                                      mapVC.address, @"location",
                                      @"0", @"send_status",
                                      @"0", @"sender_lever",
                                      @"comm", @"apitype",
                                      @"addtopic", @"tag",
                                      @"1", @"salt",
                                      hashString, @"hash",
                                      keySet,@"keyset",
                                      nil];
    NSLog(@"parameter = %@",parameter);
    NSMutableArray* imagesName = [[NSMutableArray alloc] init];
    if([selectedPhotos count] != 0)
    {
        parameter[@"send_status"] = @"1";
        for(int i = 0; i < [selectedPhotos count]; i++)
        {
            // 设置时间格式
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [imagesName addObject:fileName];
            NSString* key = [NSString stringWithFormat:@"img_%d",i];
            parameter[key] = fileName;
        }
        
    }
    
    
    [manager POST:POST_URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if([selectedPhotos count] != 0)
        {
            for(int i = 0; i < [selectedPhotos count]; i++)
            {
                UIImage* image = selectedPhotos[i];
                NSData *data = UIImageJPEGRepresentation(image,0.1);
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"img_%d",i] fileName:imagesName[i] mimeType:@"image/jpg"];
                
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@" 发布新活动网络请求请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            NSLog(@"发布新活动网络请求成功");
            [ChatDemoHelper shareHelper].neighborVC.refresh = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if([flag isEqualToString:@"full"])
        {
            NSString* msg = [responseObject valueForKey:@"yl_msg"];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"发送" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [waitView removeFromSuperview];
        [backgroundView removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *aString = [[NSString alloc] initWithData:error encoding:NSUTF8StringEncoding];
        
        NSLog(@"上传失败 %@", aString);

        [waitView removeFromSuperview];
        [backgroundView removeFromSuperview];
    }];

}

// 数据库取数据
- (void) searchSql
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    userId = [defaults stringForKey:@"userId"];
    familyId = [defaults stringForKey:@"familyId"];
    portrait = [defaults stringForKey:@"portrait"];
    nick = [defaults stringForKey:@"nick"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = delegate.db;
    
    if([db open])
    {
        NSLog(@"CreateTopicVC table_all_family: db open success!");
        FMResultSet *result = [db executeQuery:@"SELECT family_address, family_city_id ,family_community_id,family_community_nickname FROM table_all_family WHERE family_id = ?",familyId];
        while ([result next]) {
            familyAddress = [result stringForColumn:@"family_address"];
            communityAddress = [result stringForColumn:@"family_community_nickname"];
            cityId = [result longForColumn:@"family_city_id"];
            communityId = [result longForColumn:@"family_community_id"];
        }
        [db close];
        
    }
    else
    {
        NSLog(@"CreateTopicVC table_all_family: db open error!");
    }
    
}

- (void) createBackItemBtn
{
    CGSize size = [StringMD5 sizeWithString:@"活动" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UIControl* view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 25 + size.width, self.navigationController.navigationBar.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    _backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.frame.size.height / 4, 20, view.frame.size.height / 2)];
    _backIV.image = [UIImage imageNamed:@"mm_title_back.png"];
    _backLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backIV.frame) + 5, 0, size.width, view.frame.size.height)];
    
    _backLabel.text = @"活动";
    _backLabel.textColor = [UIColor whiteColor];
    [view addSubview:_backIV];
    [view addSubview:_backLabel];
    
    [view addTarget:self action:@selector(changeAlpha) forControlEvents:UIControlEventTouchDown];
    [view addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void) backAction
{
    _backLabel.alpha = 1.0;
    _backIV.alpha = 1.0;
    
    DialogView* deleteView = [[DialogView alloc] initWithFrame:backgroundView.frame  View:backgroundView Flag:@"common"];
    [rootVC.view  addSubview:backgroundView];
    [rootVC.view  addSubview:deleteView];
    
    deleteView.titleL.text = @"确定要放弃此次编辑吗？";
    dialogView = deleteView;
    UIButton* okBtn = deleteView.OKbtn;
    [okBtn addTarget:self action:@selector(OkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* noBtn = deleteView.NOBtn;
    [noBtn addTarget:self action:@selector(NoAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)OkAction:(id) sender
{
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)NoAction:(id) sender
{
    [backgroundView removeFromSuperview];
    if(dialogView)
    {
        [dialogView removeFromSuperview];
        dialogView = nil;
    }
    return;
}

- (void) changeAlpha
{
    _backLabel.alpha = 0.2;
    _backIV.alpha = 0.2;
}

#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    NSString *dateStr = [NSString stringWithFormat:@"%@年%@月%@日%@时%@分",
                         datePickerDate.year,
                         datePickerDate.month,
                         datePickerDate.day,
                         datePickerDate.hour,
                         datePickerDate.minute
                         ];
    NSString *dateStr1 = [NSString stringWithFormat:@"%@-%@-%@- %@:%@",
                         datePickerDate.year,
                         datePickerDate.month,
                         datePickerDate.day,
                         datePickerDate.hour,
                         datePickerDate.minute
                         ];

    switch (timeRow) {
        case 1:
        {
            timeRow = 0;
            startStr = dateStr;
            startStr1 = dateStr1;
            startTime = [self convertDateFromString:dateStr];
            startB = true;
            break;
        }
        case 2:
        {
            timeRow = 0;
            endStr = dateStr;
            endStr1 = dateStr1;
            endTime = [self convertDateFromString:dateStr];
            endB = true;
            break;
        }
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void)cancelDidSelectDate
{
    [datePicker removeFromSuperview];
    [backgroundView removeFromSuperview];
}

#pragma mark - Private
- (long) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [formatter dateFromString:uiDate];
    long time = [date timeIntervalSince1970] * 1000;
    return time;
}

@end
