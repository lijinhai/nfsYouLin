//
//  SqlDictionary.h
//  nfsYouLin
//
//  Created by Macx on 16/7/7.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqlDictionary : NSObject


- (NSMutableDictionary *) getInitUserDictionary;

- (NSMutableDictionary *) getInitNewsDictionary;
- (NSMutableDictionary *)getInitFamilyInfoDic;
@end
