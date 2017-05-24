//
//  LeftMenuDelegateImpl.h
//  Framework
//
//  Created by junxinWang on 15-7-22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXTableViewController.h"
#import "JXSplitController.h"
@interface LeftMenuDelegateImpl : NSObject<JXTableViewDelegate>
@property (nonatomic) JXSplitController *slideNav;
@end
