//
//  GZDataManager.h
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GZTopicModel;
@class GZReplyList;
@class GZTopicList;

@interface GZDataManager : NSObject

@property (nonatomic, assign) BOOL preferHttps;

// 单例
+ (instancetype)shareManager;

#pragma mark - GET

// 请求最热主题
- (NSURLSessionDataTask *)getHotTopicsSuccess:(void (^)(NSArray *hotArray))succes
                                      failure:(void (^)(NSError *error))failure;
// 请求最新主题
- (NSURLSessionDataTask *)getLatestTopicsSuccess:(void (^)(NSArray *latestArray))success
                                         failure:(void (^)(NSError *error))failure;
- (NSURLSessionDataTask *)getLatestTopicsWithPage:(NSInteger)page
                                          success:(void (^)(NSArray *latestArray))success
                                          failure:(void (^)(NSError *error))failure;

// 请求主题详情
- (NSURLSessionDataTask *)getTopicWithTopicId:(NSNumber *)topicId
                                      success:(void (^)(GZTopicModel *model))success
                                      failure:(void (^)(NSError *error))failure;


// 请求详情评论
- (NSURLSessionDataTask *)getRepliesWithTopicId:(NSNumber *)topicId
                                        success:(void (^)(NSArray *repliesArray))success
                                        failure:(void (^)(NSError *error))failure;

// 获取节点主题列表
- (NSURLSessionDataTask *)getTopicListWithNodeId:(NSNumber *)nodeId
                                        nodename:(NSString *)nodename
                                        username:(NSString *)username
                                            page:(NSInteger)page
                                         success:(void (^)(NSArray *nodeTopicArray))success
                                         failure:(void (^)(NSError *error))failure;
@end
