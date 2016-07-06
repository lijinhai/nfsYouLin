//
//  StringMD5.h
//  nfsYouLin
//
//  Created by Macx on 16/7/4.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringMD5 : NSObject
+ (NSString*) stringAddMD5:(NSString *)input;
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
@end
