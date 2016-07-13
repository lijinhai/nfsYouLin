//
//  ShowImageView.m
//  nfsYouLin
//
//  Created by Macx on 16/5/13.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#define imageTag 2000
#import "ShowImageView.h"
#import "UIImageView+WebCache.h"


@implementation ShowImageView


- (id) initWithFrame:(CGRect)frame circularImage:(UIImage*) image
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        self.selfFrame = frame;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.maximumZoomScale = 4;
        _scrollView.minimumZoomScale = 1;
        _scrollView.delegate = self;
        _scrollView.tag = 1100;
        [self addSubview:_scrollView];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height - self.bounds.size.width) / 2, self.bounds.size.width, self.bounds.size.width)];
        imageView.image = image;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = self.bounds.size.width / 2;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 2000;
        [_scrollView addSubview:imageView];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0f;
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame byClickTag:(NSInteger)clickTag appendArray:(NSArray*)appendArray
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.selfFrame = frame;
        self.alpha = 0.0f;
        self.page = 0;
        self.doubleClick = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = true;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(frame.size.width * appendArray.count, 0);
        
        [self.scrollView setContentOffset:CGPointMake(frame.size.width*(clickTag - imageTag), 0) animated:YES];
        self.page = clickTag - imageTag;

        
        for (int i = 0; i < appendArray.count; i ++)
        {
            UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height)];
            imageScrollView.backgroundColor = [UIColor blackColor];
            imageScrollView.contentSize = CGSizeMake(frame.size.width, self.frame.size.height);
            imageScrollView.delegate = self;
            imageScrollView.maximumZoomScale = 4;
            imageScrollView.minimumZoomScale = 1;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//            UIImage *image = [UIImage imageNamed:[appendArray objectAtIndex:i]];
//            imageView.image = image;
            
            NSURL* url = [NSURL URLWithString:[appendArray objectAtIndex:i]];
            
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageAllowInvalidSSLCertificates];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageScrollView addSubview:imageView];
            [_scrollView addSubview:imageScrollView];
            imageScrollView.tag = 100 + i ;
            imageView.tag = 1000 + i;
            
            
        }
        
        [self addSubview:self.scrollView];
        UITapGestureRecognizer* tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
        UITapGestureRecognizer* doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
        
        
    }
    return self;
}



- (void) disappear
{
    _removeImg();
}

- (void)changeBig:(UITapGestureRecognizer *)tapGser
{
    CGFloat newScale;
    UIScrollView* currentView = (UIScrollView *)[self viewWithTag:self.page + 100];
    if(self.doubleClick)
    {
        newScale = 1;
    }
    else
    {
        newScale = 2;
    }
    CGRect zoomRect = [self getRectWithScale:newScale andCenter:[tapGser locationInView:tapGser.view]];
    [currentView zoomToRect:zoomRect animated:YES];
    self.doubleClick = !self.doubleClick;
}

- (CGRect) getRectWithScale:(CGFloat)scale andCenter:(CGPoint)center
{
    CGRect newRect = CGRectZero;
    newRect.size.width = self.selfFrame.size.width / scale;
    newRect.size.height = self.selfFrame.size.height / scale;
    newRect.origin.x = center.x - newRect.size.width / 2;
    newRect.origin.y = center.y - newRect.size.height / 2;
    return newRect;
}

- (void) show:(UIView*) bgView didFinish:(didRemoveImage)tempBlock
{
    [bgView addSubview:self];
    _removeImg = tempBlock;
    [UIView animateWithDuration:.4f animations:^(){
        
        self.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    return imageView;
}


- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = self.scrollView.contentOffset;
    self.page = offset.x / self.selfFrame.size.width;
    // 下一页
    UIScrollView* nextScrollV = (UIScrollView *)[self viewWithTag:self.page + 100 + 1];
    
    if(nextScrollV.zoomScale != 1)
    {
        nextScrollV.zoomScale = 1;
    }
    
    // 上一页
    UIScrollView* previousScrollV = (UIScrollView *)[self viewWithTag:self.page + 100 -1];
    if(previousScrollV.zoomScale != 1)
    {
        previousScrollV.zoomScale = 1;
    }
}


@end
