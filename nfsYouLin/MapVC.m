//
//  MapVC.m
//  nfsYouLin
//
//  Created by Macx on 16/8/29.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "MapVC.h"

@interface MapVC ()

@end

@implementation MapVC
{
    BMKMapView* _mapView;
    BMKLocationService* locationService;
    BMKGeoCodeSearch* geoCodeSearch;
    BMKPointAnnotation* point;
    BOOL location;

    NSMutableArray* firstAddressA;
    UILabel* textLabel;

    UITableView* _tableView;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishSelected)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    location = YES;
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    //显示定位图层
    _mapView.showsUserLocation = YES;
    _mapView.zoomEnabled = YES;
    _mapView.scrollEnabled = YES;
    //比例尺
    _mapView.showMapScaleBar = YES;
    //设置定位图层自定义样式
    BMKLocationViewDisplayParam *userlocationStyle = [[BMKLocationViewDisplayParam alloc] init];
    //精度圈是否显示
    userlocationStyle.isRotateAngleValid = YES;
    //跟随态旋转角度是否生效
    userlocationStyle.isAccuracyCircleShow = YES;
    //定位图标 更换蓝点
    userlocationStyle.locationViewImgName = @"title_icon_pin.png";
    //定位偏移量(经度)
    userlocationStyle.locationViewOffsetX = 0;
    //定位偏移量（纬度）
    userlocationStyle.locationViewOffsetY = 0;
    //更新参样式信息
    [_mapView updateLocationViewWithParam:userlocationStyle];
    
    //初始化BMKLocationService
    locationService = [[BMKLocationService alloc]init];
    locationService.delegate = self;
    
    //启动LocationService
    [locationService startUserLocationService];
    
    geoCodeSearch =[[BMKGeoCodeSearch alloc]init];
    geoCodeSearch.delegate = self;
    
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAddress:)];
    
    [_mapView addGestureRecognizer:gesture];
    point = [[BMKPointAnnotation alloc] init];
    [_mapView addAnnotation:point];
    [self.view addSubview:_mapView];

    CGFloat navH = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusH = CGRectGetHeight( [[UIApplication sharedApplication] statusBarFrame]);
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, navH + statusH, CGRectGetWidth(self.view.frame), 60)];
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.delegate = self;
    self.textView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    self.textView.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:self.textView];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.view.frame), 36)];
    textLabel.enabled = NO;
    [self.textView addSubview:textLabel];

    firstAddressA = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] init];
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -BMKLocationServiceDelegate 定位
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    if(location)
    {
        [_mapView updateLocationData:userLocation];
        BMKCoordinateRegion region;
        region.center.latitude  = userLocation.location.coordinate.latitude;
        region.center.longitude = userLocation.location.coordinate.longitude;
        region.span.latitudeDelta  = 0.01;
        region.span.longitudeDelta = 0.01;
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = userLocation.location.coordinate;
        [_mapView addAnnotation:annotation];
        _mapView.region = region;
        location = NO;
        
        //发起反向地理编码检索
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                                BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        
    }
}

#pragma mark -BMKGeoCodeSearchDelegate 地理位置编码
//反向地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    [firstAddressA removeAllObjects];
    NSLog(@"count = %ld",[result.poiList count]);
    
    if([result.poiList count] == 0)
    {
        textLabel.text = @"请填写详细地址, 以便邻居参加活动。";
    }
    else
    {
        textLabel.text = @"";
    }
    
    for(BMKPoiInfo *poiInfo in result.poiList)
    {
        NSLog(@"%@-%@",poiInfo.name,poiInfo.city);
        [firstAddressA addObject:poiInfo];
    }
    
    BMKPoiInfo *poiInfo = [firstAddressA firstObject];
    self.textView.text = poiInfo.address;
    [_tableView reloadData];
    _tableView.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame), CGRectGetWidth(self.view.frame) / 2, 50 * [firstAddressA count]);
    [self.view addSubview:_tableView];
    
    
}


#pragma mark -BMKMapViewDelegate 
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    static NSString* firstId = @"first";
    static NSString* otherId = @"other";
    BMKAnnotationView* annoView = nil;
    if(annotation == point)
    {
        annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:otherId];
        if(!annoView)
        {
            annoView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:otherId];
        }
        
        annoView.image = [UIImage imageNamed:@"icon_marka.png"];
    }
    else
    {
        annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:firstId];
        if(!annoView)
        {
            annoView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:firstId];
            
        }
        
        annoView.image = [UIImage imageNamed:@"title_icon_pin.png"];
    }
    
    return annoView;
}


#pragma mark - TextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
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
    if(textView.text.length > 0)
    {
        textLabel.text = @"";
    }
    else
    {
        textLabel.text = @"请填写详细地址, 以便邻居参加活动。";
    }
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [firstAddressA count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    BMKPoiInfo *poiInfo = firstAddressA[indexPath.row];

    cell.textLabel.text = poiInfo.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *poiInfo = firstAddressA[indexPath.row];
    self.textView.text = [NSString stringWithFormat:@"%@(%@)",poiInfo.name,poiInfo.address];
}

#pragma mark -Selector
- (void) addAddress:(UITapGestureRecognizer *)gesture
{
    CGPoint pos = [gesture locationInView:_mapView];
    CLLocationCoordinate2D coord = [_mapView convertPoint:pos toCoordinateFromView:_mapView];
    point.coordinate = coord;
    //发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coord;
    BOOL flag = [geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)finishSelected
{
    self.address = self.textView.text;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
