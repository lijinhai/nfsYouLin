//
//  NCellDelegate.h
//  nfsYouLin
//
//  Created by Macx on 16/6/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#ifndef NCellDelegate_h
#define NCellDelegate_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol cellDelegate <NSObject>

- (void)showCircularImageViewWithImage:(UIImage*) image;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;
- (void)readTotalInformation:(NSInteger)sectionNum;

@end


#endif /* NCellDelegate_h */
