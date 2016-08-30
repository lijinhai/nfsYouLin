//
//  MapVC.h
//  nfsYouLin
//
//  Created by Macx on 16/8/29.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface MapVC : UIViewController <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,UITextViewDelegate, UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UITextView* textView;
@property(strong, nonatomic)NSString* address;

- (id)init;

@end
