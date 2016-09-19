//
//  ServiceView.h
//  nfsYouLin
//
//  Created by Macx on 16/9/19.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceDelegate <NSObject>

- (void) selectedServiceAddress:(NSString*) text;
- (void) selectedLongServiceAddress:(NSString*) text;

- (void) selectedServiceTime:(NSString*) text;
- (void) selectedLongServiceTime:(NSString*) text;

- (void) selectedServicePhone:(NSString*)text;

@end

@interface ServiceView : UIView

@property(strong, nonatomic) id<ServiceDelegate> delegate;

@property(strong, nonatomic) NSDictionary* serviceInfo;

- (id) initWithFrame:(CGRect)frame;
@end
