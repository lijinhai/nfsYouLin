//
//  WeatherCell.h
//  nfsYouLin
//
//  Created by Macx on 16/9/26.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCell : UITableViewCell

@property(strong, nonatomic)NSDictionary* weatherInfo;

@property(strong, nonatomic)NSString* title;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
