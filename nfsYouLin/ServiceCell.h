//
//  ServiceCell.h
//  nfsYouLin
//
//  Created by Macx on 16/9/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceView.h"

@protocol ServiceCellDelegate <ServiceDelegate>

- (void) selectedAddressCell:(NSString *) text;
- (void) selectedLongAddressCell:(NSString*) text;

- (void) selectedTimeCell: (NSString*) text;
- (void) selectecLongTimeCell: (NSString*) text;

- (void) selectedPhoneCell : (NSString*) text;

@end

@interface ServiceCell : UITableViewCell <ServiceDelegate>

@property(strong, nonatomic)id <ServiceCellDelegate> s_delegate;

@property(strong, nonatomic)ServiceView* serviceView;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
