//
//  HTSecurity.m
//  HTLib
//
//  Created by jonay on 15/1/12.
//  Copyright (c) 2015年 huateng. All rights reserved.
//

#import "HTSecurity.h"
#import "HTConfigUtils.h"
#import "HTLog.h"
#import "HTUtils.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

static NSString *MD5_KEY = @"Huateng.gd.Ocean's Fourteen.DWMNTH2CJFLCWL";
//static Byte DEFAULT_AES128_KEY[] = {69, -35, -53, -45, 23, 106, 60, 49, -40, 58, 62, -75, 96, -9, 12, 101};
//static Byte DEFAULT_DES_KEY[] =  {-92, 73, -57, 35, 56, -56, -88, 4, 84, 19, 49, 74, -3, -14, 11, 2, 21, 124, 42, 22, -29, 87, 117, -32};

static Byte DES_IV[] = {-56, -88, -14, 11, 22, -29, 87, -32};
static NSString *AES256_KEY = @"0808040b020f0b0c010309070c03070a040f060f0e0905010a0a01090607090d";//16进制
static NSString *AES128_KEY = @"45ddcbd3176a3c31d83a3eb560f70c65";//16进制
static NSString *DESEDE_KEY = @"a449c72338c8a8045413314afdf20b02157c2a16e35775e0";//16进制
/**
 *  Md5算法
 *  @discussion 非对称加密，不能解密
 */
@interface HTSecurityMd5 : HTSecurity
@end

/**
 *  Base64算法
 */
@interface HTSecurityBase64 : HTSecurity
@end

/**
 *  RSA算法
 */
@interface HTSecurityRSA : HTSecurity
/**
 *  加载公钥
 *
 *  @param filePath 公钥文件路径
 */
-(void)loadPublicKeyFromFile: (NSString*) filePath;
/**
 *  加载公钥
 *
 *  @param data 公钥文件的二进制流
 */
-(void)loadPublicKeyFromData: (NSData*) data;
/**
 *  加载私钥
 *
 *  @param filePath 私钥文件路径
 *  @param password 私钥密码
 */
-(void)loadPrivateKeyFromFile: (NSString*) filePath password:(NSString*)password;
/**
 *  加载私钥
 *
 *  @param data     私钥文件的二进制流
 *  @param password 私钥密码
 */
-(void)loadPrivateKeyFromData: (NSData*) data password:(NSString*)password;
@end


/**
 *  AES算法
 */
@interface HTSecurityAES : HTSecurity
@end

/**
 *  AES128算法
 */
@interface HTSecurityAES128 : HTSecurityAES
@end

/**
 *  AES256算法
 */
@interface HTSecurityAES256 : HTSecurityAES
@end

/**
 *  DES算法
 */
@interface HTSecurityDES : HTSecurity
@end

/**
 *  3DES算法
 */
@interface HTSecurity3DES : HTSecurityDES
@end


@implementation HTSecurity

+ (instancetype)security:(NSString *)type {
    if ([@"md5" isEqualToString:[type lowercaseString]]) {
        return [HTSecurity des];
    } else if ([@"base64" isEqualToString:[type lowercaseString]]) {
        return [HTSecurity base64];
    } else if ([@"rsabc" isEqualToString:[type lowercaseString]]) {
        return [HTSecurity rsa];
    } else if ([@"aes" isEqualToString:[type lowercaseString]]) {
        return [HTSecurity aes];
    } else if ([@"desede" isEqualToString:[type lowercaseString]]) {
        return [HTSecurity des];
    } else {
        return [HTSecurity null];
    }
}
/**
 *  单例
 */
+ (instancetype)security {
    static id _security = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _security = [[HTSecurity alloc] init];
    });
    return _security;
}

+ (instancetype)null {
    return [HTSecurity security];
}
+ (instancetype)md5 {
    return [HTSecurityMd5 security];
}
+ (instancetype)base64 {
    return [HTSecurityBase64 security];
}
+ (instancetype)rsa {
    return [HTSecurityRSA security];
}
+ (instancetype)aes {
    return [HTSecurityAES128 security];
}
+ (instancetype)des {
    return [HTSecurity3DES security];
}

- (NSString*)encrypt:(NSString*)plaintext {
    return plaintext;
}
- (NSString *)encrypt:(NSString *)plaintext key:(NSString *)key {
    return plaintext;
}
- (NSString*)decrypt:(NSString*)securtext {
    return securtext;
}
- (NSString *)decrypt:(NSString *)securtext key:(NSString *)key {
    return securtext;
}

- (NSData *)encrypt2:(NSData *)data {
    return data;
}
- (NSData *)decrypt2:(NSData *)data {
    return data;
}
- (NSData *)encrypt2:(NSData *)data key:(NSData*)key {
    return data;
}
- (NSData *)decrypt2:(NSData *)data key:(NSData*)key {
    return data;
}

- (NSString *)randomKey {
    if (self.keySize > 0) {
        return [HTUtils data2Hex:[[HTUtils randomString:self.keySize] dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        return nil;
    }
}
@end

@implementation HTSecurityMd5
+ (instancetype)security {
    static id _security = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _security = [[HTSecurityMd5 alloc] init];
    });
    return _security;
}
- (NSString *)defaultKey {
    return MD5_KEY;
}
- (NSString *)encrypt:(NSString *)plaintext {
    return [self encrypt:plaintext key:self.defaultKey];
}

- (NSString *)encrypt:(NSString *)plaintext key:(NSString*)key {
    if (plaintext.length > 0) {
        const char *origtext = [[key stringByAppendingString:plaintext] UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5(origtext, (CC_LONG)strlen(origtext), digest);
        NSMutableString *hash = [NSMutableString string];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
            [hash appendFormat:@"%02X", digest[i]];
        return [hash uppercaseString];
    } else {
        return plaintext;
    }
}
- (NSData *)encrypt2:(NSData *)data {
    return [self encrypt2:data key:[self.defaultKey dataUsingEncoding:NSUTF8StringEncoding]];
}
- (NSData *)encrypt2:(NSData *)data key:(NSData*)key {
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *keystr = [[NSString alloc]initWithData:key  encoding:NSUTF8StringEncoding];
    NSString *result = [self encrypt:string key:keystr];
    return [result dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)decrypt:(NSString *)securtext {
    [self doesNotRecognizeSelector:@selector(decrypt:)];
    return nil;
}
- (NSString *)decrypt:(NSString *)securtext key:(NSString *)key {
    [self doesNotRecognizeSelector:@selector(decrypt:key:)];
    return nil;
}
- (NSData *)decrypt2:(NSData *)data {
    [self doesNotRecognizeSelector:@selector(decrypt2:)];
    return nil;
    
}
- (NSData *)decrypt2:(NSData *)data key:(NSData *)key {
    [self doesNotRecognizeSelector:@selector(decrypt2:key:)];
    return nil;
}
- (NSString *)name {
    return @"MD5";
}
@end

@implementation HTSecurityBase64
+ (instancetype)security {
    static id _security = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _security = [[HTSecurityBase64 alloc] init];
    });
    return _security;
}
- (NSString *)encrypt:(NSString *)plaintext {
    return [self encrypt:plaintext key:self.defaultKey];
}
- (NSString *)encrypt:(NSString *)plaintext key:(NSString *)key {
    return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
}
- (NSString *)decrypt:(NSString *)securtext {
    return [self decrypt:securtext key:self.defaultKey];
}
- (NSString *)decrypt:(NSString *)securtext key:(NSString *)key {
    if (securtext) {
        NSData* data = [[NSData alloc] initWithBase64Encoding:securtext];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        return securtext;
    }
    
}

- (NSData *)encrypt2:(NSData *)data {
    return [self encrypt2:data key:nil];
}
- (NSData *)decrypt2:(NSData *)data {
    return [self decrypt2:data key:nil];
}
- (NSData *)encrypt2:(NSData *)data key:(NSData*)key {
    return [[data base64Encoding] dataUsingEncoding:NSUTF8StringEncoding];
}
- (NSData *)decrypt2:(NSData *)data key:(NSData*)key {
    return [[NSData alloc]initWithBase64Encoding:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
}

- (int)keySize {
    return 10;
}
- (NSString *)name {
    return @"BASE64";
}
@end

@interface HTSecurityRSA()
@property (nonatomic) SecKeyRef publicKey;
@property (nonatomic) SecKeyRef privateKey;
@end

@implementation HTSecurityRSA
+ (instancetype)security {
    static id _security = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _security = [[HTSecurityRSA alloc] init];
    });
    return _security;
}
- (SecKeyRef)publicKey {
    if (!_publicKey) {
        NSString *keyFilePath = [[NSBundle mainBundle] pathForResource:[HTConfigUtils getValue:kHTSecuritRsaPublicKey] ofType:nil];
        [self loadPublicKeyFromFile:keyFilePath];
    }
    return _publicKey;
}
- (SecKeyRef)privateKey {
    if (!_privateKey) {
        NSString *keyFilePath = [[NSBundle mainBundle] pathForResource:[HTConfigUtils getValue:kHTSecuritRsaPrivateKey] ofType:nil];
        NSString *keyPassword = [HTConfigUtils getValue:kHTSecuritRsaPrivatePasswordKey shouldDecrypt:YES];
        [self loadPrivateKeyFromFile:keyFilePath password:keyPassword];
    }
    return _privateKey;
}
- (void)loadPublicKeyFromFile:(NSString *)filePath {
    [self loadPublicKeyFromData:[[NSData alloc]initWithContentsOfFile:filePath]];
}
- (void)loadPublicKeyFromData:(NSData *)data {
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)data);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        SecTrustEvaluate(myTrust, &trustResult);
    }
    SecKeyRef securityKey = SecTrustCopyPublicKey(myTrust);
    CFRelease(myCertificate);
    CFRelease(myPolicy);
    CFRelease(myTrust);
    _publicKey = securityKey;
}
- (void)loadPrivateKeyFromFile:(NSString *)filePath password:(NSString *)password {
    [self loadPrivateKeyFromData:[[NSData alloc]initWithContentsOfFile:filePath] password:password];
}
- (void)loadPrivateKeyFromData:(NSData *)data password:(NSString *)password {
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject:password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) data,
                                             (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp =
        (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                             kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    self.privateKey = privateKeyRef;
}
- (NSString *)encrypt:(NSString *)plaintext {
    return [self encrypt:plaintext key:self.defaultKey];
}

- (NSString *)encrypt:(NSString *)plaintext key:(NSString *)key {
    return [[self encrypt2:[plaintext dataUsingEncoding:NSUTF8StringEncoding]] base64Encoding];
}
- (NSString *)decrypt:(NSString *)securtext {
    return [self decrypt:securtext key:self.defaultKey];
}
- (NSString *)decrypt:(NSString *)securtext key:(NSString *)key {
    NSData *decryptedData = [self decrypt2:[[NSData alloc]initWithBase64Encoding:securtext]];
    NSString* result = [[NSString alloc] initWithData: decryptedData encoding:NSUTF8StringEncoding];
    return result;
}
- (NSData *)encrypt2:(NSData *)data {
    return [self encrypt2:data key:[HTUtils hex2data:self.defaultKey]];
}
- (NSData *)decrypt2:(NSData *)data {
    return [self decrypt2:data key:[HTUtils hex2data:self.defaultKey]];
}
- (NSData *)encrypt2:(NSData *)data key:(NSData*)key {
    if (data.length > 0) {
        return [self encWithData:data usePrivateKey:NO];
    }
    return data;
}
- (NSData *)decrypt2:(NSData *)data key:(NSData*)key {
    if (data.length > 0) {
        return [self decWithData:data usePrivateKey:YES];
    }
    return data;
}
- (NSData *)encWithData:(NSData *)data usePrivateKey:(BOOL)isPriv {
    SecKeyRef key = isPriv ? self.privateKey : self.publicKey;
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    size_t blockSize = cipherBufferSize - 11;       // 分段加密
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init] ;
    for (int i=0; i<blockCount; i++) {
        long bufferSize = MIN(blockSize,[data length] - i * blockSize);
        NSData *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes], [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer){
        free(cipherBuffer);
    }
    return encryptedData;
}
- (NSData *)decWithData:(NSData *)data usePrivateKey:(BOOL)isPriv {
    SecKeyRef key = isPriv ? self.privateKey : self.publicKey;
    size_t cipherLen = [data length];
    void *cipher = malloc(cipherLen);
    [data getBytes:cipher length:cipherLen];
    size_t plainLen = SecKeyGetBlockSize(key) - 12;
    void *plain = malloc(plainLen);
    OSStatus status = SecKeyDecrypt(key, kSecPaddingPKCS1, cipher, cipherLen, plain, &plainLen);
    
    NSData *decryptedData = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
    free(cipher);
    free(plain);
    if (status != noErr) {
        return nil;
    }
    return decryptedData;
}
- (NSString *)name {
    return @"RSABC";
}
@end

@implementation HTSecurityAES
+ (instancetype)security {
    static id _security = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _security = [[HTSecurityAES alloc] init];
    });
    return _security;
}

- (int)keySize {
    return kCCKeySizeAES256;
}

//32位的key： { 0x08, 0x08, 0x04, 0x0b, 0x02, 0x0f, 0x0b, 0x0c, 0x01, 0x03, 0x09, 0x07, 0x0c, 0x03, 0x07, 0x0a, 0x04, 0x0f, 0x06, 0x0f, 0x0e, 0x09, 0x05, 0x01, 0x0a, 0x0a, 0x01, 0x09, 0x06, 0x07, 0x09, 0x0d }
- (NSString *)defaultKey {
    return AES256_KEY;
}

- (NSString *)encrypt:(NSString *)plaintext {
    return [self encrypt:plaintext key:self.defaultKey];
}
- (NSString *)encrypt:(NSString *)plaintext key:(NSString *)key {
    NSData *result = [self encrypt2:[plaintext dataUsingEncoding:NSUTF8StringEncoding] key:[HTUtils hex2data:key]];
    return [HTUtils data2Hex:result];
}
- (NSString *)decrypt:(NSString *)securtext {
    return [self decrypt:securtext key:self.defaultKey];
}
- (NSString *)decrypt:(NSString *)securtext key:(NSString *)key {
    NSData *result = [self decrypt2:[HTUtils hex2data:securtext] key:[HTUtils hex2data:key]];
    return [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
}
- (NSData *)encrypt2:(NSData *)data {
    return [self encrypt2:data key:[HTUtils hex2data:self.defaultKey]];
}
- (NSData *)decrypt2:(NSData *)data {
    return [self decrypt2:data key:[HTUtils hex2data:self.defaultKey]];
}

- (NSData *)encrypt2:(NSData*)data key:(NSData *)key {
    if (!data) {
        NSLog(@"WARN: encrypt data is nil.");
        return nil;
    }
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key bytes],
                                          self.keySize,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
- (NSData *)decrypt2:(NSData*)data key:(NSData *)key {
    if (!data) {
        NSLog(@"WARN: encrypt data is nil.");
        return nil;
    }
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key bytes],
                                          self.keySize,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

- (NSString *)name {
    return @"AES";
}

@end

@implementation HTSecurityAES128
+ (instancetype)security {
    static id _security = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _security = [[HTSecurityAES128 alloc] init];
    });
    return _security;
}


- (int)keySize {
    return kCCKeySizeAES128;
}

//16位的key： {69, -35, -53, -45, 23, 106, 60, 49, -40, 58, 62, -75, 96, -9, 12, 101}
- (NSString *)defaultKey {
    return AES128_KEY;
}

@end

@implementation HTSecurityAES256
+ (instancetype)security {
    static id _security = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _security = [[HTSecurityAES256 alloc] init];
    });
    return _security;
}


- (int)keySize {
    return kCCKeySizeAES256;
}
//16位的key： {69, -35, -53, -45, 23, 106, 60, 49, -40, 58, 62, -75, 96, -9, 12, 101}
- (NSString *)defaultKey {
    return AES256_KEY;
}
- (NSString *)name {
    return @"AES256";
}
@end

@implementation HTSecurityDES
+ (instancetype)security {
    static id _security = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _security = [[HTSecurityDES alloc] init];
    });
    return _security;
}
- (int)keySize {
    return kCCKeySizeDES;
}
- (NSString *)defaultKey {
    return DESEDE_KEY;
}
- (CCOperation)alogrithm {
    return kCCAlgorithmDES;
}

- (NSString *)name {
    return @"DES";
}
- (NSString *)encrypt:(NSString *)plaintext {
    return [self encrypt:plaintext key:self.defaultKey];
}
- (NSString *)encrypt:(NSString *)plaintext key:(NSString *)key {
    NSData *result = [self encrypt2:[plaintext dataUsingEncoding:NSUTF8StringEncoding] key:[HTUtils hex2data:key]];
    return [HTUtils data2Hex:result];
}
- (NSString *)decrypt:(NSString *)securtext {
    return [self decrypt:securtext key:self.defaultKey];
}
- (NSString *)decrypt:(NSString *)securtext key:(NSString *)key {
    NSData *result = [self decrypt2:[HTUtils hex2data:securtext] key:[HTUtils hex2data:key]];
    return [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
}
- (NSData *)encrypt2:(NSData *)data {
    return [self encrypt2:data key:[HTUtils hex2data:self.defaultKey]];
}
- (NSData *)decrypt2:(NSData *)data {
    return [self decrypt2:data key:[HTUtils hex2data:self.defaultKey]];
}

- (NSData *) encrypt2:(NSData *)data key:(NSData *)key {
    return [self encryptor:kCCEncrypt data:data key:key];
}
- (NSData *) decrypt2:(NSData *)data key:(NSData *)key {
    return [self encryptor:kCCDecrypt data:data key:key];
}

- (NSData *)encryptor:(CCOperation)op data:(NSData*)data key:(NSData *)key {
    if (!data) {
        NSLog(@"WARN: encrypt data is nil.");
        return nil;
    }
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + self.keySize;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(op,
                                          [self alogrithm],
                                          kCCOptionPKCS7Padding,
                                          [key bytes],
                                          self.keySize,
                                          DES_IV,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    NSData *result;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
    }
    free(buffer);
    return result;
}

@end

@implementation HTSecurity3DES
+ (instancetype)security {
    static id _security = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _security = [[HTSecurity3DES alloc] init];
    });
    return _security;
}

- (int)keySize {
    return kCCKeySize3DES;
}
- (NSString *)name {
    return @"DESEDE";
}
- (NSString *)defaultKey {
    return DESEDE_KEY;
}
- (CCOperation)alogrithm {
    return kCCAlgorithm3DES;
}

@end

@implementation NSString (HTSecurity)
- (NSString *)md5 {
    return [[HTSecurity md5] encrypt:self];
}
- (NSString *)base64enc {
    return [[HTSecurity base64] encrypt:self];
}
- (NSString *)base64dec {
    return [[HTSecurity base64] decrypt:self];
}
- (NSString *)aesenc {
    return [[HTSecurity aes] encrypt:self];
}
- (NSString *)aesdec {
    return [[HTSecurity aes] decrypt:self];
}
- (NSString *)rsaenc {
    return [[HTSecurity rsa] encrypt:self];
}
- (NSString *)rsadec {
    return [[HTSecurity rsa] decrypt:self];
}
- (NSString *)desenc {
    return [[HTSecurity des] encrypt:self];
}
- (NSString *)desdec {
    return [[HTSecurity des] decrypt:self];
}

@end
