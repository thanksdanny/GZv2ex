//
//  GZHelper.h
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZHelper : NSObject

/**
 *  日期时间
 */

+ (NSString *)timeRemainDescriptionWithDateSP:(NSNumber *)dateSP;
+ (NSString *)timeRemainDescriptionWithUTCString:(NSString *)dateString;

// interval
+ (NSTimeInterval)timeIntervalWithUTCString:(NSString *)dateString;

// local
+ (NSArray *)localDateStringWithUTCString:(NSString *)dateString;

@end
