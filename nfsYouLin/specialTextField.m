//
//  specialTextField.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "specialTextField.h"

@implementation specialTextField
-(void)drawRect:(CGRect)rect

{
    
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, rect);
    // 设置线条颜色
    
    CGContextSetRGBStrokeColor(ctx, 3.0f/255.0f, 121.0f/255.0f, 241.0f/255.0f, 1.0f);
    CGContextMoveToPoint(ctx, 2, rect.size.height-3);
    
    CGContextAddLineToPoint(ctx, rect.size.width-2, rect.size.height-3);
    CGContextMoveToPoint(ctx, 1, rect.size.height-10);
    
    CGContextAddLineToPoint(ctx, 1, rect.size.height-2);
    CGContextMoveToPoint(ctx, rect.size.width-1, rect.size.height-10);
    
    CGContextAddLineToPoint(ctx, rect.size.width-1, rect.size.height-2);
    
    // 开始绘图
    CGContextStrokePath(ctx);
}

@end
