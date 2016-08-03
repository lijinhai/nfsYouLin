//
//  PersonModel.h
//  nfsYouLin
//
//  Created by Macx on 16/7/27.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (nonatomic, retain) NSMutableDictionary *userDict;
@property (nonatomic, retain) NSMutableDictionary *nickDict;

+ (PersonModel*) sharedPersonModel;
@end
