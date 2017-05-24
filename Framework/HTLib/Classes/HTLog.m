//
//  HTLog.m
//  HTLib
//
//  Created by jonay on 15/1/12.
//  Copyright (c) 2015年 huateng. All rights reserved.
//

#import "HTLog.h"
#import "HTConfigUtils.h"

static NSDateFormatter* logDateFormatter = nil;
static NSInteger LOG_LEVEL = -1;
static HTLogLevel DEFAULT_LOG_LEVEL = HTLogLevelInfo;

#define HTLOG_LEVEL_NAMES @[@"DEBUG",@"INFO",@"WARN",@"ERROR"]
#define HTLOG_DATE_PATTERN @"yyyy-MM-dd HH:mm:ss.SSS"

@implementation HTLog


+ (void)logger:(const char *)file lineNumber:(int)lineNumber functionName:(const char *)functionName format:(NSString *)format, ... {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logDateFormatter = [[NSDateFormatter alloc]init];
        [logDateFormatter setDateFormat:HTLOG_DATE_PATTERN];
    });
    
    const char *dateCString = [[logDateFormatter stringFromDate:[NSDate date]]UTF8String];
    const char *fileCString = file;
    
    // 处理format
    va_list ap;
    va_start (ap, format);
    NSString *logString = [[NSString alloc] initWithFormat:format arguments:ap];
    const char *logCString = [logString UTF8String];
    va_end (ap);
    
    NSArray *arr = [logString componentsSeparatedByString:@":"];
    NSString *prefix = [[arr firstObject] uppercaseString];
    NSUInteger index = [HTLOG_LEVEL_NAMES indexOfObject:prefix];
    HTLogLevel level;
    if (index == NSNotFound) {
        level = DEFAULT_LOG_LEVEL;
    } else {
        level = index + 1;
    }
    
    FILE * appender = stdout;
    if (level == HTLogLevelError) {
        appender = stderr;
    }
    
    if (level > [HTLog level]) {
        //2014-01-01 12:12:12 <Main.h:10> INFO:this is a info log
        fprintf(appender, "%s <%s:%d> %s\n", dateCString, fileCString, lineNumber, logCString);
    }
}

+ (HTLogLevel)level {
    if (LOG_LEVEL < 0) {
        id logLevel = [HTConfigUtils getValue:kHTLogLevel];
        if ([logLevel isKindOfClass:[NSString class]]) {
            NSUInteger index = [HTLOG_LEVEL_NAMES indexOfObject:[logLevel uppercaseString]];
            if (index == NSNotFound) {
                LOG_LEVEL = DEFAULT_LOG_LEVEL;
            } else {
                LOG_LEVEL = index;
            }
        } else if ([logLevel isKindOfClass:[NSNumber class]]) {
            LOG_LEVEL = MAX([logLevel integerValue], HTLogLevelAll);
        } else {
            LOG_LEVEL = DEFAULT_LOG_LEVEL;
        }
    }
    
    return LOG_LEVEL;
}
@end