//
//  GZMemberModel.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZMemberModel.h"
#import "NSDictionary+NotNullKey.h"

@implementation GZMemberModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"memberId"           : @"id",
             @"memberUsername"     : @"username",
             @"memberTagline"      : @"tagline",
             @"memberAvatarMini"   : @"avatar_mini",
             @"memberAvatarNormal" : @"avatar_normal",
             @"memberAvatarLarge"  : @"avatar_large",
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self.memberId           = [dict objectForSafeKey:@"id"];
    self.memberUsername     = [dict objectForSafeKey:@"username"];
    self.memberTagline      = [dict objectForSafeKey:@"tagline"];
    self.memberAvatarMini   = [dict objectForSafeKey:@"avatar_mini"];
    self.memberAvatarNormal = [dict objectForSafeKey:@"avatar_normal"];
    self.memberAvatarLarge  = [dict objectForSafeKey:@"avatar_large"];
    
#warning set avatar url prefix
//    if ([self.memberAvatarMini hasPrefix:@"//"]) {
//        self.memberAvatarMini = [@"http:" stringByAppendingString:self.memberAvatarMini];
//    }
//    
//    if ([self.memberAvatarNormal hasPrefix:@"//"]) {
//        self.memberAvatarNormal = [@"http:" stringByAppendingString:self.memberAvatarNormal];
//    }
//    
//    if ([self.memberAvatarLarge hasPrefix:@"//"]) {
//        self.memberAvatarLarge = [@"http:" stringByAppendingString:self.memberAvatarLarge];
//    }
    
    return self;
}

@end
