//
//  JXHttpClient.m
//  Framework
//
//  Created by wangjunxin on 15-12-11.
//  Copyright (c) 2015年 HuaTeng. All rights reserved.
//

#import "JXHttpClient.h"


@protocol JXHttpClientConnectionDelegate <NSObject,NSURLConnectionDataDelegate>

@property (copy) JXClientFinishedCallback finished;

@end





@implementation JXHttpClient





- (void)send:(JXRequest*)request message:(NSString *)message callback:(JXClientFinishedCallback)callback {
        
}


@end
