//
//  DownListCell.h
//  nfsYouLin
//
//  Created by jinhai on 16/9/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownListCell : UITableViewCell
@property(nonatomic, strong)NSString* action;
@property(nonatomic, strong)NSString* defaultV;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
