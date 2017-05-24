//
//  JXClient.h
//  Framework
//
//  Created by wangjunxin on 15-12-11.
//  Copyright (c) 2015年 HuaTeng. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
  求情
 
 */
@interface JXRequest : NSObject
//请求报文头
@property (nonatomic, strong) NSMutableDictionary *headers;
//参数
@property (nonatomic, strong) NSMutableDictionary *parameters;
/**
 *  设置请求头
 *
 *  @param value  值
 *  @param header HEAD
 */
- (void)setHeader:(NSString *)value forHeader:(NSString *)header;


@end

/*
 响应
 */
@interface JXResponse <NSObject>
//响应报文
@property (nonatomic, strong) NSMutableDictionary *returnObject;

@end
//请求完成事回调

typedef void (^JXClientFinishedCallback)(JXResponse *response,NSError *error);





/**
 *  发送请求
 *
 *  @param request  请求
 *  @param message  报文
 *  @param callback 回调
 */
@protocol JXClient <NSObject>
- (void)send:(JXRequest*)request message:(NSString *)message callback:(JXClientFinishedCallback)callback;

@end

/**
 *  服务请求客户端
 */
@interface JXClient : NSObject

/**
 *  创建客户端实例
 *
 *  @return 实例，单例
 */
+ (instancetype)sharedClient;
/** 客户端 */
@property (nonatomic) id<JXClient> client;
/**
 *  发送请求
 *
 *  @param request     请求
 *  @param message     报文
 *  @param callback    回调
 */
- (void)send:(JXRequest *)request withMessage:(id)message callback:(JXClientFinishedCallback)callback;
@end
