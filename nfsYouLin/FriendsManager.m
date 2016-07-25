//
//  FriendsManager.m
//  nfsYouLin
//
//  Created by Macx on 16/7/22.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "FriendsManager.h"
#import "Friends.h"

@implementation FriendsManager

- (id) initWithArray:(NSArray *)friendsArray
{
    self = [super init];
    if(self)
    {
        _friendsArray = friendsArray;
    }
    return self;
}



- (NSMutableDictionary *)friendsWithGroupAndSort
{
    if(self.friendsDict == nil)
    {
        self.friendsDict = [[NSMutableDictionary alloc]init];
    }
    NSMutableDictionary* groupDict = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [_friendsArray count]; i++)
    {
        Friends* friend = [_friendsArray objectAtIndex:i];
        NSString* nick = [self getEnglishString:friend.nick];
        nick = [nick capitalizedString];
        unichar c = [nick characterAtIndex:0];
        if(!(c >= 'A' && c <= 'Z'))
        {
            c = '#';
        }
        NSString* key = [NSString stringWithFormat:@"%c",c];
        NSMutableArray* array = [groupDict valueForKey:key];
        if(!array)
        {
            array = [[NSMutableArray alloc] init];
        }
        [array addObject:friend];
        [groupDict setObject:array forKey:key];
    }
    
    for(id key in groupDict)
    {
        NSArray* arr = [self sortArrayWithArray:groupDict[key]];
        [self.friendsDict setObject:arr forKey:key];
    }
    
    return self.friendsDict;
}

- (NSString*)getEnglishString: (NSString*)string
{
    NSMutableString *source = [string mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

- (NSMutableArray *)sortArrayWithArray:(NSArray*) array
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:array];
    NSMutableArray* arr1 = [[NSMutableArray alloc] init];
    NSArray* arr2;
    NSMutableArray* arr3 = [[NSMutableArray alloc] init];
    for(int i = 0; i < [array count]; i++)
    {
        Friends* friends = [array objectAtIndex:i];
        NSString* sourceName = friends.nick;
        NSString* lowerName = [[self getEnglishString:sourceName] lowercaseString];
        [arr1 addObject:lowerName];
    }
    arr2 = [arr1 sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 0; i < [arr2 count]; i++)
    {
        
        NSUInteger index = [arr1 indexOfObject:arr2[i]];
        [arr3 addObject:arr[index]];
        [arr1 removeObjectAtIndex:index];
        [arr removeObjectAtIndex:index];

    }
    
    return arr3;
}



@end
