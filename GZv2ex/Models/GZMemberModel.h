//
//  GZMemberModel.h
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GZMemberModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *memberId;
@property (nonatomic, copy) NSString *memberUsername;
@property (nonatomic, copy) NSString *memberTagline;
@property (nonatomic, copy) NSString *memberAvatarMini;
@property (nonatomic, copy) NSString *memberAvatarNormal;
@property (nonatomic, copy) NSString *memberAvatarLarge;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end


