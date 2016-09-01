//
//  GZDataManager.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

/**
 要使用常规的AFN网络访问
 
 1. AFHTTPRequestOperationManager *manager =             [AFHTTPRequestOperationManager manager];
 
 所有的网络请求,均有manager发起
 
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
 
 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
 2> 如果返回格式不是JSON的,
 
 3. 请求格式
 
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer          XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合
 */


// 主题回复 http://www.v2ex.com/api/replies/show.json?topic_id=299071
// 主题详情 http://www.v2ex.com/api/topics/show.json?id=296023

#import "GZDataManager.h"
#import <AFNetworking.h>
#import "GZTopicModel.h"
#import "GZReplyModel.h"

#define BASE_URL @"https://www.v2ex.com/"

typedef NS_ENUM(NSInteger, GZRequestMethod) {
    GZRequestMethodJSONGET   =1,
    GZRequestMethodHTTPPOST  =2,
    GZRequestMethodHTTPGET   =3,
};

@interface GZDataManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, copy) NSString *userAgentMobile;
@property (nonatomic, copy) NSString *userAgentPC;

@end

@implementation GZDataManager

- (instancetype)init {
    //    self = [super init];
    //    if (self) {
    //        // 创建会话管理者
    //        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    //        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    }
    
    if (self = [super init]) {
        // 利用UIWebView获取userAgent
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        self.userAgentMobile = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        self.userAgentPC = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14";
        
        // 不写https
        // self.preferHttps = kSetting.preferHttps;
        
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    
    return self;
}


+ (instancetype)shareManager {
    static GZDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GZDataManager alloc] init];
    });
    
    return manager;
}


// 请求方法
- (NSURLSessionDataTask *)requestWithMethod:(GZRequestMethod)method
                                  URLString:(NSString *)URLString parameters:(NSDictionary *)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSError *error))failure {
    // 菊花转
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Handle Common Mission, Cache, Data Reading & etc.
    void (^responseHandleBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // Any common handler for Response
        
        //        NSLog(@"URL:\n%@", [task.currentRequest URL].absoluteString);
        
        
        success(task, responseObject);
        
    };
    
    // Create HTTPSession
    NSURLSessionDataTask *task = nil;
    
    [self.manager.requestSerializer setValue:self.userAgentMobile forHTTPHeaderField:@"User-Agent"];
    
    if (method == GZRequestMethodJSONGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //            V2Log(@"Error: \n%@", [error description]);
            //            #define V2Log(...) NSLog(@"%@", [NSString stringWithFormat:__VA_ARGS__]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    if (method == GZRequestMethodHTTPGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    if (method == GZRequestMethodHTTPPOST) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    
    return task;
}


#pragma mark - GET

// 请求最热主题
- (NSURLSessionDataTask *)getHotTopicsSuccess:(void (^)(NSArray *hotArray))succes
                                      failure:(void (^)(NSError *error))failure {
    return [self requestWithMethod:GZRequestMethodJSONGET
                         URLString:@"/api/topics/hot.json"
                        parameters:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSArray *hotArray = [MTLJSONAdapter modelsOfClass:[GZTopicModel class] fromJSONArray:responseObject error:nil];
                               succes(hotArray);
                           }
                           failure:^(NSError *error) {
                               failure(error);
                           }];
}

/*
 请求最新主题 根据官方给的接口
 */
- (NSURLSessionDataTask *)getLatestTopicsSuccess:(void (^)(NSArray *latestArray))success
                                         failure:(void (^)(NSError *error))failure {
    return [self requestWithMethod:GZRequestMethodJSONGET
                         URLString:@"/api/topics/latest.json"
                        parameters:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSArray *latestArray = [MTLJSONAdapter modelsOfClass:[GZTopicModel class] fromJSONArray:responseObject error:nil];
                               success(latestArray);
                           } failure:^(NSError *error) {
                               failure(error);
                           }];
}

/*
 分页获取最近主题
 
 需要通过解析html去获取
 */
- (NSURLSessionDataTask *)getLatestTopicsWithPage:(NSInteger)page
                                          success:(void (^)(NSArray *))success
                                          failure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    
    if (page) {
        parameters = @{
                       @"p" : @(page)
                       };
    }
    
    return [self requestWithMethod:GZRequestMethodHTTPGET
                         URLString:@"recent"
                        parameters:parameters
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSArray *latestArray = [MTLJSONAdapter modelsOfClass:[GZTopicModel class] fromJSONArray:responseObject error:nil];
                               success(latestArray);
                           } failure:^(NSError *error) {
                               failure(error);
                           }];
}




// 请求主题详情
- (NSURLSessionDataTask *)getTopicWithTopicId:(NSNumber *)topicId
                                      success:(void (^)(GZTopicModel *model))success
                                      failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters;
    if (topicId) {
        parameters = @{@"id" : topicId};
    }
    return [self requestWithMethod:GZRequestMethodJSONGET
                         URLString:@"/api/topics/show.json"
                        parameters:parameters
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSLog(@"=========%@", responseObject);
                               NSError *error = nil;
                               GZTopicModel *model = [[GZTopicModel alloc] initWithDictionary:[responseObject firstObject] error:&error];
                               //                               貌似可以直接用下面这个方法转，可以直接返回数组而不是model
                               //                               GZTopicModel *model = [MTLJSONAdapter modelsOfClass:[GZTopicModel class] fromJSONArray:responseObject error:nil];
                               success(model);
                           }
                           failure:^(NSError *error) {
                               failure(error);
                           }];
}

// 请求详情评论

- (NSURLSessionDataTask *)getRepliesWithTopicId:(NSNumber *)topicId
                                        success:(void (^)(NSArray *repliesArray))success
                                        failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters;
    if (topicId) {
        parameters = @{@"topic_id" : topicId};
    }
    return  [self requestWithMethod:GZRequestMethodJSONGET
                          URLString:@"/api/replies/show.json"
                         parameters:parameters
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                NSArray *repliesArray = [MTLJSONAdapter modelsOfClass:[GZReplyModel class] fromJSONArray:responseObject error:nil];
                                success(repliesArray);
                            }
                            failure:^(NSError *error) {
                                NSLog(@"请求评论失败");
                                failure(error);
                            }];
}

// 获取节点主题列表
- (NSURLSessionDataTask *)getTopicListWithNodeId:(NSNumber *)nodeId
                                        nodename:(NSString *)nodename
                                        username:(NSString *)username
                                            page:(NSInteger)page
                                         success:(void (^)(NSArray *nodeTopicArray))success
                                         failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters;
    if (nodeId) {
        parameters = @{
                       @"node_id" : nodeId,
                       @"p"       : @(page),
                       };
    }
    if (nodename) {
        parameters = @{
                       @"node_name" : nodename,
                       @"p"         : @(page)
                       };
    }
    if (username) {
        parameters = @{
                       @"username" : username,
                       @"p"        : @(page)
                       };
    }
    
    return [self requestWithMethod:GZRequestMethodJSONGET
                         URLString:@"/api/topics/show.json"
                        parameters:parameters
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSArray *nodeTopiclist = [MTLJSONAdapter modelsOfClass:[GZTopicModel class] fromJSONArray:responseObject error:nil];
                               success(nodeTopiclist);
                           }
                           failure:^(NSError *error) {
                               failure(error);
                           }];
}

@end