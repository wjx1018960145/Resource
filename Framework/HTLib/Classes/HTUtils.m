//
//  HTUtils.m
//  HTLib
//
//  Created by jonay on 14/12/29.
//  Copyright (c) 2014年 huateng. All rights reserved.
//

#import "HTUtils.h"
#import "HTLog.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>
#import <UIKit/UIApplication.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <sys/types.h>
#import <sys/sysctl.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>




static NSString *const kHasLanuchedTag = @"_firstLanuchTag_";

@implementation HTUtils

+ (NSDictionary*)systemInfo{
    UIDevice *device = [UIDevice currentDevice];
    //软件信息
    NSString *sysName       = [device systemName];
    NSString *sysVersion    = [device systemVersion];
    
    //硬件信息
    NSString *devIdentifer  = [[device identifierForVendor] UUIDString];
    NSString *devModel      = [device model];
    NSString *devName       = [device name];
    
    //CPU信息
    size_t cpusize;
    cpu_type_t type;
    cpu_subtype_t subtype;
    cpusize = sizeof(type);
    sysctlbyname("hw.cputype", &type, &cpusize, NULL, 0);
    
    cpusize = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &cpusize, NULL, 0);
    
    NSString *cpuType;
    if (type == CPU_TYPE_X86) {
        cpuType = [NSString stringWithFormat:@"x86, Type:%d", subtype];
    } else if (type == CPU_TYPE_ARM) {
        cpuType = [NSString stringWithFormat:@"ARM, Type:%d", subtype];
    } else {
        cpuType = @"unkown.";
    }
    
    
    
    //内存信息
    size_t size = sizeof(int);
    int totalMemory;
    int mib[2] = {CTL_HW, HW_PHYSMEM};
    sysctl(mib, 2, &totalMemory, &size, NULL, 0);
    NSNumber *memoryTotal = [NSNumber numberWithInt:totalMemory];
    
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    unsigned long usedMemory = kernReturn != KERN_SUCCESS ? NSNotFound : taskInfo.resident_size;
    NSNumber *memoryUsed = [NSNumber numberWithLong:usedMemory];
    
    //电池信息
    device.batteryMonitoringEnabled = YES;
    CGFloat batteryLevel      = [[UIDevice currentDevice] batteryLevel];
    NSNumber *battery       = [NSNumber numberWithFloat:batteryLevel];
    
    //程序信息
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    
    NSMutableDictionary *systemInfo = [NSMutableDictionary dictionaryWithDictionary:infoPlist];
    [systemInfo setObject:sysName       forKey:kHTSystemInfoSysNameKey];
    [systemInfo setObject:sysVersion    forKey:kHTSystemInfoSysVersionKey];
    [systemInfo setObject:devIdentifer  forKey:kHTSystemInfoDevIdentifierKey];
    [systemInfo setObject:devModel      forKey:kHTSystemInfoDevModelKey];
    [systemInfo setObject:devName       forKey:kHTSystemInfoDevNameKey];
    [systemInfo setObject:cpuType       forKey:kHTSystemInfoCPUTypeKey];
    [systemInfo setObject:memoryTotal   forKey:kHTSystemInfoMemoryTotalKey];
    [systemInfo setObject:memoryUsed    forKey:kHTSystemInfoMemoryUsedKey];
    [systemInfo setObject:battery       forKey:kHTSystemInfoBatteryKey];

    
    return systemInfo;
}

+ (BOOL)isApplicationFirstLanuch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:kHasLanuchedTag]) {
        return NO;
    } else {
        [defaults setBool:YES forKey:kHasLanuchedTag];
        return YES;
    }
}

+ (NSString *)pathOf:(HTDirectoryPath)type {
    switch (type) {
        case HTDirectoryPathHome:
            return NSHomeDirectory();
        case HTDirectoryPathDocuments:
            return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        case HTDirectoryPathCaches:
            return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        case HTDirectoryPathTmp:
            return NSTemporaryDirectory();
        default:
            break;
    }
    return nil;
}
+ (NSString *)pathOfResource:(NSString *)filename {
    return [[NSBundle mainBundle] pathForResource:filename ofType:nil];
}
+ (NSString *)pathOfResource:(NSString *)filename bundleName:(NSString *)bundleName {
    NSString *resBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    return [[NSBundle bundleWithPath:resBundlePath] pathForResource:filename ofType:nil];
}

+ (NSString *)formatDate:(NSDate *)date pattern:(HTDatePattern)pattern {
    NSDateFormatter *simleDateFormater = [[NSDateFormatter alloc] init];
    switch (pattern) {
        case HTDatePattern8:
            [simleDateFormater setDateFormat:@"yyyyMMdd"];
            break;
        case HTDatePattern10:
            [simleDateFormater setDateFormat:@"yyyy-MM-dd"];
            break;
        case HTDatePattern14:
            [simleDateFormater setDateFormat:@"yyyyMMddHHmmss"];
            break;
        case HTDatePattern19:
            [simleDateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        default:
            [simleDateFormater setDateFormat:@"yyyyMMdd"];
            break;
    }
    return [simleDateFormater stringFromDate:[NSDate date]];
}

+ (NSString *)currentDate:(HTDatePattern)pattern {
    return [HTUtils formatDate:[NSDate date] pattern:pattern];
}

+ (NSString *)formatCurrency:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *string = [formatter stringFromNumber: number];
    return string;
}

+ (NSString *)chineseCurrency:(NSNumber *)number {
    NSMutableString *moneyString=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f", number.doubleValue]];
    NSArray *mChineseUnit=@[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟"];
    NSArray *mChineseNum=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    NSMutableString *chineseMoney=[[NSMutableString alloc] init];
    [moneyString deleteCharactersInRange:NSMakeRange([moneyString rangeOfString:@"."].location, 1)];
    for(NSInteger i = moneyString.length; i > 0; i--) {
        NSInteger num=[[moneyString substringWithRange:NSMakeRange(moneyString.length-i, 1)] integerValue];
        [chineseMoney appendString:mChineseNum[num]];
        if([[moneyString substringFromIndex:moneyString.length-i+1] integerValue]==0&&i!=1&&i!=2) {
            [chineseMoney appendString:@"元整"];
            break;
        }
        [chineseMoney appendString:mChineseUnit[i-1]];
    }
    return chineseMoney;
}

+ (NSData *)image2Data:(UIImage *)image {
    if (UIImagePNGRepresentation(image) == nil) {
        return UIImageJPEGRepresentation(image, 1);
    } else {
        return UIImagePNGRepresentation(image);
    }
}
+ (NSString *)image2base64:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    return [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64Encoding]];
}

+ (NSString *)data2Hex:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSMutableString *str = [NSMutableString stringWithCapacity:data.length * 2];
    for (int i=0; i < data.length; i++){
        [str appendFormat:@"%02x", bytes[i]];
    }
    return str;
}

+ (NSData *)hex2data:(NSString *)hex {
    NSMutableData *data = [NSMutableData dataWithCapacity:hex.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < hex.length / 2; i++) {
        byte_chars[0] = [hex characterAtIndex:i*2];
        byte_chars[1] = [hex characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
    
//    
//    int j = 0;
//    Byte bytes[hex.length/2];
//    for(int i = 0;i < [hex length]; i++) {
//        int int_ch;  /// 两位16进制数转化后的10进制数
//        unichar hex_char1 = [hex characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
//        int int_ch1;
//        if(hex_char1 >= '0' && hex_char1 <='9')
//            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
//        else
//            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
//        i++;
//        
//        unichar hex_char2 = [hex characterAtIndex:i]; ///两位16进制数中的第二位(低位)
//        int int_ch2;
//        if(hex_char2 >= '0' && hex_char2 <='9')
//            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch2 = hex_char2-55; //// A 的Ascll - 65
//        else
//            int_ch2 = hex_char2-87; //// a 的Ascll - 97
//        
//        int_ch = int_ch1+int_ch2;
//        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
//        j++;
//    }
//    return [[NSData alloc] initWithBytes:bytes length:hex.length/2];
}

+ (NSString *)formatString:(NSString *)string, ...{
    NSMutableArray *params = [NSMutableArray array];
    va_list args;
    va_start(args, string);
    id param;
    while ((param = va_arg(args, id))) {
        [params addObject:param];
    }
    va_end(args);
    return [self formatString:string args:params];
}
+ (NSString *)formatString:(NSString *)string args:(NSArray *)args {
    NSString *result = string;
    if ([string length] > 0) {
        for (int i = 0; i < args.count; i++) {
            result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%d}", i] withString:[NSString stringWithFormat:@"%@", args[i]]];
        }
    }
    return result;
}

+ (NSString *)mimeTypeOfExtension:(NSString *)extension {
#ifdef __UTTYPE__
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
#else
    return @"application/octet-stream";
#endif
}


+ (NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (__bridge NSString *)(uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}





+ (NSString *)randomString:(NSInteger)length {
    char data[length];
    for (int x = 0; x < length; data[x++] = (char)(32 + (arc4random_uniform(94)))){
    };
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}
@end

@implementation NSString (HTUtils)
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (NSUInteger)indexOf:(NSString *)str {
    return [self indexOf:str caseInsensitive:NO];
}
- (NSUInteger)indexOf:(NSString *)str caseInsensitive:(BOOL)caseInsensitive {
    NSRange range = caseInsensitive ? [self rangeOfString:str options:NSCaseInsensitiveSearch] : [self rangeOfString:str];
    if (range.length > 0) {
        return range.location;
    }
    return -1;
}

@end

@implementation NSData (HTUtils)

- (NSString *)stringUsingEncoding:(NSStringEncoding)encoding {
    return [[NSString alloc] initWithData:self encoding:encoding];
}

@end

@implementation UIColor (HTUtils)

+ (UIColor *)randomColor {
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom(time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end