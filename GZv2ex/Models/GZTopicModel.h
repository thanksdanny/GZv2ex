//
//  GZTopicModel.h
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <Mantle/Mantle.h>

@class GZMemberModel;
@class GZNodeModel;

@interface GZTopicModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *topicId;
@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, copy) NSString *topicUrl;
@property (nonatomic, copy) NSString *topicContent;
@property (nonatomic, copy) NSString *topicContentRendered;
@property (nonatomic, copy) NSNumber *topicReplies;
@property (nonatomic, copy) NSNumber *topicCreated;
@property (nonatomic, copy) NSNumber *topicLastModified;
@property (nonatomic, copy) NSNumber *topicLastTouched;

@property (nonatomic, strong) GZMemberModel *topicMember;
@property (nonatomic, strong) GZNodeModel   *topicNode;

@property (nonatomic, copy) NSString *topicCreatedDescription;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat titleHeight;

@end


@interface GZTopicList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;
+ (GZTopicList *)getTopicListFromResponseObject:(id)responseObject;
@end

