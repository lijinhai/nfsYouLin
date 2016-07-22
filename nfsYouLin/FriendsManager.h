//
//  FriendsManager.h
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsManager : NSObject

@property(strong,nonatomic) NSArray* friendsArray;
@property(strong, nonatomic) NSMutableDictionary* friendsDict;

- (id) initWithArray:(NSArray *)friendsArray;
- (NSMutableDictionary *)friendsWithGroupAndSort;
@end
