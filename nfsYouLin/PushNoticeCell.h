//
//  PushNoticeCell.h
//  nfsYouLin
//
//  Created by Macx on 2016/10/20.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushNoticeCell : UITableViewCell

@property(strong, nonatomic) NSDictionary* noticeDict;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
