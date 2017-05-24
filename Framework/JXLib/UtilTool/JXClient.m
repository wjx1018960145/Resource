//
//  JXClient.m
//  Framework
//
//  Created by wangjunxin on 15-12-11.
//  Copyright (c) 2015年 HuaTeng. All rights reserved.
//

#import "JXClient.h"

@implementation JXClient
+(instancetype)sharedClient {
   
    static JXClient *jxclient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jxclient = [[JXClient alloc] init];
    });
    return jxclient;
}

- (void)send:(JXRequest *)request withMessage:(id)message callback:(JXClientFinishedCallback)callback {
    NSAssert(message, @"message is not null");
    [self.client send:request message:message callback:^(JXResponse *response, NSError *error) {
        response.returnObject  = message;
        callback(response, error);
    }];
    
    
}

@end
