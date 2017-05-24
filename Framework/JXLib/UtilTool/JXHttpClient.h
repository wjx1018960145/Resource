//
//  JXHttpClient.h
//  Framework
//
//  Created by wangjunxin on 15-12-11.
//  Copyright (c) 2015年 HuaTeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXClient.h"
@interface JXHttpClient : NSObject<JXClient>
//请求类
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *method;
@property (nonatomic) NSTimeInterval timeo;
@end
