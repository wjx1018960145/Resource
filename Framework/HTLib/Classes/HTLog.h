//
//  HTLog.h
//  HTLib
//
//  Created by jonay on 15/1/12.
//  Copyright (c) 2015年 huateng. All rights reserved.
//

#import <Foundation/Foundation.h>
///**
// *  日志输出，NSLog扩展
// *
// *  @param file         所属文件
// *  @param lineNumber   行号
// *  @param functionName 方法名称
// *  @param format       字符串
// *  @param ...          参数
// */
//void HTLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

#ifdef DEBUG
#define NSLog(args ...) [HTLog logger:[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String] lineNumber:__LINE__ functionName:__func__ format:args];
#else
#define NSLog(args ...) nil
#endif


typedef NS_ENUM(NSInteger, HTLogLevel) {
    HTLogLevelAll,
    HTLogLevelDebug,
    HTLogLevelInfo,
    HTLogLevelWarn,
    HTLogLevelError,
    HTLogLevelNone
};
/**
 *  NSLog扩展
 *  @discussion 日志输出级别：DEBUG、INFO、WARN、ERROR，默认INFO。书写方式：[级别]:日志，如 NSLog(@"ERROR: this is an error")
 */
@interface HTLog : NSObject
/**
 *  日志输出
 *
 *  @param file         所属文件
 *  @param lineNumber   行号
 *  @param functionName 方法名称
 *  @param format       字符串
 *  @param ...          参数
 */
+ (void)logger:(const char *)file lineNumber:(int)lineNumber functionName:(const char *)functionName format:(NSString *)format, ...NS_FORMAT_FUNCTION(4,5);
@end