//
//  HTConfigUtils.m
//  HTLib
//
//  Created by jonay on 15/1/6.
//  Copyright (c) 2015年 huateng. All rights reserved.
//

#import "HTConfigUtils.h"
#import "HTSecurity.h"
static NSString *const kConfigFile = @"config.plist";
static NSString *const kConfigSplitDot = @".";

@interface HTConfigUtils()
@property (nonatomic) NSDictionary *datas;

@end

@implementation HTConfigUtils

+ (NSDictionary *)config {
    static NSDictionary *_config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* path = [[NSBundle mainBundle]pathForResource:kConfigFile ofType:nil];
        _config = [[NSDictionary alloc]initWithContentsOfFile:path];
    });
    

    return _config;
}

+ (id)getValue:(NSString *)key {
    id value = nil;
    NSArray *keyArr = [key componentsSeparatedByString:kConfigSplitDot];
    value = [[self config] objectForKey:[keyArr firstObject]];
    if (keyArr.count > 1) {
        for (int i = 1; i < keyArr.count; i++) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                value = [value objectForKey:keyArr[i]];
            } else {
                return nil;
            }
        }
    }
    return value;
}
+ (id)getValue:(NSString *)key shouldDecrypt:(BOOL)shouldDecrypt {
    NSString *text = [HTConfigUtils getValue:key];
    if (shouldDecrypt) {
        return [text aesdec];
    }
    return text;
}
- (HTConfigUtils *)initWithContentsOfFile:(NSString *)resource {
    NSString* path = [[NSBundle mainBundle]pathForResource:resource ofType:nil];
    HTConfigUtils *utils = [[HTConfigUtils alloc] init];
    utils.datas = [[NSDictionary alloc] initWithContentsOfFile:path];
    return utils;
}
- (id)getValue:(NSString *)key {
    id value = nil;
    NSArray *keyArr = [key componentsSeparatedByString:kConfigSplitDot];
    value = [self.datas objectForKey:[keyArr firstObject]];
    if (keyArr.count > 1) {
        for (int i = 1; i < keyArr.count; i++) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                value = [value objectForKey:keyArr[i]];
            } else {
                return nil;
            }
        }
    }
    return value;
}
- (id)getValue:(NSString *)key shouldDecrypt:(BOOL)shouldDecrypt {
    NSString *text = [self getValue:key];
    if (shouldDecrypt) {
        return [text aesdec];
    }
    return text;
}
@end
