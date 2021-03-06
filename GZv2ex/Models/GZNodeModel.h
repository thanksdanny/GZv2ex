//
//  GZNodeModel.h
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GZNodeModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *nodeId;
@property (nonatomic, copy) NSString *nodeName;
@property (nonatomic, copy) NSString *nodeTitle;
@property (nonatomic, copy) NSString *nodeTitleAlternative;
@property (nonatomic, copy) NSString *nodeUrl;
@property (nonatomic, copy) NSNumber *nodeTopics;
@property (nonatomic, copy) NSString *nodeAvatarMini;
@property (nonatomic, copy) NSString *nodeAvatarNormal;
@property (nonatomic, copy) NSString *nodeAvatarLarge;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface GZNodeList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end
