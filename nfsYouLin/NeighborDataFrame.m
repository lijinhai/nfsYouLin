//
//  NeighborDataFrame.m
//  Neighbor2
//
//  Created by Macx on 16/5/30.
//  Copyright © 2016年 Macx. All rights reserved.
//



#import "NeighborDataFrame.h"
#import "StringMD5.h"

@implementation NeighborDataFrame


- (void) setNeighborData: (NeighborData *)neighborData
{
    _neighborData = neighborData;
    
    if(self.picturesFrame)
    {
        [self.picturesFrame removeAllObjects];
    }
    // 头像位置大小
    CGFloat iconViewX = PADDING;
    CGFloat iconViewY = PADDING;
    CGFloat iconViewW = 60;
    CGFloat iconViewH = 60;
    self.iconFrame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    
    
    // 时间间隔位置大小
    
    NSString* internalString = [StringMD5 calculateTimeInternal:[self.neighborData.systemTime integerValue] / 1000 old:[self.neighborData.topicTime integerValue] / 1000];
    CGSize internalSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@",internalString] font:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat internalX = screenWidth - internalSize.width - PADDING;
    CGFloat internalY = PADDING;
    self.intervalFrame = CGRectMake(internalX, internalY, internalSize.width , internalSize.height);
    
    // 打招呼按钮位置
    
     CGSize hiSize = [StringMD5 sizeWithString:@"打招呼" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat hiX = screenWidth - hiSize.width - 2 * PADDING;
    CGFloat hiY = CGRectGetMaxY(self.intervalFrame) + PADDING / 2;
    self.hiFrame = CGRectMake(hiX, hiY, hiSize.width + PADDING, hiSize.height+ PADDING / 2);
    
    // 帖子标题位置大小
    CGFloat titleLabelX = CGRectGetMaxX(self.iconFrame) + PADDING;
    CGSize titleLabelSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@",self.neighborData.titleName] font:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(screenWidth - hiSize.width - iconViewW - 4 * PADDING - PADDING / 2,MAXFLOAT)];
    CGFloat titleLabelY = iconViewY + PADDING / 2;
    CGFloat titleLabelW = titleLabelSize.width;
    CGFloat titleLabelH = titleLabelSize.height;
    self.titleFrame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    // 用户信息位置大小
    CGFloat accountInfoLabelX = CGRectGetMaxX(self.iconFrame) + PADDING;
    CGFloat accountInfoLabelY = CGRectGetMaxY(self.titleFrame);
//    CGSize accountInfoLabelSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@@%@",self.neighborData.accountName, self.neighborData.addressInfo] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGSize accountInfoLabelSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@",self.neighborData.accountName] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat accountInfoLabelW = accountInfoLabelSize.width;
    CGFloat accountInfoLabelH = accountInfoLabelSize.height;
    self.accountInfoFrame = CGRectMake(accountInfoLabelX, accountInfoLabelY, accountInfoLabelW, accountInfoLabelH);
    // 帖子内容位置大小
//    UIFont *font = [UIFont systemFontOfSize:16];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGFloat textLabelX = PADDING;
    CGFloat accountInfoMaxY = CGRectGetMaxY(self.accountInfoFrame);
    CGFloat iconMaxY = CGRectGetMaxY(self.iconFrame);
    CGFloat textLabelY = (accountInfoMaxY > iconMaxY ? accountInfoMaxY : iconMaxY) + PADDING;
    CGSize textLabelSize = [StringMD5 sizeWithString:self.neighborData.publishText font:font maxSize:CGSizeMake(screenWidth - 2 * PADDING, MAXFLOAT)];
   
    CGFloat textLabelW = textLabelSize.width;
    CGFloat textLabelH;
    self.textCount = textLabelSize.height / font.lineHeight;
    if(self.textCount >= 4)
    {
        textLabelH = 6 * font.lineHeight;
    }
    else
    {
         textLabelH = textLabelSize.height + 2 * font.lineHeight;
    }
    self.textFrame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
    
    // 活动过期图片位置
    CGFloat pastIVX = screenWidth - internalSize.width - 2 *PADDING - textLabelY;
    CGFloat pastIVY = PADDING;
    CGFloat pastIVH = textLabelY - 10;
    CGFloat pastIVW = pastIVH;
    self.pastIVFrame = CGRectMake(pastIVX, pastIVY, pastIVH, pastIVW);
    
    

    // 查看全文位置大小
    CGFloat readButtonX;
    CGFloat readButtonY;
    CGFloat readButtonW;
    CGFloat readButtonH;
    if(self.textCount >= 4)
    {
        readButtonX = PADDING;
        readButtonY = CGRectGetMaxY(self.textFrame) + PADDING;
        CGSize readButtonSize = [StringMD5 sizeWithString:@"全看全文" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        readButtonW = readButtonSize.width;
        readButtonH = readButtonSize.height;
    }
    else
    {
        readButtonX = 0;
        readButtonY = 0;
        readButtonW = 0;
        readButtonH = 0;
    }
    
    
    self.readFrame = CGRectMake(readButtonX, readButtonY, readButtonW, readButtonH);
    
    // 创建图片位置
    if ([self.neighborData.picturesArray count])
    {
        CGFloat picturesViewW = (screenWidth - PADDING ) / 3 - (PADDING / 2);
        CGFloat picturesViewH = (screenWidth - PADDING ) / 3 - (PADDING / 2);
        for (int i = 0; i < [self.neighborData.picturesArray count]; i++)
        {
            CGFloat picturesViewX = PADDING + (i % 3)*(picturesViewW + PADDING / 2);
            CGFloat picturesViewY = CGRectGetMaxY(self.textFrame) + readButtonH + PADDING + (PADDING / 2 + picturesViewH) * (i / 3);
            CGRect pictureFrame = CGRectMake(picturesViewX, picturesViewY, picturesViewW, picturesViewH);
            // NSValue可以封装c/c++类型，让ios数组能够添加
            [self.picturesFrame addObject:[NSValue valueWithCGRect:pictureFrame]];
        }
        self.cellHeight = CGRectGetMaxY([(NSValue *)[self.picturesFrame lastObject] CGRectValue]) + PADDING;
    }
    else
    {
        self.cellHeight = CGRectGetMaxY(self.textFrame) + readButtonH + PADDING;
    }

    self.cellHeight += 2 * PADDING;
    
    
    // 报名详情
     if([self.neighborData.topicCategory integerValue] == 1)
     {
         CGFloat applyH = 30;
         CGFloat applyY = self.cellHeight;
         self.applyPoint = CGPointMake(PADDING, applyY);
         self.cellHeight += (2 * PADDING + applyH);
     }
    
    
    // 删除位置
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults stringForKey:@"userId"];
    if([self.neighborData.senderId integerValue] == [userId integerValue])
    {
        CGFloat deleteX;
        CGFloat deleteY;
        CGFloat deleteW;
        CGFloat deleteH;
        CGSize deleteSize = [StringMD5 sizeWithString:@"删除" font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        deleteW = deleteSize.width;
        deleteH = deleteSize.height;
        
        deleteX = screenWidth - deleteW - PADDING;
        deleteY = self.cellHeight;
        
        self.deleteFrame = CGRectMake(deleteX, deleteY, deleteW, deleteH);
        self.cellHeight = CGRectGetMaxY(self.deleteFrame) + 2 * PADDING;
    }
    else
    {
        self.deleteFrame = CGRectMake(0, 0, 0, 0);
    }

    
   
}



-(NSMutableArray *)picturesFrame
{
    if (!_picturesFrame)
    {
        _picturesFrame = [[NSMutableArray alloc]init];
    }
    return _picturesFrame;
}


@end
