//
//  UpdatePhotoView.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "UpdatePhotoView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationDownSlide.h"
#import "UILabeltouch.h"

@implementation UpdatePhotoView{

    UIView *_downView;
    UIView *_bGView1;
    UIView *_bGView2;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    //self.alpha=0.0f;
    self.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.1];
    /*定义view*/
    _bGView1= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 119)];
    _bGView1.backgroundColor=[UIColor whiteColor];
    _bGView1.layer.cornerRadius=5.0;
    
    //self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1f];
    //_bGView2= [[UIViewLinkmanTouch alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, 59)];
    //_bGView2.backgroundColor=[UIColor whiteColor];
    //_bGView1.layer.cornerRadius=5.0;
    
    
    UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, 0.6)];
    line.backgroundColor=[UIColor lightGrayColor];
    
    
    UILabel *Photograph=[[touchLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
    Photograph.text=@"相册";
    Photograph.textAlignment=NSTextAlignmentCenter;
    Photograph.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photographTouchUpInside:)];
    [Photograph addGestureRecognizer:labelTapGestureRecognizer];
    
    
    
    UILabel * Photogallery=[[touchLabel alloc] initWithFrame:CGRectMake(0, 61, self.frame.size.width, 59)];
    Photogallery.text=@"从相册选择";
    Photogallery.textAlignment=NSTextAlignmentCenter;
    Photogallery.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photogalleryTouchUpInside:)];
    [Photogallery addGestureRecognizer:labelTapGestureRecognizer1];
    
    
    
    [_bGView1 addSubview:line];
    [_bGView1 addSubview:Photograph];
    [_bGView1 addSubview:Photogallery];
    
    
    _downView= [[UIView alloc] initWithFrame:CGRectMake(0, 129, self.frame.size.width,50)];
    _downView.backgroundColor=[UIColor whiteColor];
    _downView.layer.cornerRadius=5.0;
    UILabel *cancelLabel=[[touchLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,50)];
    cancelLabel.text=@"取消";
    cancelLabel.textAlignment=NSTextAlignmentCenter;
    cancelLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTouchUpInside:)];
    [cancelLabel addGestureRecognizer:labelTapGestureRecognizer2];
    [_downView addSubview:cancelLabel];
    
    //[self addSubview:sampleView];
    [self addSubview:_bGView1];
    //[self addSubview:_bGView2];
    [self addSubview:_downView];
    
     return self;
    
}

+ (instancetype)defaultPopupView{
    
    UpdatePhotoView *photoView=[[UpdatePhotoView alloc]initWithFrame:CGRectMake(20, 0, [[UIScreen mainScreen] bounds].size.width-40, 175)];
   
    photoView.alpha=1.0;
    //photoView.parentVC.view.backgroundColor=[UIColor clearColor];
    return photoView;
}

-(void) dismissMyTable{
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDownSlide new]];
}


-(void) photographTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    NSLog(@"%@",label.text);
    [self dismissMyTable];
}

-(void) photogalleryTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    NSLog(@"%@",label.text);
    [self dismissMyTable];
}

-(void) cancelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    NSLog(@"%@",label.text);
    [self dismissMyTable];
}
@end
