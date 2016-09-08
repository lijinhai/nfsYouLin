//
//  InviteRecordCell.h
//  nfsYouLin
//
//  Created by Macx on 16/9/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteRecordCell : UITableViewCell

@property(strong, nonatomic)NSDictionary* infoDict;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
