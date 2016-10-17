//
//  CreateNoticeVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/28.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "CreateNoticeVC.h"
#import "LxGridViewFlowLayout.h"
#import "DialogView.h"
#import "PickerCVC.h"
#import "TZImageManager.h"
#import "HeaderFile.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "ChatDemoHelper.h"
#import "WaitView.h"
#import "AppDelegate.h"
#import "ErrorVC.h"
#import "NoticeView.h"
#import "NoticeBGView.h"

@interface CreateNoticeVC () <NoticeViewDelegate>

@end

@implementation CreateNoticeVC
{
    CGFloat titlePreHeight;
    CGFloat titleMinHeight;
    
    CGFloat contentPreHeight;
    CGFloat contentMinHeight;
    CGFloat contentMaxHeight;
    
    UIView* line;
    
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
    
    
    UIImageView* emptyIV;
    UIImageView* emptyIV1;
    
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
    DialogView* dialogView;
    UIViewController* rootVC;
    
    NoticeView* noticeView;
    NoticeBGView* noticeBGView;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        
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
    
    
    [self searchSql];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendResult)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIColor* lineColor = [UIColor colorWithRed:217.0 / 255.0 green:216.0 / 255.0 blue:213.0 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    
    self.scrollView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 250)];
    self.bgView.bounces = NO;
    self.bgView.backgroundColor = [UIColor whiteColor];
    

    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.bgView.frame));
    
    line = [[UIView alloc] initWithFrame:CGRectMake(40, 40, CGRectGetWidth(self.bgView.frame) - 80, 1)];
    line.backgroundColor = lineColor;
    [self.bgView addSubview:line];
    
    
    self.titleTV = [[UITextView alloc] initWithFrame:CGRectMake(20, 1, CGRectGetWidth(self.bgView.frame) - 40, 38)];
    self.titleTV.backgroundColor = [UIColor whiteColor];
    self.titleTV.scrollEnabled = NO;
    self.titleTV.editable = NO;
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
    
    UIControl* titleV = [[UIControl alloc] initWithFrame:CGRectMake(20, 1, screenWidth, 38)];
    [titleV addTarget:self action:@selector(titleClicked) forControlEvents:UIControlEventTouchUpInside];
    titleV.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:titleV];
    
    emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame) - 10, 10, 20, 20)];
    emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
    emptyIV.layer.masksToBounds = YES;
    emptyIV.layer.cornerRadius = 10;
    emptyIV.hidden = YES;
    [self.bgView addSubview:emptyIV];
    
    self.contentTV = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame), CGRectGetWidth(self.bgView.frame) - 40, 38)];
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
    
    emptyIV1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame) - 10, CGRectGetMaxY(line.frame) + 5, 20, 20)];
    emptyIV1.image = [UIImage imageNamed:@"tanhao.png"];
    emptyIV1.layer.masksToBounds = YES;
    emptyIV1.layer.cornerRadius = 10;
    emptyIV1.hidden = YES;
    [self.bgView addSubview:emptyIV1];

    selectedPhotos = [NSMutableArray array];
    selectedAssets = [NSMutableArray array];
    imageMargin = 4;
    imageWH = (self.view.frame.size.width - 5 * imageMargin - 32) / 5;
    imagesLayout = [[LxGridViewFlowLayout alloc] init];
    imagesLayout.itemSize = CGSizeMake(imageWH, imageWH);
    imagesLayout.minimumLineSpacing = imageMargin;
    imagesLayout.minimumLineSpacing = imageMargin;
    CGFloat frameY = CGRectGetHeight(self.bgView.frame) - 40 - imageWH;
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
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    rootVC = window.rootViewController.navigationController;
    backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    backgroundView.alpha = 0.8;
    dialogView = nil;
    
    noticeView = [[NoticeView alloc] initWithFrame:CGRectMake(screenWidth, screenHeight * 0.5 + 50, screenWidth - 40, 100)];
    noticeView.delegate = self;
    noticeBGView = [[NoticeBGView alloc] initWithFrame:rootVC.view.bounds subView:noticeView];
    [self initTopicData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createBackItemBtn];
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
        NSLog(@"table_all_family: db open success!");
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
        NSLog(@"table_all_family: db open error!");
    }
    
}



- (void) initTopicData
{
    if([[self.topicInfo valueForKey:@"option"] isEqualToString:@"update"])
    {
        self.titleTV.text = [self.topicInfo valueForKey:@"title"];
        [self textViewDidChange:self.titleTV];
        self.contentTV.text = [self.topicInfo valueForKey:@"content"];
        [self textViewDidChange:self.contentTV];
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }
    
}


#pragma mark -setter
- (void)setTopicInfo:(NSMutableDictionary *)topicInfo
{
    _topicInfo = topicInfo;
}

- (void) createBackItemBtn
{
    CGSize size = [StringMD5 sizeWithString:@"物业公告" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UIControl* view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 25 + size.width, self.navigationController.navigationBar.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    _backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.frame.size.height / 4, 20, view.frame.size.height / 2)];
    _backIV.image = [UIImage imageNamed:@"mm_title_back.png"];
    _backLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backIV.frame) + 5, 0, size.width, view.frame.size.height)];
    
    _backLabel.text = @"物业公告";
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


#pragma mark -UICollectionView

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

#pragma mark -NSNotificationCenter UIKeyboard

//当键出现时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardH, 0);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

#pragma mark -标题点击事件
- (void) titleClicked
{
    noticeBGView.alpha = 0.1;
    [rootVC.view  addSubview:noticeBGView];
    [rootVC.view addSubview:noticeView];
    
    [UIView transitionWithView:noticeView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        noticeView.frame = CGRectMake(20, screenHeight * 0.5 - 50, screenWidth - 40, 100);
    } completion:^(BOOL finished) {
        noticeBGView.alpha = 0.5;
    }];
    
}

#pragma mark -NoticeViewDelegate

- (void) seletedNotice:(NSInteger)tag
{
    
    self.titlePlaceholder.text = @"";
    [emptyIV setHidden:YES];
    [UIView transitionWithView:noticeView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        noticeView.frame =CGRectMake(screenWidth, screenHeight * 0.5 + 50, screenWidth - 40, 100);
    } completion:^(BOOL finished) {
        [noticeBGView removeFromSuperview];
        [noticeView removeFromSuperview];
        
    }];
    
    switch (tag) {
        case 0:
            self.titleTV.text = @"停水通知";
            break;
        case 1:
            self.titleTV.text = @"活动通知";
            break;
        case 2:
            self.titleTV.text = @"缴费通知";
            break;
        case 3:
            self.titleTV.text = @"其他";
            break;
            
            
        default:
            break;
    }

}

#pragma mark -发送
- (void)sendResult
{
    NSString* title;
//    NSString* title = @"#物业公告#停水通知";
    NSString* content = self.contentTV.text;
    
    if(self.titleTV.text.length == 0)
    {
        [emptyIV setHidden:NO];
        return;
    }
    else
    {
        title = [NSString stringWithFormat:@"#物业公告#%@",self.titleTV.text];
    }
    
    if(content.length == 0)
    {
        [emptyIV1 setHidden:NO];
        return;
    }
    
    if(content.length > 1000)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法发送" message:@"发送内容过长" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    WaitView* waitView = [[WaitView alloc] initWithFrame:self.parentViewController.view.frame Title:@"正在发布..."];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:waitView];
    [self.parentViewController.view addSubview:backgroundView];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    long topicTime = [date timeIntervalSince1970]*1000;
    NSString* displayName = [NSString stringWithFormat:@"%@@%@",nick,communityAddress];
    
    // 手机序列号
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    
    // 发布新话题网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSString* MD5String;
    if([selectedPhotos count] == 0)
    {
        MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"topic_title%@topic_content%@sender_id%@sender_name%@sender_portrait%@sender_family_id%@sender_family_address%@sender_city_id%ldsender_community_id%ldsend_status0display_name%@topic_time%ldtokenvalue%@",title, content, userId,nick,portrait,familyId,familyAddress,cityId,communityId,displayName,topicTime,identifierNumber]];
    }
    else
    {
        MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"topic_title%@topic_content%@sender_id%@sender_name%@sender_portrait%@sender_family_id%@sender_family_address%@sender_city_id%ldsender_community_id%ldsend_status1display_name%@topic_time%ldtokenvalue%@",title, content,userId,nick,portrait,familyId,familyAddress,cityId,communityId,displayName,topicTime,identifierNumber]];
    }
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    NSString* keySet = @"topic_title:topic_content:sender_id:sender_name:sender_portrait:sender_family_id:sender_family_address:sender_city_id:sender_community_id:send_status:display_name:topic_time:tokenvalue:";
    NSMutableDictionary* parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      title, @"topic_title",
                                      content, @"topic_content",
                                      @"3",  @"topic_category_type",
                                      @"0", @"forum_id",
                                      @"本小区", @"forum_name" ,
                                      userId, @"sender_id",
                                      nick, @"sender_name",
                                      portrait, @"sender_portrait",
                                      @"0", @"sender_nc_role",
                                      familyId, @"sender_family_id",
                                      familyAddress, @"sender_family_address",
                                      @"0", @"object_data_id",
                                      @"1", @"circle_type",
                                      identifierNumber, @"tokenvalue",
                                      [NSNumber numberWithLong:cityId], @"sender_city_id",
                                      [NSNumber numberWithLong:communityId], @"sender_community_id",
                                      [NSNumber numberWithLong:topicTime], @"topic_time",
                                      displayName, @"display_name",
                                      @"0", @"send_status",
                                      @"0", @"sender_lever",
                                      @"apiproperty", @"apitype",
                                      @"setnotice", @"tag",
                                      @"1", @"salt",
                                      hashString, @"hash",
                                      keySet,@"keyset",
                                      nil];
    
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
    
    if([[self.topicInfo valueForKey:@"option"] isEqualToString:@"update"])
    {
        parameter[@"tag"] = @"updatetopic";
        parameter[@"topic_id"] = [self.topicInfo valueForKey:@"topicId"];
    }
    
    NSLog(@"patameter = %@", parameter);
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
        NSLog(@"发布物业公告请求:%@", responseObject);
        NSString* flag = [responseObject valueForKey:@"flag"];
        if([flag isEqualToString:@"ok"])
        {
            if([[self.topicInfo valueForKey:@"option"] isEqualToString:@"update"])
            {
                [self getSingleTopicNet];
            }
            else
            {
                [ChatDemoHelper shareHelper].neighborVC.refresh = YES;
                [self.navigationController popViewControllerAnimated:YES];
            }
            
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
        NSLog(@"上传失败 %@", error);
        [waitView removeFromSuperview];
        [backgroundView removeFromSuperview];
        NSData* data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        ErrorVC* errorVC = [[ErrorVC alloc] init];
        errorVC.error = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.navigationController pushViewController:errorVC animated:YES];
    }];
}

#pragma mark -Network
// 获取单条帖子
- (void) getSingleTopicNet
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSString* topicId = [self.topicInfo valueForKey:@"topicId"];
    
    NSString* MD5String = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_id%@community_id%ldtopic_id%@",userId,communityId,topicId]];
    NSString* hashString = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@1", MD5String]];
    
    NSDictionary* parameter = @{@"user_id" : userId,
                                @"community_id" : [NSNumber numberWithInteger:communityId],
                                @"topic_id" : topicId,
                                @"count" : @"1",
                                @"apitype" : @"comm",
                                @"tag" : @"gettopic",
                                @"salt" : @"1",
                                @"hash" : hashString,
                                @"keyset" : @"user_id:community_id:topic_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取单条帖子网络请求:%@", responseObject);
        if([responseObject isKindOfClass:[NSArray class]])
        {
            NSDictionary* dict = [self getResponseDictionary:responseObject[0]];
            NeighborDataFrame* dateFrame = [self.topicInfo valueForKey:@"dataFrame"];
            dateFrame.neighborData = [dateFrame.neighborData setWithDict:dict];
        }
        NSInteger index = [[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
        return;
    }];
    
}

- (NSDictionary*) getResponseDictionary: (NSDictionary *) responseDict
{
    NSDictionary* dict;
    dict = @{
             @"iconName" : responseDict[@"senderPortrait"],
             @"titleName" : responseDict[@"topicTitle"],
             @"accountName" : responseDict[@"displayName"],
             @"senderName" : responseDict[@"senderName"],
             @"publishText" : responseDict[@"topicContent"],
             @"picturesArray" : responseDict[@"mediaFile"],
             @"topicTime" : responseDict[@"topicTime"],
             @"systemTime" : responseDict[@"systemTime"],
             @"senderId" : responseDict[@"senderId"],
             @"cacheKey" : responseDict[@"cacheKey"],
             @"topicCategory" : responseDict[@"objectType"],
             @"infoArray" : responseDict[@"objectData"],
             @"praiseType" : responseDict[@"praiseType"],
             @"viewCount" : responseDict[@"viewNum"],
             @"praiseCount" : responseDict[@"likeNum"],
             @"replyCount" : responseDict[@"commentNum"],
             @"topicId" : responseDict[@"topicId"],
             @"collectStatus" : responseDict[@"collectStatus"],
             @"forumName" : responseDict[@"forumName"],
             @"objectType" : responseDict[@"objectType"],
             @"objectData" : responseDict[@"objectData"],
             };
    return dict;
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
        
        CGFloat lineX = line.frame.origin.x;
        CGFloat lineY = line.frame.origin.y + changeHeight;
        CGFloat lineW = line.frame.size.width;
        CGFloat lineH = line.frame.size.height;
        line.frame = CGRectMake(lineX, lineY, lineW, lineH);
        
        CGFloat contentX = self.contentTV.frame.origin.x;
        CGFloat contentY = self.contentTV.frame.origin.y + changeHeight;
        CGFloat contentW = self.contentTV.frame.size.width;
        CGFloat contentH = self.contentTV.frame.size.height;
        self.contentTV.frame = CGRectMake(contentX, contentY, contentW, contentH);
        
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
            [emptyIV1 setHidden:YES];
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
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.bgView.frame));
    
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
