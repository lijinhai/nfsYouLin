//
//  ServiceCell.h
//  nfsYouLin
//
//  Created by Macx on 16/9/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceView.h"

@protocol ServiceCellDelegate <NSObject, ServiceDelegate>

@end

@interface ServiceCell : UITableViewCell

@property(strong, nonatomic)ServiceView* serviceView;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
