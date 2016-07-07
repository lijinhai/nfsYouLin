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
    
    // 头像位置大小
    CGFloat iconViewX = PADDING;
    CGFloat iconViewY = PADDING;
    CGFloat iconViewW = 60;
    CGFloat iconViewH = 60;
    self.iconFrame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    // 帖子标题位置大小
    CGFloat titleLabelX = CGRectGetMaxX(self.iconFrame) + PADDING;
    CGSize titleLabelSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"#%@#%@",self.neighborData.titleCategory,self.neighborData.titleName] font:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat titleLabelY = iconViewY + PADDING / 2;
    CGFloat titleLabelW = titleLabelSize.width;
    CGFloat titleLabelH = titleLabelSize.height;
    self.titleFrame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    // 用户信息位置大小
    CGFloat accountInfoLabelX = CGRectGetMaxX(self.iconFrame) + PADDING;
    CGFloat accountInfoLabelY = CGRectGetMaxY(self.titleFrame);
    CGSize accountInfoLabelSize = [StringMD5 sizeWithString:[NSString stringWithFormat:@"%@@%@",self.neighborData.accountName, self.neighborData.addressInfo] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat accountInfoLabelW = accountInfoLabelSize.width;
    CGFloat accountInfoLabelH = accountInfoLabelSize.height;
    self.accountInfoFrame = CGRectMake(accountInfoLabelX, accountInfoLabelY, accountInfoLabelW, accountInfoLabelH);
    
    // 帖子内容位置大小
//    UIFont *font = [UIFont systemFontOfSize:16];
    UIFont *font = [UIFont fontWithName:@"AppleGothic" size:16];
    CGFloat textLabelX = PADDING;
    CGFloat textLabelY = CGRectGetMaxY(self.iconFrame) + PADDING;
    CGSize textLabelSize = [StringMD5 sizeWithString:self.neighborData.publishText font:font maxSize:CGSizeMake(screenWidth - 2 * PADDING, MAXFLOAT)];
   
    CGFloat textLabelW = textLabelSize.width;
    CGFloat textLabelH;
    self.textCount = textLabelSize.height / font.lineHeight;
    if(self.textCount > 4)
    {
        textLabelH = 4 * font.lineHeight;
    }
    else
    {
         textLabelH = textLabelSize.height;
    }
    self.textFrame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
    

    // 查看全文位置大小
    CGFloat readButtonX;
    CGFloat readButtonY;
    CGFloat readButtonW;
    CGFloat readButtonH;
    if(self.textCount > 4)
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
        self.cellHeight = CGRectGetMaxY(self.textFrame) + readButtonH +PADDING;
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
