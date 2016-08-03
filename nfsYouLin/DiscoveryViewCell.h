//
//  DiscoveryViewCell.h
//  nfsYouLin
//
//  Created by Macx on 16/8/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoveryViewCell : UITableViewCell

@property(strong ,nonatomic)UIImageView* circle;

- (void) setMessage: (BOOL)isMessage;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
