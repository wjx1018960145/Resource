//
//  HTUtils.h
//  HTLib
//
//  Created by jonay on 14/12/29.
//  Copyright (c) 2014年 huateng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 系统名字 */
static NSString *const kHTSystemInfoSysNameKey          = @"systemName";                //iPhone OS
/** 系统版本 */
static NSString *const kHTSystemInfoSysVersionKey       = @"systemVersion";             //8.1

/** 设备标识 */
static NSString *const kHTSystemInfoDevIdentifierKey    = @"identifierForVendor";       //A86970E2-A2FF-4711-9991-19FF523B8F8E
/** 设备名称 */
static NSString *const kHTSystemInfoDevNameKey          = @"name";                      //iPhone Simulator
/** 设备类型 */
static NSString *const kHTSystemInfoDevModelKey         = @"model";                     //iPhone Simulator

/** CPU类型 */
static NSString *const kHTSystemInfoCPUTypeKey          = @"cpuType";                   //x86

/** 总内存 */
static NSString *const kHTSystemInfoMemoryTotalKey      = @"totalMemory";               //1024 bytes
/** 已用内存 */
static NSString *const kHTSystemInfoMemoryUsedKey       = @"userMemory";                //1024 bytes
/** 电量 */
static NSString *const kHTSystemInfoBatteryKey          = @"batteryLevel";              //0.5

/** 应用名称 */
static NSString *const kHTSystemInfoAppNameKey          = @"CFBundleName";              //Test
/** 应用版本 */
static NSString *const kHTSystemInfoAppVersionKey       = @"CFBundleVersion";           //1.0.0.0
/** 应用标识 */
static NSString *const kHTSystemInfoAppIdentifierKey    = @"CFBundleIdentifier";        //com.huateng.ios.Test
/**
 *  系统目录类别
 */
typedef NS_ENUM(NSInteger, HTDirectoryPath){
    /**
     *  沙盒主目录
     */
    HTDirectoryPathHome,
    /**
     *  Documents目录
     */
    HTDirectoryPathDocuments,
    /**
     *  Caches目录
     */
    HTDirectoryPathCaches,
    /**
     *  Tmp目录
     */
    HTDirectoryPathTmp
};
/**
 *  日期格式
 */
typedef NS_ENUM(NSInteger, HTDatePattern){
    /**
     *  yyyyMMdd
     */
    HTDatePattern8,
    /**
     *  yyyy-MM-dd
     */
    HTDatePattern10,
    /**
     *  yyyyMMddHHmmss
     */
    HTDatePattern14,
    /**
     *  yyyy-MM-dd HH:mm:ss
     */
    HTDatePattern19
};

/**
 *  网络监听
 *
 *  @param available 网络是否可用
 */
typedef void (^NetworkStatusListener)(BOOL available);

#define HTReachability id

/**
 *  工具类
 */
@interface HTUtils : NSObject

/**
 *  获取系统信息，如设备信息，版本信息等
 *  @discussion key值可参考以kHTSystemInfo打头的常量
 *
 *  @return 所有信息
 */
+ (NSDictionary*)systemInfo;

/**
 *  是否第一次运行该应用
 *
 *  @return YES/NO
 */
+ (BOOL)isApplicationFirstLanuch;
/**
 *  系统常用目录
 *
 *  @param type 目录类型
 *
 *  @return 目录路径
 */
+ (NSString*)pathOf:(HTDirectoryPath)type;
/**
 *  当前工程下的资源路径
 *
 *  @param filename 资源文件名称
 *
 *  @return 路径
 */
+ (NSString*)pathOfResource:(NSString*)filename;
/**
 *  获取bundle中的资源路径
 *
 *  @param filename   资源文件名称
 *  @param bundleName 资源包名,不需要后缀.bundle
 *
 *  @return 路径
 */
+ (NSString *)pathOfResource:(NSString *)filename bundleName:(NSString *)bundleName;

/**
 *  格式化日期
 *
 *  @param date    日期
 *  @param pattern 格式
 *
 *  @return 字符串
 */
+ (NSString *)formatDate:(NSDate *)date pattern:(HTDatePattern)pattern;

/**
 *  当前时间
 *
 *  @param pattern 格式
 *
 *  @return 当前日期字符串
 */
+ (NSString *)currentDate:(HTDatePattern)pattern;

/**
 *  将数字格式成货币格式
 *
 *  @param number 数字
 *
 *  @return 货币格式的字符串
 */
+ (NSString *)formatCurrency:(NSNumber *)number;

/**
 *  将数字转换成大写人民币
 *
 *  @param number 数字
 *
 *  @return 大写人民币
 */
+ (NSString *)chineseCurrency:(NSNumber *)number;
/**
 *  将图片转换成二进制
 *
 *  @param image 图片
 *
 *  @return 二进制
 */
+ (NSData *)image2Data:(UIImage *)image;
/**
 *  将图片转换成base64
 *
 *  @param image 图片
 *
 *  @return base64字符串
 */
+ (NSString *)image2base64:(UIImage *)image;

/**
 *  将二进制数据转换成十六进制字符串
 *
 *  @param data 二进制数据
 *
 *  @return 十六进制字符串
 */
+ (NSString *)data2Hex:(NSData *)data;
/**
 *  将十六进制字符串转换成二进制数据
 *
 *  @param hex 十六进制字符串
 *
 *  @return 二进制数据
 */
+ (NSData *)hex2data:(NSString *)hex;

/**
 *  格式化字符串
 *  @discussion 字符串占位符为 {数字},如 hello {0}
 *
 *  @param string 字符串
 *  @param ...    参数，必须是NSObject对象，不能是int等简单类型
 *
 *  @return 字符串
 */
+ (NSString *)formatString:(NSString *)string, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  格式化字符串
 *  @discussion 字符串占位符为 {数字},如 hello {0}
 *
 *  @param string 字符串
 *  @param args   参数
 *
 *  @return 字符串
 */
+ (NSString *)formatString:(NSString *)string args:(NSArray *)args;

/**
 *  获取媒体类型
 *
 *  @param extension 文件扩展名
 *
 *  @return 媒体类型
 */
+ (NSString *)mimeTypeOfExtension:(NSString *)extension;

/**
 *  获取唯一不重复标识
 *
 *  @return uuid
 */
+ uuid;
/**
 *  网络是否可用
 *
 *  @return YES/NO
 */
+ (BOOL)networkAvailable;

/**
 *  启动网络监听
 *
 *  @param listener 监听处理
 *
 *  @return 监听器
 */
+ (HTReachability)startNetworkNotifier:(NetworkStatusListener)listener;
/**
 *  停止网络监听
 *
 *  @param reachability 监听器
 */
+ (void)stopNetworkNotifier:(HTReachability)reachability;


+ (NSString *)randomString:(NSInteger)length;

@end


@interface NSString (HTUtils)
/**
 *  去除两端空格
 *
 *  @return 字符串
 */
- (NSString *)trim;
/**
 *  指定字符串首次出现的位置索引，区分大小写
 *
 *  @param str 字符串
 *
 *  @return 位置索引
 */
- (NSUInteger)indexOf:(NSString *)str;
/**
 *  指定字符串首次出现的的位置索引
 *
 *  @param str             字符串
 *  @param caseInsensitive 是否区分大小写
 *
 *  @return 位置索引
 */
- (NSUInteger)indexOf:(NSString *)str caseInsensitive:(BOOL)caseInsensitive;
@end

@interface NSData (HTUtils)
/**
 *  转成字符串
 *
 *  @param encoding 编码
 *
 *  @return 字符串
 */
- (NSString *)stringUsingEncoding:(NSStringEncoding)encoding;

@end
@interface UIColor (HTUtils)
/**
 *  生成随机颜色
 *
 *  @return 颜色
 */
+ (UIColor *)randomColor;
@end