//
//  StringMD5.m
//  nfsYouLin
//
//  Created by Macx on 16/7/4.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "StringMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation StringMD5


+ (NSString*) stringAddMD5:(NSString *)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
    
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr  stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
@end

