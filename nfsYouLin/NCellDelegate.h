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
- (void)showRectImageViewWithImage:(UIImage*) image;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;
// 查看全文
- (void)readTotalInformation:(NSInteger)sectionNum;

// 点击新闻
- (void) readNewsDetail:(NSDictionary*)newsInfo;

// 帖子类别切换
- (void)reloadShowByTitle: (NSString* )text;

// 打招呼
- (void)sayHi:(NSInteger)topicId;


// 删除按钮事件
- (void)deleteTopic:(NSInteger)topicId;

// 我要报名
- (void)applyDetail:(NSInteger) activityId;

// 取消报名
- (void) cancelApply:(NSInteger) activityId;

// 查看报名详情
- (void) lookApplyDetail:(NSInteger) activityId;

// 添加回复、删除回复
- (void) replyEvent:(NSInteger) sctionNum btnText:(NSString*) btnText;

// 获取个人详细信息
- (void) peopleInfoViewController:(NSInteger)peopleId icon:(NSString*)icon name:(NSString*)name;
@end


#endif /* NCellDelegate_h */
