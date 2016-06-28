//
//  SearchBarView.h
//  nfsYouLin
//
//  Created by Macx on 16/6/21.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchBarView;
@protocol SearchBarViewDelegate <NSObject>

@optional

// 点击searchBar的输入区域，就会依次触发
- (BOOL) SearchBarShouldBeginEditing: (SearchBarView *)searchBar;
- (void) SearchBarTextDidBeginEditing: (SearchBarView *)searchBar;
- (BOOL) SearchBarShouldEndEditing: (SearchBarView *)searchBar;
- (void) SearchBarTextDidEndEditing: (SearchBarView *)searchBar;


// 文本改变激发的方法
- (void) SearchBarView: (SearchBarView *)searchBar textDidChange: (NSString *)searchText;
// 文字改变前激发的方法

- (BOOL) SearchBarView: (SearchBarView *)searchBar shouldChangeTextInRange: (NSRange)range replacementText: (NSString *)text;

// 单击虚拟键盘上的search 激发的方法
- (void) SearchBarViewSearchButtonClicked: (SearchBarView *)searchBar;
@end



@interface SearchBarView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backGroundView; // 设置背景图片
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, weak) id <SearchBarViewDelegate> delegate;
@property (nonatomic, assign) BOOL isFirstResponder;

- (instancetype) initWithFrame:(CGRect)frame;


- (void) resignFirstResponder;
- (void) becomeFirstResponder;


@end
