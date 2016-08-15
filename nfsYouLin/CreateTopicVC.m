//
//  CreateTopicVC.m
//  nfsYouLin
//
//  Created by Macx on 16/8/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "CreateTopicVC.h"
#import "LxGridViewFlowLayout.h"
#import "PickerCVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "PublicLimitTVC.h"


@interface CreateTopicVC ()

@end

@implementation CreateTopicVC
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
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendResult:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIColor* lineColor = [UIColor colorWithRed:217.0 / 255.0 green:216.0 / 255.0 blue:213.0 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 80)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1];
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.scrollView.delegate = self;
    self.bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300)];
    self.bgView.bounces = NO;
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), 1)];
    line1.backgroundColor = lineColor;
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake(40, 40, CGRectGetWidth(self.bgView.frame) - 80, 1)];
    line2.backgroundColor = lineColor;
    
    line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bgView.frame) - 60, CGRectGetWidth(self.bgView.frame), 1)];
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line3.frame), CGRectGetWidth(self.bgView.frame), 58) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor orangeColor];
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
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
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            selectedPhotos = [NSMutableArray arrayWithArray:photos];
            selectedAssets = [NSMutableArray arrayWithArray:assets];
            isSelectOriginalPhoto = isSelectOriginalPhoto;
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = @"cellId";
    PublicLimitTVC* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[PublicLimitTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"发布范围";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
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
}



@end
