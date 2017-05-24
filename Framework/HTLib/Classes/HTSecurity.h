//
//  HTSecurity.h
//  HTLib
//
//  Created by jonay on 15/1/12.
//  Copyright (c) 2015年 huateng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  加密解密协议
 */
@protocol HTSecurity <NSObject>
/**
 *  加密
 *
 *  @param plaintext 明文
 *
 *  @return 密文
 */
- (NSString *)encrypt:(NSString *)plaintext;
/**
 *  加密
 *
 *  @param plaintext 明文
 *  @param key       十六进制字符串
 *
 *  @return 密文
 */
- (NSString *)encrypt:(NSString *)plaintext key:(NSString*)key;
/**
 *  解密
 *
 *  @param securtext 密文
 *
 *  @return 明文
 */
- (NSString *)decrypt:(NSString *)securtext;
- (NSString *)decrypt:(NSString *)securtext key:(NSString*)key;
/**
 *  加密
 *
 *  @param data 明文（二进制）
 *
 *  @return 密文（二进制）
 */
- (NSData *)encrypt2:(NSData *)data;
/**
 *  解密
 *
 *  @param data 密文（二进制）
 *
 *  @return 明文（二进制）
 */
- (NSData *)decrypt2:(NSData *)data;
/**
 *  加密
 *
 *  @param data 明文（二进制）
 *  @param key  密钥
 *
 *  @return 密文（二进制）
 */
- (NSData *)encrypt2:(NSData *)data key:(NSData*)key;
/**
 *  解密
 *
 *  @param data 密文（二进制）
 *  @param key  密钥
 *
 *  @return 明文（二进制）
 */
- (NSData *)decrypt2:(NSData *)data key:(NSData*)key;

@end

/**
 *  加密解密基类
 */
@interface HTSecurity : NSObject<HTSecurity>
/**
 *  根据类型创建实例
 *  @param type 加密类型：MD5/BASE64/RSA/AES/DESEDE
 *  @return 实例
 */
+ (instancetype)security:(NSString *)type;
/** 空 */
+ (instancetype)null;
/** MD5 */
+ (instancetype)md5;
/** BASE64 */
+ (instancetype)base64;
/** RSA */
+ (instancetype)rsa;
/** AES128 */
+ (instancetype)aes;
/** DES */
+ (instancetype)des;
/**
 *  算法名称。有点怪异，需要和android保持一致
 *
 *  @return 名称
 */
- (NSString *)name;
- (NSString *)randomKey;

/**
 *  Key位数
 */
@property (nonatomic, readonly) int keySize;
@property (nonatomic, readonly) NSString *defaultKey;
@end

/**
 *  扩展NSString，添加加密、解密api
 */
@interface NSString (HTSecurity)

/* md5 */
- (NSString*)md5;

/* base64 */
- (NSString*)base64enc;
- (NSString*)base64dec;


/* AES128 */
- (NSString*)aesenc;
- (NSString*)aesdec;

/* RSA */
- (NSString*)rsaenc;
- (NSString*)rsadec;

/* DES */
- (NSString*)desenc;
- (NSString*)desdec;
@end
