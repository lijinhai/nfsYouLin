//
//  DialogView.m
//  nfsYouLin
//
//  Created by Macx on 16/7/15.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "DialogView.h"

@implementation DialogView
{
    NSInteger _numberOfLines;
    CGFloat _previousHeight;
    CGFloat maxHeight;
    CGFloat minHeight;
    UIView* parentView;
}




- (id) initWithFrame:(CGRect)frame View:(UIView*) view
{
    self = [super initWithFrame:frame];
    if(self)
    {
        parentView = view;
        self.backgroundColor = [UIColor clearColor];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 12 * 15) / 2, (frame.size.height - 80) / 2, 12 * 15, 80)];
        self.backView.backgroundColor = [UIColor lightGrayColor];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 12 * 15, 40)];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.font = [UIFont systemFontOfSize:12];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.textView.bounces = NO;
        self.textView.scrollEnabled = NO;
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeySend;
        _previousHeight = ceilf([self.textView sizeThatFits:self.textView.frame.size].height);
        maxHeight = 20 * _previousHeight;
        minHeight = _previousHeight;
        [self.backView addSubview:self.textView];
        
        self.send = [[UIButton alloc] initWithFrame:CGRectMake(0, 41, self.backView.frame.size.width / 2 - 0.5, 39)];
        [self.send setTitle:@"发送" forState:UIControlStateNormal];
        self.send.backgroundColor = [UIColor whiteColor];
        [self.send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        [self.send addTarget:self action:@selector(sendBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.send addTarget:self action:@selector(sendColor:) forControlEvents:UIControlEventTouchDown];
        [self.backView addSubview:self.send];
        
        
        self.cancel = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width / 2 + 0.5 , 41, self.backView.frame.size.width / 2 - 0.5, 39)];
        [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
        self.cancel.backgroundColor = [UIColor whiteColor];
        [self.cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cancel addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancel addTarget:self action:@selector(cancelColor:) forControlEvents:UIControlEventTouchDown];
        
        [self.backView addSubview:self.cancel];
        [self addSubview:self.backView];
    }
    
    return self;
    
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(parentView)
    {
        [parentView removeFromSuperview];
    }
    [self removeFromSuperview];
}



- (void) textViewDidChange:(UITextView *)textView
{
    CGFloat toHeight = ceilf([textView sizeThatFits:textView.frame.size].height);
    
    
    if(textView.text.length >= 200)
    {
        textView.text = [textView.text substringToIndex:200];
        return;
    }
    
    
    if(toHeight == _previousHeight)
    {
        return;
    }
    
    if (toHeight < minHeight) {
        toHeight = minHeight;
    }
    if (toHeight > maxHeight) {
        toHeight = maxHeight;
    }
    
    
  
    
    CGFloat changeHeight = toHeight - _previousHeight;
    
    CGFloat textViewW = CGRectGetWidth(textView.frame);
    CGFloat textViewH = CGRectGetHeight(textView.frame);
    
    CGRect textViewFrame = textView.frame;
    
    textViewFrame.size = CGSizeMake(textViewW, toHeight);
    textView.frame= textViewFrame;
    if(changeHeight > 0)
    {
        textViewFrame.size = CGSizeMake(textViewW, textViewH);
        textView.frame= textViewFrame;
    }
    else
    {
        textViewFrame.size = CGSizeMake(textViewW, _previousHeight + 9);
        textView.frame= textViewFrame;
    }
    _previousHeight = toHeight;
    
    
    CGFloat backViewX = self.backView.frame.origin.x;
    CGFloat backViewY = self.backView.frame.origin.y;
    CGFloat backViewW = self.backView.frame.size.width;
    CGFloat backViewH = self.backView.frame.size.height + changeHeight;
    self.backView.frame = CGRectMake(backViewX,backViewY, backViewW, backViewH);
    
    
    CGFloat sendX = self.send.frame.origin.x;
    CGFloat sendY = self.send.frame.origin.y + changeHeight;
    CGFloat sendW = self.send.frame.size.width;
    CGFloat sendH = self.send.frame.size.height;
    self.send.frame = CGRectMake(sendX, sendY, sendW, sendH);
    
    CGFloat cancelX = self.cancel.frame.origin.x;
    CGFloat cancelY = self.cancel.frame.origin.y + changeHeight;
    CGFloat cancelW = self.cancel.frame.size.width;
    CGFloat cancelH = self.cancel.frame.size.height;
    self.cancel.frame = CGRectMake(cancelX, cancelY, cancelW, cancelH);
    
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.backView.frame;
        CGPoint point = frame.origin;
        point.y = 150;
        frame.origin = point;
        self.backView.frame = frame;
        
    }];
}


- (void)sendColor: (id) sender
{
    //    self.send.backgroundColor = [UIColor colorWithRed:224.0 /255.0 green:244.0/255.0 blue:224.0 /255.0 alpha:1];
}

- (void)cancelColor: (id) sender
{
    //    self.cancel.backgroundColor = [UIColor colorWithRed:224.0 /255.0 green:244.0/255.0 blue:224.0 /255.0 alpha:1];
}

- (void) sendBtn:(id) sender
{
    NSLog(@"send");
}

- (void) cancelBtn:(id) sender
{
    //    self.cancel.backgroundColor = [UIColor whiteColor];
    NSLog(@"cancel");
    if(parentView)
    {
        [parentView removeFromSuperview];
    }
    [self removeFromSuperview];
}


@end
