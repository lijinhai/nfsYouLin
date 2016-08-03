//
//  PersonModel.m
//  nfsYouLin
//
//  Created by Macx on 16/7/27.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

@synthesize userDict;
@synthesize nickDict;


+ (PersonModel*) sharedPersonModel
{
    static PersonModel* sharedPersonModel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedPersonModel = [[self alloc] init];
    });
    return sharedPersonModel;
}
@end
