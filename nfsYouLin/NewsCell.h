//
//  NewsCell.h
//  nfsYouLin
//
//  Created by Macx on 16/9/12.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property(strong ,nonatomic)NSDictionary* newsInfo;

@property(strong ,nonatomic)NSDictionary* titleNew;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
