//
//  GZTopicModel.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZTopicModel.h"
#import "GZMemberModel.h"
#import "GZNodeModel.h"

@implementation GZTopicModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"               : @"id",
             @"title"            : @"title",
             @"url"              : @"url",
             @"content"          : @"content",
             @"content_rendered" : @"content_rendered",
             @"replies"          : @"replies",
             @"member"           : @"member",
             @"node"             : @"node",
             @"created"          : @"created",
             @"last_modified"    : @"last_modified",
             @"last_touched"     : @"last_touched",
             };
}

+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[GZMemberModel class] fromJSONDictionary:value error:nil];
    }];
}

+ (NSValueTransformer *)nodeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[GZNodeModel class] fromJSONDictionary:value error:nil];
    }];
}

@end