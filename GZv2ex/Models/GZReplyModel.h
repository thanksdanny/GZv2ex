//
//  GZReplyModel.h
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <Mantle/Mantle.h>

@class GZMemberModel;

@interface GZReplyModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy  ) NSNumber      *id;
@property (nonatomic, copy  ) NSNumber      *thanks;
@property (nonatomic, copy  ) NSString      *content;
@property (nonatomic, copy  ) NSString      *content_rendered;
@property (nonatomic, strong) GZMemberModel *member;
@property (nonatomic, strong) NSNumber      *created;
@property (nonatomic, copy  ) NSNumber      *last_modified;

@property (nonatomic, assign) CGFloat cellHeight;

@end
