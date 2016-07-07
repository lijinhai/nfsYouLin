//
//  SearchBarView.m
//  nfsYouLin
//
//  Created by Macx on 16/6/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "SearchBarView.h"
#import "StringMD5.h"

@implementation SearchBarView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    
    return self;
}


- (void) setupSubviews
{
    self.backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:self.backGroundView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 3, self.bounds.size.width, self.bounds.size.height - 6)];
    self.textField.backgroundColor = [UIColor clearColor];
    
    self.textField.delegate = self;
    self.textField.clearButtonMode = YES;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    // 让文本编辑框的光标在ios7 下可见
    self.textField.tintColor =[UIColor blueColor];
    
    [self addSubview:self.textField];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SearchBarDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setupDefaultLeftView];
    [self setupDefaultBackGroundView];
}

- (void) setupDefaultLeftView
{
    CGSize leftButtonSize =  [StringMD5 sizeWithString:@"搜全部" font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftButtonSize.width + 20, self.bounds.size.height)];
    
    
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, leftButtonSize.width, self.bounds.size.height)];
        self.leftButton.backgroundColor = [UIColor clearColor];
//    [self.leftButton setTitle:@"搜全部" forState:UIControlStateNormal];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.leftButton setFont:[UIFont systemFontOfSize:14]];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftButton.frame) + 5, self.bounds.size.height / 4, self.bounds.size.height / 2, self.bounds.size.height / 2)];
    leftImageView.image = [UIImage imageNamed:@"right_arrow_icon"];
    [leftView addSubview:self.leftButton];
    [leftView addSubview:leftImageView];
    
    self.textField.leftView = leftView;
}

- (void) setupDefaultBackGroundView
{
    // 使用颜色创建UIImage
    
    CGSize imageSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor blueColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage* colorImage = UIGraphicsGetImageFromCurrentImageContext();
    
    self.backGroundView.layer.cornerRadius = 10;
    self.backGroundView.layer.masksToBounds = YES;
    [self.backGroundView setImage:colorImage];
}


- (void) setBackGroundView:(UIImage *)backGroundImage
{
    [self.backGroundView setImage:backGroundImage];
}



- (void) SearchBarDidChange: (NSNotification* )notification
{
    UITextField* textField = [notification object];
    if(self.delegate && [self.delegate respondsToSelector:@selector(SearchBarView:textDidChange:)])
    {
        [self.delegate SearchBarView:self textDidChange:textField.text];
    }
}

- (void) setFont:(UIFont *)font
{
    self.textField.font = font;
}

- (void) setPlaceholderColor:(UIColor *)placeholderColor
{
    [self.textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}


- (void) setTextColor:(UIColor *)textColor
{
    [self.textField setTextColor:textColor];
}

- (NSString *)text
{
    return self.textField.text;
}

- (void) setPlaceholder:(NSString *)placeholder
{
    self.textField.placeholder = placeholder;
}

- (void) resignFirstResponder
{
    [self.textField resignFirstResponder];
}

- (void) becomeFirstResponder
{
    [self.textField becomeFirstResponder];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"SearchBarView textFieldShouldBeginEditing!");
    if(self.delegate && [self.delegate respondsToSelector:@selector(SearchBarShouldEndEditing:)])
    {
        
        [self.delegate SearchBarShouldBeginEditing:self];
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"SearchBarView textFieldDidBeginEditing!");
    self.isFirstResponder = YES;
    if(self.delegate && [self.delegate respondsToSelector:@selector(SearchBarTextDidBeginEditing:)])
    {
        [self.delegate SearchBarTextDidBeginEditing:self];
    }
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"SearchBarView textFieldShouldEndEditing!");
    if(self.delegate && [self.delegate respondsToSelector:@selector(SearchBarShouldEndEditing:)])
    {
        return [self.delegate SearchBarShouldEndEditing:self];
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"SearchBarView textFieldDidEndEditing!");
    if(self.delegate && [self.delegate respondsToSelector:@selector(SearchBarTextDidEndEditing:)])
    {
        [self.delegate SearchBarTextDidEndEditing:self];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(SearchBarView:shouldChangeTextInRange:replacementText:)])
    {
        return [self.delegate SearchBarView:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField
{
    return YES;
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        [self.delegate SearchBarViewSearchButtonClicked:self];
    }
    return YES;
}


@end

