//
//  GZHelper.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZHelper.h"
#import <UIKit/UIKit.h> #warning 不导入这个导致无法使用CGFloat
/*
 在XCode6之前 创建项目会自动导入Foundation.h和UIKit.h
 
 而Xcode6只导入了Foundation.h
 
 所以只要在类头文件部分加上
 
 #import <UIKit/UIKit.h>
 */


@implementation GZHelper

#pragma mark - 时间戳

// timestamp

+ (NSString *)timeRemainDescriptionWithDateSP:(NSNumber *)dateSP {
    NSDate *timeSp = [NSDate dateWithTimeIntervalSince1970:[dateSP floatValue]];
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Coordinated Universal Time 协调世界时
    [utcDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [utcDateFormatter stringFromDate:timeSp];
    
    return [GZHelper timeRemainDescriptionWithUTCString:dateString]; // 调UTCString的那个类方法
}

// time string

+ (NSString *)timeRemainDescriptionWithUTCString:(NSString *)dateString {
    NSString *minuteStr = @"分钟";
    NSString *hourStr = @"小时";
    NSString *dayStr = @"天";
    
    NSTimeInterval interval = [self timeIntervalWithUTCString:dateString];
    
    NSString *before = @"";
    
    if (interval < 0) {
        interval = -interval;
        before = @"前";
    }
    
    CGFloat minute = interval / 60.0f;
    if (minute < 60.0f) {
        if (minute < 1.0f) {
            return @"刚刚";
        }
        return [NSString stringWithFormat:@"%.f%@%@", minute, minuteStr, before];
    } else {
        CGFloat hour = minute / 60.0f;
        if (hour < 24.0f) {
            return [NSString stringWithFormat:@"%.f%@%@", hour, hourStr, before];
        } else {
            CGFloat day = hour / 24.0f;
            if (day < 7.0f) {
                return [NSString stringWithFormat:@"%.f%@%@", day, dayStr, before];
            } else {
                NSArray *dateArray = [self localDateStringWithUTCString:dateString];
                if (dateArray.count == 2) {
                    return dateArray[0];
                } else {
                    return dateString;
                }
            }
        }
    }
    
    return nil;
}

// interval

+ (NSTimeInterval)timeIntervalWithUTCString:(NSString *)dateString {
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [utcDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *utcDate = [utcDateFormatter dateFromString:dateString];
    NSTimeInterval interval = [utcDate timeIntervalSinceNow];
    
    return interval;
}

// local
+ (NSArray *)localDateStringWithUTCString:(NSString *)dateString {
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [utcDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *utcDate = [utcDateFormatter dateFromString:dateString];
    
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    [localDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [localDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *localTimeString = [localDateFormatter stringFromDate:utcDate];
    NSArray *localArray = [localTimeString componentsSeparatedByString:@" "];
    
    return localArray;
}



@end