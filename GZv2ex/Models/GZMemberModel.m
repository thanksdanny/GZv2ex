//
//  GZMemberModel.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZMemberModel.h"

@implementation GZMemberModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"            : @"id",
             @"username"      : @"username",
             @"tagline"       : @"tagline",
             @"avatar_mini"   : @"avatar_mini",
             @"avatar_normal" : @"avatar_normal",
             @"avatar_large"  : @"avatar_large",
             };
}

@end

@implementation GZMemberList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in array) {
            NSError *error = nil;
            GZMemberModel *model = [[GZMemberModel alloc] initWithDictionary:dict error:&error];
            [list addObject:model];
        }
        self.list = list;
    }
    return self;
}

@end