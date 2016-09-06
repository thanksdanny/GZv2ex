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
#import "GZHelper.h"
#import "GZTopicListCell.h"

#import "NSDictionary+NotNullKey.h"
#import "HTMLParser.h"
#import <RegexKitLite.h>

@implementation GZTopicModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"topicId"               : @"id",
             @"topicTitle"            : @"title",
             @"topicUrl"              : @"url",
             @"topicContent"          : @"content",
             @"topicContentRendered" : @"content_rendered",
             @"topicReplies"          : @"replies",
             @"topicMember"           : @"member",
             @"topicNode"             : @"node",
             @"topicCreated"          : @"created",
             @"topicLastModified"    : @"last_modified",
             @"topicLastTouched"     : @"last_touched",
             };
}

+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSError *err;
        id result = [MTLJSONAdapter modelOfClass:[GZMemberModel class] fromJSONDictionary:value error:&err];
        return result;
    }];
}

+ (NSValueTransformer *)nodeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[GZNodeModel class] fromJSONDictionary:value error:nil];
    }];
}



/*
 不适用json，使用解析html的方式得出模型
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self.topicId              = [dict objectForSafeKey:@"id"];
    self.topicTitle           = [dict objectForSafeKey:@"title"];
    self.topicReplies         = [dict objectForSafeKey:@"replies"];
    self.topicUrl             = [dict objectForSafeKey:@"url"];
    self.topicContent         = [dict objectForSafeKey:@"content"];
    self.topicContentRendered = [dict objectForSafeKey:@"content_rendered"];
    self.topicCreated         = [dict objectForSafeKey:@"created"];
    self.topicLastModified    = [dict objectForSafeKey:@"last_modified"];
    self.topicLastTouched     = [dict objectForSafeKey:@"last_touched"];
    
    NSDictionary *nodeDict    = [dict objectForSafeKey:@"node"];
    self.topicNode            = [[GZNodeModel alloc] initWithDictionary:nodeDict];
    
    NSDictionary *creatorDict = [dict objectForSafeKey:@"member"];
    self.topicMember          = [[GZMemberModel alloc] initWithDictionary:creatorDict];
    
    /*
     \r ： return 到当前行的最左边。
     \n： newline 向下移动一行，并不移动左右。
     Linux中\n表示回车+换行；
     Windows中\r\n表示回车+换行。
     Mac中\r表示回车+换行。
     */
    self.topicContent         = [self.topicContent stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
    /*
     rangeOfString 前面的参数是要被搜索的字符串，后面是要搜索的字符串
     NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
     */
    while ([self.topicContent rangeOfString:@"\n\r"].location != NSNotFound) {
        self.topicContent = [self.topicContent stringByReplacingOccurrencesOfString:@"\n\r" withString:@"\n"];
    }
    
    // topicCreatedDescription 为已经转好格式的时间戳
    if (self.topicCreated) {
        self.topicCreatedDescription = [GZHelper timeRemainDescriptionWithDateSP:self.topicCreated];
    }
    
    
    return self;
}

@end

@implementation GZTopicList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            GZTopicModel *model = [[GZTopicModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        self.list = list;
    }
    return self;
}

+ (GZTopicList *)getTopicListFromResponseObject:(id)responseObject {
    NSMutableArray *topicArray = [[NSMutableArray alloc] init];
    
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
            return nil;
        }
        
        HTMLNode *bodyNode = [parser body];
        
        NSArray *cellNodes = [bodyNode findChildTags:@"div"];
        
        for (HTMLNode *cellNode in cellNodes) {
            
            NSLog(@"%@  ===================", cellNode.rawContents);
            
            if ([[cellNode getAttributeNamed:@"class"] isEqualToString:@"cell item"]) {
                GZTopicModel *model = [[GZTopicModel alloc] init];
                model.topicMember = [[GZMemberModel alloc] init];
                model.topicNode = [[GZNodeModel alloc] init];
                
                NSArray *tdNodes = [cellNode findChildTags:@"td"];
                
                NSInteger index = 0;
                for (HTMLNode *tdNode in tdNodes) {
                    
                    NSLog(@"td:\n%@   ========================", tdNode.rawContents);
                    
                    NSString *content = tdNode.rawContents;
                    
                    if ([content rangeOfString:@"class=\"avatar\""].location != NSNotFound) {
                        HTMLNode *userIdNode = [tdNode findChildTag:@"a"];
                        if (userIdNode) {
                            NSString *idUrlString = [userIdNode getAttributeNamed:@"href"];
                            model.topicMember.memberUsername = [[idUrlString componentsSeparatedByString:@"/"] lastObject];
                        }
                        
                        HTMLNode *avatarNode = [tdNode findChildTag:@"img"];
                        if (avatarNode) {
                            NSString *avatarString = [avatarNode getAttributeNamed:@"src"];
                            if ([avatarString hasPrefix:@"//"]) {
#warning 若头像显示不出时候注意这里
                                avatarString = [@"http:" stringByAppendingString:avatarString];
                            }
                            model.topicMember.memberAvatarNormal = avatarString;
                        }
                    }
                    
                    if ([content rangeOfString:@"class=\"item_title\""].location != NSNotFound) {
                        NSArray *aNodes = [tdNode findChildTags:@"a"];
                        
                        for (HTMLNode *aNode in aNodes) {
                            if ([[aNode getAttributeNamed:@"class"] isEqualToString:@"node"]) {
                                NSString *nodeUrlString = [aNode getAttributeNamed:@"href"];
                                model.topicNode.nodeName = [[nodeUrlString componentsSeparatedByString:@"/"] lastObject];
                                model.topicNode.nodeTitle = aNode.allContents;
                            } else {
                                if ([aNode.rawContents rangeOfString:@"reply"].location != NSNotFound) {
                                    model.topicTitle = aNode.allContents;
                                    
                                    NSString *topicIdString = [aNode getAttributeNamed:@"href"];
                                    NSArray *subArray = [topicIdString componentsSeparatedByString:@"#"];
                                    
#warning 这里两次强转，应该不会出问题吧？(后来不用强转，使用类型转换的方式)
                                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                                    f.numberStyle = NSNumberFormatterDecimalStyle;
                                    // 将string的topicId转回对应的NSNumber
                                    model.topicId = [f numberFromString:[(NSString *)subArray.firstObject stringByReplacingOccurrencesOfString:@"/t/" withString:@""]];
                                    NSLog(@"%@", model.topicId);
                                    
                                    // 也是用对象f来转，应该ok吧？
                                    model.topicReplies = [f numberFromString:[(NSString *)subArray.lastObject stringByReplacingOccurrencesOfString:@"reply" withString:@""]];
                                }
                            }
                        }
                        
                        NSArray *spanNodes = [tdNode findChildTags:@"span"];
                        for (HTMLNode *spanNode in spanNodes) {
                            if ([spanNode.rawContents rangeOfString:@"href"].location == NSNotFound) {
                                model.topicCreatedDescription = spanNode.allContents;
                            }
                            
                            if ([spanNode.rawContents rangeOfString:@"最后回复"].location != NSNotFound || [spanNode.rawContents rangeOfString:@"前"].location != NSNotFound) {
                                NSString *contentString = spanNode.allContents;
                                NSArray *components = [contentString componentsSeparatedByString:@"  •  "];
                                NSString *dateString;
                                
                                if (components.count > 2) {
                                    dateString = components[2];
                                } else {
                                    dateString = [contentString stringByReplacingOccurrencesOfRegex:@"  •  (.*?)$" withString:@""];
                                }
                                
                                NSArray *stringArray = [dateString componentsSeparatedByString:@" "];
                                if (stringArray.count > 1) {
                                    NSString *unitString = @"";
                                    NSString *subString = [(NSString *)stringArray[1] substringToIndex:1];
                                    if ([subString isEqualToString:@"分"]) {
                                        unitString = @"分钟前";
                                    }
                                    if ([subString isEqualToString:@"小"]) {
                                        unitString = @"小时前";
                                    }
                                    if ([subString isEqualToString:@"天"]) {
                                        unitString = @"天前";
                                    }
                                    dateString = [NSString stringWithFormat:@"%@%@", stringArray[0], unitString];
                                } else {
                                    dateString = @"刚刚";
                                }
                                model.topicCreatedDescription = dateString;
                            }
                        }
                    }
                    index ++;
                }
                
                model.cellHeight = [GZTopicListCell heightWithTopicModel:model];
                
                [topicArray addObject:model];
            }
        }
    }
    
    GZTopicList *list;
    
    if (topicArray.count) {
        list = [[GZTopicList alloc] init];
        list.list = topicArray;
    }
    
    return list;
}

@end