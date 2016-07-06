//
//  redarwTextField.m
//  nfsYouLin
//
//  Created by jinhai on 16/5/11.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "redrawTextField.h"

@implementation redrawTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init:(CGRect)frame addTextField:(UITextField *)inputInfoText
{
    //CGRect frameRect = CGRectMake(0, 0, 320, 200);
    [inputInfoText addTarget:self action:@selector(getFieldFocus) forControlEvents:UIControlEventEditingDidBegin];
    [inputInfoText addTarget:self action:@selector(lostFieldFocus) forControlEvents:UIControlEventEditingDidEnd];
    self = [self initWithFrame:frame addTextField:inputInfoText];
    if (self)
    {
        NSLog(@"Init called1");
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame addTextField:(UITextField *)inputInfoText
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        NSLog(@"Init called2");
        self.backgroundColor=[UIColor clearColor];
        [self addSubview:inputInfoText];
        
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    //CGContextClearRect(ctx, rect);
    CGContextClearRect(ctx, rect);
    // 设置线条颜色
    CGContextSetLineWidth(ctx, 1.5f);
    CGContextSetRGBStrokeColor(ctx, _redValue/255.0f, _greenValue/255.0f, _blueValue/255.0f, 1.0f);
    CGContextMoveToPoint(ctx, 2.5f, rect.size.height-1.5);
    
    CGContextAddLineToPoint(ctx, rect.size.width-1.5, rect.size.height-1.5);
    CGContextMoveToPoint(ctx, 2.5f, rect.size.height-5.5);
    
    CGContextAddLineToPoint(ctx, 2.5f, rect.size.height-1.5);
    CGContextMoveToPoint(ctx, rect.size.width-1.5, rect.size.height-5.5);
    
    CGContextAddLineToPoint(ctx, rect.size.width-1.5, rect.size.height-1.5);
    CGContextSetRGBFillColor(ctx,225.0f,225.0f,225.0f,1.0f);
    // 开始绘图
    CGContextStrokePath(ctx);
}



-(void)getFieldFocus{
    
    self.redValue=65.0f;
    self.greenValue=105.0f;
    self.blueValue=255.0f;
    [self setNeedsDisplay];
    //[self setNeedsFocusUpdate];
    //[self.view addSubview:testField];
}

-(void)lostFieldFocus
{
    [self lineConvertToBlack];
}


-(void)lineConvertToBlack
{
    self.redValue = 0.0f;
    self.greenValue = 0.0f;
    self.blueValue = 0.0f;
    [self setNeedsDisplay];
}


- (void) lineConvertToGray
{
    self.redValue = 220.0f;
    self.greenValue = 220.0f;
    self.blueValue = 220.0f;
    [self setNeedsDisplay];
}




@end
