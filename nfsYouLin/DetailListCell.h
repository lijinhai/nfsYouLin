//
//  DetailListCell.h
//  nfsYouLin
//
//  Created by Macx on 16/9/2.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailListCell : UITableViewCell

@property(nonatomic, strong)NSString* action;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
