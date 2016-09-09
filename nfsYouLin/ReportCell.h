//
//  ReportCell.h
//  nfsYouLin
//
//  Created by Macx on 16/9/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell

@property(strong, nonatomic) UIImageView* selectedIV;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
