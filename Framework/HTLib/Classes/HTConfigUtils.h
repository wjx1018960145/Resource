//
//  HTConfigUtils.h
//  HTLib
//
//  Created by jonay on 15/1/6.
//  Copyright (c) 2015年 huateng. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kHTFSClientTypeKey               = @"fsclient.type";
static NSString *const kHTFSClientSecurityKey           = @"fsclient.security";
static NSString *const kHTFSClientSerializerKey         = @"fsclient.serializer";
static NSString *const kHTFSClientHttpUrlKey            = @"fsclient.http.url";
static NSString *const kHTFSClientHttpTimeoutKey        = @"fsclient.http.timeout";
static NSString *const kHTFSClientHttpMessageKeyKey     = @"fsclient.http.contentKey";

static NSString *const kHTSqliteDefaultFileNameKey      = @"sqlite3.defaultFilename";
static NSString *const kHTSqliteWaitTimeoutNameKey      = @"sqlite3.waitTimeout";

static NSString *const kHTRulesKey                      = @"rules";

static NSString *const kHTExceptionHandleType           = @"common.exception.handleType";
static NSString *const kHTExceptionLogFile              = @"common.exception.logFile";
static NSString *const kHTExceptionLogSize              = @"common.exception.logSize";
static NSString *const kHTExceptionMailto               = @"common.exception.mailto";
static NSString *const kHTErrorCodeFile                 = @"common.errorFile";

static NSString *const kHTLogLevel                      = @"logger.level";

static NSString *const kHTSecuritRsaPublicKey           = @"rsa.publicKey";
static NSString *const kHTSecuritRsaPrivateKey          = @"rsa.privateKey";
static NSString *const kHTSecuritRsaPrivatePasswordKey  = @"rsa.password";

/**
 *  配置文件工具类
 *  @discussion 配置文件默认采用config.plist文件
 */
@interface HTConfigUtils : NSObject
/**
 *  以数据字典的方式返回配置文件的全部内容
 *
 *  @return 数据字典
 */
+ (NSDictionary*)config;
/**
 *  根据key获取配置文件中的value值
 *
 *  @param key 键，可用.分隔
 *
 *  @return 值，可能是NSString/NSNumber/Bool类型之一
 */
+ (id)getValue:(NSString*)key;
/**
 *  根据key获取配置文件中的value值
 *
 *  @param key           键，可用.分隔
 *  @param shouldDecrypt 是否需要解密（AES）
 *  @discussion 加密方式采用AES128
 *  @return 解密后的值
 */
+ (id)getValue:(NSString *)key shouldDecrypt:(BOOL)shouldDecrypt;

/**
 *  加载指定文件
 *
 *  @return 配置工具类实例
 */
- (HTConfigUtils *)initWithContentsOfFile:(NSString *)resource;
/**
 *  根据key获取配置文件中的value值
 *
 *  @param key 键，可用.分隔
 *
 *  @return 值，可能是NSString/NSNumber/Bool类型之一
 */
- (id)getValue:(NSString*)key;
/**
 *  根据key获取配置文件中的value值
 *
 *  @param key           键，可用.分隔
 *  @param shouldDecrypt 是否需要解密（AES）
 *  @discussion 加密方式采用AES128
 *  @return 解密后的值
 */

- (id)getValue:(NSString *)key shouldDecrypt:(BOOL)shouldDecrypt;
@end
