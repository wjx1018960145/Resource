//
//  JXUtil.m
//  Framework
//
//  Created by junxinWang on 15-7-24.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "JXUtil.h"

@implementation JXUtil
+ (id)string2json:(NSString *)string {
    if (string.length > 0) {
        NSError* error = nil;
        id object =[NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (error) {
            NSLog(@"string2json(%@) :%@", string, error);
        }
        return object;
    } else {
        return nil;
    }
}

+ (NSString *)pathOfResource:(NSString *)filename {
    return [[NSBundle mainBundle] pathForResource:filename ofType:nil];
}

@end
