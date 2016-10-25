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


// 计算文本大小
+ (CGSize) sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

// 计算时间间隔
+ (NSString *)calculateTimeInternal:(NSInteger) nowTime old:(NSInteger) oldTime
{
    NSString* internalString;
    NSInteger internal = nowTime - oldTime;
    if(internal < 60)
    {
        internalString = @"刚刚";
    }
    else if(internal >= 60 && internal < 60 * 60)
    {
        internalString = [NSString stringWithFormat:@"%ld分钟前", internal / 60];
    }
    else if(internal >= 60 * 60 && internal < 60 * 60 * 24)
    {
        internalString = [NSString stringWithFormat:@"%ld小时前", internal / (60 * 60)];
    }
    else if(internal >= 60 * 60 * 24 && internal< 60 * 60 * 24 * 30)
    {
        internalString = [NSString stringWithFormat:@"%ld天前", internal / (60 * 60 * 24)];
    }
    else if(internal >= 60 * 60 * 24 * 30 && internal < 60 * 60 * 24 * 30 * 12)
    {
        internalString = [NSString stringWithFormat:@"%ld月前", internal / (60 * 60 * 24 * 30)];
    }
    else if(internal >= 60 * 60 * 24 * 30 * 12)
    {
        internalString = [NSString stringWithFormat:@"%ld年前", internal / (60 * 60 * 24 * 30 * 12)];
    }
    return internalString;
}

+ (NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}

@end

