//
//  GZNodeModel.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZNodeModel.h"
#import "NSDictionary+NotNullKey.h"

@implementation GZNodeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"nodeId"                : @"id" ,
             @"nodeName"              : @"name",
             @"nodeTitle"             : @"title",
             @"nodeTitleAlternative"  : @"title_alternative",
             @"nodeUrl"               : @"url" ,
             @"nodeTopics"            : @"topics",
             @"nodeAvatarMini"        : @"avatar_mini",
             @"nodeAvatarNormal"      : @"avatar_normal",
             @"nodeAvatarLarge"       : @"avatar_large",
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self.nodeId               = [dict objectForSafeKey:@"id"];
    self.nodeName             = [dict objectForSafeKey:@"name"];
    self.nodeUrl              = [dict objectForSafeKey:@"url"];
    self.nodeTitle            = [dict objectForSafeKey:@"title"];
    self.nodeTitleAlternative = [dict objectForSafeKey:@"title_alternative"];
    self.nodeTopics           = [dict objectForSafeKey:@"topics"];
    self.nodeAvatarMini       = [dict objectForSafeKey:@"header"];
    self.nodeAvatarNormal     = [dict objectForSafeKey:@"footer"];
    self.nodeAvatarLarge      = [dict objectForSafeKey:@"created"];
    
    
    return self;
}

@end

@implementation GZNodeList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in array) {
            GZNodeModel *model = [[GZNodeModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        self.list = list;
    }
    
    return self;
}

@end


@implementation GZMenuNode

- (id)initWithNodeName:(NSString *)name nodeCode:(NSString *)code {
    self = [super init];
    
    if (self) {
        self.nodeName = name;
        self.nodeCode = code;
    }
    return self;
}

@end

@implementation GZMenuChildNode

- (id)initWithChildNodeName:(NSString *)name childNode:(NSString *)code {
    self = [super init];
    
    if (self) {
        self.childNodeName = name;
        self.childNodeCode = code;
    }
    
    return self;
}

@end
